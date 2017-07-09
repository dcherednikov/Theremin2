//
//  AppDelegate.m
//  Theremin2
//
//  Created by MacBookPro on 15.02.16.
//  Copyright (c) 2016 MacBookPro. All rights reserved.
//

#import "AppDelegate.h"
#import "SynthVC.h"
#import "Synthesizer.h"
#import "Dashboard.h"
#import "Keyboard.h"
#import "PatchBank.h"

@interface AppDelegate ()

@end


@implementation AppDelegate {
    
    PatchBank *patchBank;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CGRect frame = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc] initWithFrame:frame];
    
    Synthesizer *synthesizer = [[Synthesizer alloc] init];
    Keyboard *keyboard = [[Keyboard alloc] initWithSynthesizer:synthesizer];
    patchBank = [[PatchBank alloc] init];
    Dashboard *dashboard = [[Dashboard alloc] initWithSynthesizer:synthesizer
                                                     andPatchBank:patchBank];
    SynthVC *synthVC = [[[NSBundle mainBundle] loadNibNamed:@"SynthVC"
                                                      owner:nil
                                                    options:nil] firstObject];
    synthVC.keyboard = keyboard;
    synthVC.dashboard = dashboard;
    dashboard.synthVC = synthVC;
    _window.rootViewController = synthVC;

    [_window makeKeyAndVisible];
    
    return YES;
}


@end
