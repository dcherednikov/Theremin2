//
//  Patch.m
//  Theremin2
//
//  Created by Admin on 06/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "Patch.h"

@implementation Patch

- (instancetype)initWithProperties:(NSDictionary *)properties {
    
    self = [super init];
    if (self) {
        
        _firstOscillatorVolume = ((NSNumber *)[properties valueForKey:@"firstOscillatorVolume"]).doubleValue;
        _secondOscillatorVolume = ((NSNumber *)[properties valueForKey:@"secondOscillatorVolume"]).doubleValue;
        _firstOscillatorWaveForm = ((NSNumber *)[properties valueForKey:@"firstOscillatorWaveForm"]).integerValue;
        _secondOscillatorWaveForm = ((NSNumber *)[properties valueForKey:@"secondOscillatorWaveForm"]).integerValue;
        _secondOscillatorRegisterType = ((NSNumber *)[properties valueForKey:@"secondOscillatorRegisterType"]).integerValue;
        _phaseShift = ((NSNumber *)[properties valueForKey:@"phaseShift"]).doubleValue;
        _reverb = ((NSNumber *)[properties valueForKey:@"reverb"]).doubleValue;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
    
        _firstOscillatorVolume = [aDecoder decodeDoubleForKey:@"firstOscillatorVolume"];
        _secondOscillatorVolume = [aDecoder decodeDoubleForKey:@"secondOscillatorVolume"];
        _firstOscillatorWaveForm = [aDecoder decodeIntegerForKey:@"firstOscillatorWaveForm"];
        _secondOscillatorWaveForm = [aDecoder decodeIntegerForKey:@"secondOscillatorWaveForm"];
        _secondOscillatorRegisterType = [aDecoder decodeIntegerForKey:@"secondOscillatorRegisterType"];
        _phaseShift = [aDecoder decodeDoubleForKey:@"phaseShift"];
        _reverb = [aDecoder decodeDoubleForKey:@"reverb"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeDouble:_firstOscillatorVolume forKey:@"firstOscillatorVolume"];
    [aCoder encodeDouble:_secondOscillatorVolume forKey:@"secondOscillatorVolume"];
    [aCoder encodeInteger:_firstOscillatorWaveForm forKey:@"firstOscillatorWaveForm"];
    [aCoder encodeInteger:_secondOscillatorWaveForm forKey:@"secondOscillatorWaveForm"];
    [aCoder encodeInteger:_secondOscillatorRegisterType forKey:@"secondOscillatorRegisterType"];
    [aCoder encodeDouble:_phaseShift forKey:@"phaseShift"];
    [aCoder encodeDouble:_reverb forKey:@"reverb"];
}

@end
