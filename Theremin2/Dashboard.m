//
//  Dashboard.m
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "Dashboard.h"
#import "Oscillator.h"
#import "Synthesizer.h"
#import "PatchBank.h"
#import "SynthVC.h"


@implementation Dashboard {
    
    Synthesizer *synthesizer;
    PatchBank *patchBank;
}

- (instancetype)initWithSynthesizer:(Synthesizer *)inSynthesizer
                       andPatchBank:(PatchBank *)inPatchBank {
    
    self = [super init];
    if (self) {
        
        synthesizer = inSynthesizer;
        patchBank = inPatchBank;
    }
    
    return self;
}

- (void)firstOscillatorWaveFormControlSignaled {
    
    [self switchWaveFormForOscillator:synthesizer.firstOscillator];
    [_synthVC showFirstOscillatorWaveForm:synthesizer.firstOscillator.waveForm];
}

- (void)secondOscillatorWaveFormControlSignaled {
    
    [self switchWaveFormForOscillator:synthesizer.secondOscillator];
    [_synthVC showSecondOscillatorWaveForm:synthesizer.secondOscillator.waveForm];
}

- (void)registerTypeControlSignaled {
    
    [self switchRegisterTypeForOscillator:synthesizer.secondOscillator];
    [_synthVC showSecondOscillatorRegisterType:synthesizer.secondOscillator.registerType];
}

- (void)saveContorlSignaled {
    
    if (!patchBank.isReadyToSave) {
        
        [patchBank prepareForSaving];
        [_synthVC startFlickerPatchLight:patchBank.selectedPatchIndex];
    }
    else {
        
        Patch *patch = synthesizer.currentPatch;
        [patchBank savePatchAtSelectedIndex:patch];
        [self showAllValues];
    }
}

- (void)patchControlSignaled:(NSInteger)controlIndex {
    
    if (patchBank.selectedPatchIndex == controlIndex) {
        
        return;
    }
    patchBank.selectedPatchIndex = controlIndex;
    if (!patchBank.isReadyToSave) {
        
        Patch *patch = [patchBank patchAtSelectedIndex];
        synthesizer.currentPatch = patch;
        [self showAllValues];
    }
    else {
        
        [_synthVC startFlickerPatchLight:patchBank.selectedPatchIndex];
    }
}

- (void)firstOscillatorVolumeControlValueChanged:(double)newValue {
    
    synthesizer.firstOscillator.amplitude = newValue;
}

- (void)secondOscillatorVolumeControlValueChanged:(double)newValue {
    
    synthesizer.secondOscillator.amplitude = newValue;
}

- (void)phaseShiftControlValueChanged:(double)newValue {
    
    synthesizer.phaseShift = newValue;
}

- (void)reverbControlValueChanged:(double)newValue {
    
    synthesizer.reverb = newValue;
}

- (void)dashboardAppeared {
    
    Patch *patch = [patchBank patchAtSelectedIndex];
    synthesizer.currentPatch = patch;
    [self showAllValues];
}

#pragma mark - private

- (void)switchWaveFormForOscillator:(Oscillator *)oscillator {
    
    WaveForm waveForm = oscillator.waveForm;
    switch (waveForm) {
            
        case WaveFormSine:
            waveForm = WaveFormSquare;
            break;
        case WaveFormSquare:
            waveForm = WaveFormRamp;
            break;
        case WaveFormRamp:
            waveForm = WaveFormTriangle;
            break;
        case WaveFormTriangle:
            waveForm = WaveFormSine;
            break;
    }
    oscillator.waveForm = waveForm;
}

- (void)switchRegisterTypeForOscillator:(Oscillator *)oscillator {

    RegisterType registerType = oscillator.registerType;
    switch (registerType) {
            
        case RegisterTypeTwo:
            registerType = RegisterTypeFour;
            break;
        case RegisterTypeFour:
            registerType = RegisterTypeEight;
            break;
        case RegisterTypeEight:
            registerType = RegisterTypeSixteen;
            break;
        case RegisterTypeSixteen:
            registerType = RegisterTypeThirtyTwo;
            break;
        case RegisterTypeThirtyTwo:
            registerType = RegisterTypeTwo;
            break;
    }
    oscillator.registerType = registerType;
}

- (void)showAllValues {
    
    [_synthVC showFirstOscillatorWaveForm:synthesizer.firstOscillator.waveForm];
    [_synthVC showSecondOscillatorWaveForm:synthesizer.secondOscillator.waveForm];
    [_synthVC showSecondOscillatorRegisterType:synthesizer.secondOscillator.registerType];
    [_synthVC setFirstOscillatorVolumeControlValue:synthesizer.firstOscillator.amplitude];
    [_synthVC setSecondOscillatorVolumeControlValue:synthesizer.secondOscillator.amplitude];
    [_synthVC setPhaseShiftControlValue:synthesizer.phaseShift];
    [_synthVC setReverbControlValue:synthesizer.reverb];
    
    [_synthVC lightUpPatch:patchBank.selectedPatchIndex];
}

@end
