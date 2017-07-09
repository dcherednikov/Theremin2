//
//  Synthesizer.h
//  Theremin2
//
//  Created by Admin on 02/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patch.h"


@class Oscillator;


@interface Synthesizer : NSObject

@property (nonatomic, readonly, strong) Oscillator *firstOscillator;
@property (nonatomic, readonly, strong) Oscillator *secondOscillator;
@property (nonatomic, assign) double phaseShift;
@property (nonatomic, assign) double reverb;
@property (nonatomic, readonly, assign) double pitch;
@property (nonatomic, copy) Patch *currentPatch;

- (void)playPitchInHz:(double)pitch atVolume:(double)volume;
- (void)stop;

@end
