//
//  AppDelegate.h
//  SDKStarter
//
//  Created by Gustavo Nascimento on 11/06/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SentianceSDKService.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SentianceSDKService *sdkService;

@end

