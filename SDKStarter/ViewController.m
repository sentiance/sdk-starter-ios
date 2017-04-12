//
//  ViewController.m
//  SDKStarter
//
//  Created by Roel Berger on 11/05/16.
//  Copyright © 2016 Sentiance. All rights reserved.
//

#import "ViewController.h"

#import <SENTTransportDetectionSDK/SENTTransportDetectionSDK.h>


@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    [self refreshStatus];
}

- (void) refreshStatus {
    // Make sure the SDK is initialized or an exception will be thrown.
    if ([[SENTSDK sharedInstance] isInitialised]) {
        self.userIdLabel.text = [[SENTSDK sharedInstance] getUserId];

        // You can use the status message for more information
        SENTSDKStatus* status = [[SENTSDK sharedInstance] getSdkStatus];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Our AppDelegate broadcasts when sdk auth was successful
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStatus)
                                                 name:@"SdkAuthenticationSuccess"
                                               object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
