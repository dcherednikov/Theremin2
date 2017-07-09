//
//  SynthVC.h
//  Theremin2
//
//  Created by Admin on 04/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"


@class Dashboard;
@class Keyboard;


@interface SynthVC : UIViewController

@property (nonatomic, strong) Dashboard *dashboard;
@property (nonatomic, strong) Keyboard *keyboard;

- (void)showFirstOscillatorWaveForm:(WaveForm)waveForm;
- (void)showSecondOscillatorWaveForm:(WaveForm)waveForm;
- (void)showSecondOscillatorRegisterType:(RegisterType)registerType;

- (void)setFirstOscillatorVolumeControlValue:(double)newValue;
- (void)setSecondOscillatorVolumeControlValue:(double)newValue;
- (void)setPhaseShiftControlValue:(double)newValue;
- (void)setReverbControlValue:(double)newValue;

- (void)lightUpPatch:(NSUInteger)patchIndex;
- (void)startFlickerPatchLight:(NSUInteger)patchIndex;

@end
