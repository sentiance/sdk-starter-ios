//
//  SentianceSDKService.h
//  SDKStarter
//
//  Created by Ilyas Yurdaon on 2020-05-04.
//  Copyright © 2020 Sentiance. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSNotificationName const SentianceSDKDidLaunchNotification;


@interface SentianceSDKService : NSObject

@property (strong, nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) BOOL isLaunched;

- (void)launchWithOptions:(NSDictionary *)launchOptions;
- (void)reset:(void(^)(void))success;

@end
