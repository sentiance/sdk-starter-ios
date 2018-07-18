//
//  ViewController.m
//  SDKStarter
//
//  Created by Gustavo Nascimento on 11/06/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

#import "ViewController.h"

@import SENTSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    [self refreshStatus];
}

- (void) refreshStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Make sure the SDK is initialized or an exception will be thrown.
        if ([[SENTSDK sharedInstance] isInitialised]) {
            self.userIdLabel.text = [[SENTSDK sharedInstance] getUserId];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Our AppDelegate broadcasts when sdk auth was successful
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStatus)
                                                 name:@"SdkAuthenticationSuccess"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
