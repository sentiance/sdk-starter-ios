//
//  SentianceSDKService.m
//  SDKStarter
//
//  Created by Ilyas Yurdaon on 2020-05-04.
//  Copyright © 2020 Sentiance. All rights reserved.
//

#import "SentianceSDKService.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreMotion/CMMotionActivityManager.h>
@import SENTSDK;


NSNotificationName const SentianceSDKDidLaunchNotification = @"SentianceSDKDidLaunch";


// Set the AppID and secret values that you received from our team
NSString * const AppId = @"";
NSString * const AppSecret = @"";


@interface SentianceSDKService (Private)

- (void)_requestLocationAuthorization;
- (void)_requestMotionActivityAuthorization;

- (void)_initializationDidSucceed;

- (void)_start;

@end


@implementation SentianceSDKService {
@private
    CLLocationManager *_locationManager;
    CMMotionActivityManager *_motionActivityManager;
    SENTSDK *_sdk;
}

@dynamic userId;
@dynamic isLaunched;

- (NSString *)userId {
    if(_sdk == nil) {
        return @"-";
    }

    switch ([_sdk getInitState]) {
        case SENTInitialized:
        {
            return [_sdk getUserId];
        }
            break;
            
        default:
        {
            return @"-";
        }
            break;
    }
}

- (BOOL)isLaunched {
    if(_sdk == nil) {
        return NO;
    }
    
    // [SENTSDK getInitState] provides the current initialization status of the Sentiance SDK
    return [_sdk getInitState] == SENTInitialized;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sdk = [SENTSDK sharedInstance];
        _locationManager = [[CLLocationManager alloc] init];
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
    }
    return self;
}

- (void)launchWithOptions:(NSDictionary *)launchOptions {    
    // 1. Request location authorization
    [self _requestLocationAuthorization];
    
    // 2. Request motion activity authorization
    [self _requestMotionActivityAuthorization];

    // 3. Prepare a SENTConfig object using your credentials
    SENTConfig *configuration = [[SENTConfig alloc] initWithAppId:AppId
                                                           secret:AppSecret
                                                    launchOptions:launchOptions];

    // 4. Initialize the Sentiance SDK using the SENTConfig object created above
    // (Note that the SDK requires network connectivity to create a Sentiance Platform UserID the first time your app is installed on a device)
    [_sdk initWithConfig:configuration
                 success:^{
        // Notify your app that the Sentiance SDK has been initialized
        [self _initializationDidSucceed];
        
        // Now that the Sentiance SDK has passed initialization phase successfully using the given credentials,
        // you can start the detections
        [self _start];
    } failure:^(SENTInitIssue issue) {
        NSLog(@"Sentiance SDK has failed to initialize with the issue of type %lu", issue);
    }];
    
    // Optional: Set a callback for vehicle crash events
    [_sdk setCrashListener:^(NSDate *date, CLLocation *lastKnownLocation) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE, d MMM yyyy HH:mm:ss Z";
        
        NSLog(@"A vehicle crash has been detected.  \n\tTime: %@    \n\tLocation: %@",
              [dateFormatter stringFromDate:date],
              [lastKnownLocation description]);
    }];
}

- (void)reset:(void(^)(void))success {
    // Optional: Restore the Sentiance SDK to factory settings
    [_sdk reset:^{
        success();
    } failure:^(SENTResetFailureReason reason) {
        NSLog(@"Sentiance SDK has failed to reset with the issue of type %lu", reason);
    }];
}

@end


@implementation SentianceSDKService (Private)

- (void)_requestLocationAuthorization {
    // Sentiance SDK requires 'Always' location authorization
    [_locationManager requestAlwaysAuthorization];
}

- (void)_requestMotionActivityAuthorization {
    // iOS does not provide an explicit method to request motion activity authorization from the user.
    // Using 'stopActivityUpdates' method is one of the ways to get this authorization. Sentiance SDK starts the motion activity updates whenever it's needed.
    // You can use any other method that triggers motion activity prompt based on your need as well.
    [_motionActivityManager stopActivityUpdates];
}

- (void)_initializationDidSucceed {
    NSLog(@"==== Sentiance SDK started. SDK version: %@", [_sdk getVersion]);
    NSLog(@"==== Sentiance platform user id for this install: %@", [_sdk getUserId]);

    [_sdk getUserAccessToken:^(NSString *token) {
        NSLog(@"==== Authorization token that can be used to query the HTTP API: Bearer %@",
              token);
    } failure:^{
        NSLog(@"Could not retrieve token.");
    }];

    // Notify the rest of the app about the successful initialization
    [[NSNotificationCenter defaultCenter] postNotificationName:SentianceSDKDidLaunchNotification
                                                        object:nil];
}

- (void)_start {
    // 5. Start detections
    [_sdk start:^(SENTSDKStatus *status) {
        if ([status startStatus] == SENTStartStatusStarted) {
            NSLog(@"SDK started properly.");
        } else if ([status startStatus] == SENTStartStatusPending) {
            NSLog(@"Something prevented the SDK to start properly (see location authorization settings). Once fixed, the SDK will start automatically.");
        }
        else {
            NSLog(@"SDK could not be started.");
        }
    }];
}

@end
