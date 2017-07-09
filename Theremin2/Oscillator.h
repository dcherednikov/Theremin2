//
//  Oscillator.h
//  Theremin2
//
//  Created by Admin on 02/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface Oscillator : NSObject

@property (nonatomic, assign) double amplitude;
@property (nonatomic, assign) double phase;
@property (nonatomic, assign) WaveForm waveForm;
@property (nonatomic, assign) RegisterType registerType;

@property (nonatomic, readonly, assign) double currentValue;

- (void)incrementPhaseForSampleRate:(NSInteger)sampleRate
                       andPitchInHz:(double)pitch;
- (void)shiftPhase:(double)shift;

@end
