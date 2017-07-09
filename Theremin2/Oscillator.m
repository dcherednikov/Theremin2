//
//  Oscillator.m
//  Theremin2
//
//  Created by Admin on 02/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "Oscillator.h"

@implementation Oscillator

- (double)currentValue {
    
    double value = 0.f;
    switch (_waveForm) {
            
        case WaveFormSine:
            value = [self sine];
            break;
        case WaveFormSquare:
            value = [self square];
            break;
        case WaveFormRamp:
            value = [self ramp];
            break;
        case WaveFormTriangle:
            value = [self triangle];
            break;
    }
    
    return value;
}

- (Float32)sine {
    
    return _amplitude*sin(_phase);
}

- (Float32)square {
    
    if(_phase > M_PI) {
        
        return _amplitude;
    }
    else {
        
        return -(_amplitude);
    }
}

- (Float32)ramp {
    
    return _amplitude*(1 - _phase/M_PI);
}

- (Float32)triangle {
    
    if (_phase <= M_PI/2.0) {
        
        return 2*_amplitude*_phase/M_PI;
    }
    else if (_phase > M_PI/2.0 && _phase <= 3*M_PI/2) {
        
        return _amplitude*(1.0 - 2*(_phase - M_PI/2.0)/M_PI);
    }
    else {
        
        return _amplitude*(2*(_phase - 3*M_PI/2)/M_PI - 1.0);
    }
}

- (NSInteger)octaveMultiplier {
    
    NSInteger octaveMultiplier = 1;
    switch (_registerType) {
            
        case RegisterTypeTwo:
            octaveMultiplier = 4;
            break;
        case RegisterTypeFour:
            octaveMultiplier = 2;
            break;
        case RegisterTypeEight:
            octaveMultiplier = 1;
            break;
        case RegisterTypeSixteen:
            octaveMultiplier = 0.5;
            break;
        case RegisterTypeThirtyTwo:
            octaveMultiplier = 0.25;
            break;
    }
    
    return octaveMultiplier;
}

- (void)incrementPhaseForSampleRate:(NSInteger)sampleRate
                       andPitchInHz:(double)pitch {
    
    double phaseIncrement = (2.0*M_PI/sampleRate)*pitch;
    NSInteger octaveMultiplier = [self octaveMultiplier];
    _phase += octaveMultiplier*phaseIncrement;
    
    if (_phase > 2.0*M_PI) {
        
        _phase -= 2.0*M_PI;
    }
}

- (void)shiftPhase:(double)shift {
    
    _phase += shift;
}

@end
