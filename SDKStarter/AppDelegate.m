//
//  AppDelegate.m
//  SDKStarter
//
//  Created by Gustavo Nascimento on 11/06/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.sdkService = [[SentianceSDKService alloc] init];
    
    // Sentiance SDK requires `launchOptions` parameter to make better decisions
    [self.sdkService launchWithOptions:launchOptions];
    
    return YES;
}

@end
