//
//  AppDelegate.m
//  SDKStarter
//
//  Created by Roel Berger on 11/05/16.
//  Copyright © 2016 Sentiance. All rights reserved.
//

#import "AppDelegate.h"

#import <SENTTransportDetectionSDK/SENTStatusMessage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeSentianceSdk:launchOptions];
    
    return YES;
}



- (void) initializeSentianceSdk:(NSDictionary*) launchOptions {
    // SDK configuration
    NSDictionary* config = @{
                             @"appid": @"YOUR_APP_ID",
                             @"secret": @"YOUR_APP_SECRET",
                             @"appLaunchOptions": launchOptions == nil ? @{} : launchOptions
                             };
    
    // Initialize and start the Sentiance SDK module
    // The first time an app installs on a device, the SDK requires internet to create a Sentiance platform userid
    self.sentianceSdk = [[SENTTransportDetectionSDK alloc] initWithConfigurationData:config];
    
    // Register this instance as SENTTransportDetectionSDKDelegate
    self.sentianceSdk.delegate = self;
}



// Called when the SDK was able to create a platform user
- (void) didAuthenticationSuccess {
    NSLog(@"==== Sentiance SDK started, version: %@",
        [SENTTransportDetectionSDK getSDKVersion]);
    
    NSLog(@"==== Sentiance platform user id for this install: %@",
          [SENTTransportDetectionSDK getUserId]);
    
    NSLog(@"==== Authorization token that can be used to query the HTTP API: Bearer %@",
          [SENTTransportDetectionSDK getUserToken]);
    
    
    // Notify view controller of successful authentication
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SdkAuthenticationSuccess"
     object:nil];
}



// Called when the SDK could not create a platform user
- (void) didAuthenticationFailed:(NSError *)error {
    NSLog(@"Error launching Sentiance SDK: %@", error);
    // Here you should wait, inform the user to ensure an internet connection and retry initializeSentianceSdk
    
    
    
    // Some SDK starter specific help
    if( error.code == 400 ) {
        NSLog(@"You should create a developer account on https://audience.sentiance.com/developers and afterwards register a Sentiance application on https://audience.sentiance.com/apps");
        NSLog(@"This will give you an application ID and secret which you can use to replace YOUR_APP_ID and YOUR_APP_SECRET in AppDelegate.m");
    }
}



@end
