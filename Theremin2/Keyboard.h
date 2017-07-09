//
//  Keyboard.h
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Synthesizer;
@class UITouch;
@class UIView;

@interface Keyboard : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

- (void)touchBegan:(UITouch *)touch;
- (void)touchMoved:(UITouch *)touch;
- (void)touchEnded;

- (instancetype)initWithSynthesizer:(Synthesizer *)synthesizer;
- (instancetype)init NS_UNAVAILABLE;

@end
