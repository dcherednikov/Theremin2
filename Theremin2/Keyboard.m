//
//  Keyboard.m
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "Keyboard.h"
#import "Synthesizer.h"
#import <UIKit/UIKit.h>

const NSInteger numberOfKeys = 37;
const CGFloat a2inHz = 110.f;


@interface Keyboard () {
    
    Synthesizer *synthesizer;
    
    CGFloat keyWidth;
    CGFloat minLogValue;
    CGFloat octaveWidth;
    CGFloat volumeFactor;
}

@end


@implementation Keyboard

- (instancetype)initWithSynthesizer:(Synthesizer *)inSynthesizer {
    
    self = [super init];
    if (self) {
        
        synthesizer = inSynthesizer;
    }
    
    return self;
}

- (void)setView:(UIView *)view {
    
    _view = view;
    
    minLogValue = logf(a2inHz)/logf(2.0) + 3.f/12.f; // keyboard starts with c3 (a2 + 3 keys up)
    keyWidth = view.frame.size.width/numberOfKeys;
    
    NSInteger numberOfOctaves = numberOfKeys/12;
    NSInteger numberOfExtraKeys = numberOfKeys%numberOfOctaves;
    CGFloat widthOfAllFullOctaves = view.frame.size.width - numberOfExtraKeys*keyWidth;
    octaveWidth = widthOfAllFullOctaves/numberOfOctaves;
    
    volumeFactor = 1.0/view.frame.size.height;
}

- (void)touchBegan:(UITouch *)touch {
    
    if (!_view) {
        
        return;
    }
    CGPoint point = [touch locationInView:_view];
    if (!CGRectContainsPoint(_view.frame, point)) {
        
        return;
    }
    CGFloat logValue = minLogValue + (point.x - keyWidth/2.0)/octaveWidth;
    
    double pitch = pow(2, logValue);
    double volume = 1 - point.y*volumeFactor;
    [synthesizer playPitchInHz:pitch atVolume:volume];
}

- (void)touchMoved:(UITouch *)touch {

    if (!_view) {
        
        [synthesizer stop];
        return;
    }
    CGPoint point = [touch locationInView:_view];
    CGFloat logValue = minLogValue + (point.x - keyWidth/2.0)/octaveWidth;
    
    double pitch = pow(2, logValue);
    double volume = 1.f - point.y*volumeFactor;
    volume = volume <= 1.f ? volume : 1.f;
    [synthesizer playPitchInHz:pitch atVolume:volume];
}

- (void)touchEnded {
    
    [synthesizer stop];
}

@end
