//
//  ViewController.m
//  SDKStarter
//
//  Created by Gustavo Nascimento on 11/06/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController (Private)

- (void)_refreshStatus;

- (void)_initializeSDK;
- (void)_resetSDK;

@end


@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    [self _refreshStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_refreshStatus)
                                                 name:SentianceSDKDidLaunchNotification
                                               object:nil];
}

- (IBAction)sdkAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Initialize or reset the Sentiance SDK based on its current state
    if(appDelegate.sdkService.isLaunched) {
        [self _resetSDK];
    } else {
        [self _initializeSDK];
    }
}

@end


@implementation ViewController (Private)

- (void)_refreshStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        // Retrieve the current userId from the Sentiance SDK
        self.userIdLabel.text = appDelegate.sdkService.userId;
        
        // Adjust the button title based on the Sentiance SDK's current state
        NSString *actionButtonTitle = appDelegate.sdkService.isLaunched
        ? @"Reset the SDK"
        : @"Initialize the SDK";
        [self.sdkActionButton setTitle:actionButtonTitle
                              forState:UIControlStateNormal];
    });
}

- (void)_initializeSDK {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Should not attempt to initialize the Sentiance SDK if it's already initialized
    if(appDelegate.sdkService.isLaunched) {
        return;
    }
    
    [appDelegate.sdkService launchWithOptions:nil];
}

- (void)_resetSDK {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if(!appDelegate.sdkService.isLaunched) {
            return;
        }
        
        [appDelegate.sdkService reset:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI if the Sentiance SDK has been reset successfully
                [self _refreshStatus];
            });
        }];
    });
}

@end
