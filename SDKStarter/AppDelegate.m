//
//  AppDelegate.m
//  SDKStarter
//
//  Created by Gustavo Nascimento on 11/06/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

#import "AppDelegate.h"
@import SENTSDK;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeSentianceSdk:launchOptions];
    
    return YES;
}

- (void) initializeSentianceSdk:(NSDictionary*) launchOptions {
    NSString *appId = @"";
    NSString *secret = @"";


    SENTConfig *conf = [[SENTConfig alloc] initWithAppId:appId secret:secret launchOptions:launchOptions];

    // Initialize and start the Sentiance SDK module
    // The first time an app installs on a device, the SDK requires internet to create a Sentiance platform userid
    [[SENTSDK sharedInstance] initWithConfig:conf success:^{
        // At this point the OS will ask the user to approve the permissions
        [self didAuthenticationSuccess];
        [self startSentianceSdk];
    } failure:^(SENTInitIssue issue) {
        NSLog(@"Issue: %lu", issue);
    }];
}

// Called when the SDK was able to create a platform user
- (void) didAuthenticationSuccess {
    NSLog(@"==== Sentiance SDK started, version: %@",
        [[SENTSDK sharedInstance] getVersion]);
    
    NSLog(@"==== Sentiance platform user id for this install: %@",
          [[SENTSDK sharedInstance] getUserId]);

    [[SENTSDK sharedInstance] getUserAccessToken:^(NSString *token) {
        NSLog(@"==== Authorization token that can be used to query the HTTP API: Bearer %@",
              token);
    } failure:^{
        NSLog(@"Could not retrieve token");
    }];

    // Notify view controller of successful authentication
    [[NSNotificationCenter defaultCenter]
      postNotificationName:@"SdkAuthenticationSuccess"
      object:nil];
}

- (void) startSentianceSdk {
    [[SENTSDK sharedInstance] start:^(SENTSDKStatus *status) {
        if ([status startStatus] == SENTStartStatusStarted) {
            NSLog(@"SDK started properly");
        } else if ([status startStatus] == SENTStartStatusPending) {
            NSLog(@"Something prevented the SDK to start properly (see location permission settings). Once fixed, the SDK will start automatically");
        }
        else {
            NSLog(@"SDK did not start");
        }
    }];
}
@end
