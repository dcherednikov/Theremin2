//
//  Dashboard.h
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Synthesizer;
@class PatchBank;
@class SynthVC;

@interface Dashboard : NSObject

@property (nonatomic, weak) SynthVC *synthVC;
@property (nonatomic, assign) NSInteger currentPatchNumber;

- (void)firstOscillatorWaveFormControlSignaled;
- (void)secondOscillatorWaveFormControlSignaled;
- (void)registerTypeControlSignaled;
- (void)saveContorlSignaled;
- (void)patchControlSignaled:(NSInteger)controlIndex;

- (void)firstOscillatorVolumeControlValueChanged:(double)newValue;
- (void)secondOscillatorVolumeControlValueChanged:(double)newValue;
- (void)phaseShiftControlValueChanged:(double)newValue;
- (void)reverbControlValueChanged:(double)newValue;

- (void)dashboardAppeared;
- (instancetype)initWithSynthesizer:(Synthesizer *)synthesizer
                       andPatchBank:(PatchBank *)patchBank;

@end
