//
//  Patch.h
//  Theremin2
//
//  Created by Admin on 04/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

//#ifndef Patch_h
//#define Patch_h
//#import "Enums.h"
//
//typedef struct Patch {
//
//    double firstOscillatorVolume;
//    double secondOscillatorVolume;
//    WaveForm firstOscillatorWaveForm;
//    WaveForm secondOscillatorWaveForm;
//    RegisterType secondOscillatorRegisterType;
//    double reverb;
//    double phaseShift;
//} Patch;
//
//#endif /* Patch_h */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Enums.h"

@interface Patch : NSObject <NSCoding>

@property (nonatomic, assign) CGFloat firstOscillatorVolume;
@property (nonatomic, assign) CGFloat secondOscillatorVolume;
@property (nonatomic, assign) WaveForm firstOscillatorWaveForm;
@property (nonatomic, assign) WaveForm secondOscillatorWaveForm;
@property (nonatomic, assign) RegisterType secondOscillatorRegisterType;
@property (nonatomic, assign) CGFloat phaseShift;
@property (nonatomic, assign) CGFloat reverb;

- (instancetype)initWithProperties:(NSDictionary *)properties;

@end
