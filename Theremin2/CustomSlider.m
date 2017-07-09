//
//  CustomSlider.m
//  Theremin2
//
//  Created by MacBookPro on 18.02.16.
//  Copyright (c) 2016 MacBookPro. All rights reserved.
//

#import "CustomSlider.h"

static const CGFloat defaultMinValue = 0.f;
static const CGFloat defaultMaxFalue = 1.f;

@implementation CustomSlider {
    
    CGFloat thumbWidth;
    CGFloat useableLength;
    BOOL selected;
        
    CGPoint touchPoint;
    
    UIImageView *trackView;
    UIImageView *thumbView;
    
    UILabel *titleLabel;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self createSubviews];
        [self setDefaultValues];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubviews];
        [self setDefaultValues];
        [self setupFrames];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [self setupFrames];
}

- (void)createSubviews {
    
    trackView = [[UIImageView alloc] init];
    titleLabel = [[UILabel alloc] init];
    thumbView = [[UIImageView alloc] init];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:trackView];
    [self addSubview:thumbView];
    [self addSubview:titleLabel];
}

- (void)setDefaultValues {

    self.backgroundColor = [UIColor clearColor];
    
    _minValue = defaultMinValue;
    _maxValue = defaultMaxFalue;
    _currentValue = _minValue + (_maxValue - _minValue)/2.0;
}

- (void)setupFrames {
    
    if (!trackView || !titleLabel || ! thumbView) {
        
        [self createSubviews];
    }
    trackView.frame = CGRectMake(0.f,
                                 0.f,
                                 self.frame.size.width,
                                 self.frame.size.height/7.f);
    [trackView setCenter:CGPointMake(self.frame.size.width/2.f,
                                     self.frame.size.height/2.f)];
    thumbWidth = self.frame.size.height;
    useableLength = self.bounds.size.width - thumbWidth;
    if (_minValue <= _currentValue && _currentValue <= _maxValue && _minValue != _maxValue) {
        
        CGFloat thumbPosition = [self positionForValue:self.currentValue];
        thumbView.frame = CGRectMake(thumbPosition - (thumbWidth/2.f),
                                     0.f,
                                     thumbWidth,
                                     thumbWidth);
        titleLabel.frame = thumbView.frame;
    }
}

- (CGFloat)positionForValue:(CGFloat)value {
    
    CGFloat ratio = (_currentValue - _minValue)/(_maxValue - _minValue);
    return ratio*useableLength + thumbWidth/2.0;
}

#pragma mark - setters

- (void)setMinValue:(CGFloat)minValue {
    
    _minValue = minValue;
    [self setupFrames];
}

- (void)setMaxValue:(CGFloat)maxValue {
    
    _maxValue = maxValue;
    [self setupFrames];
}

- (void)setCurrentValue:(CGFloat)currentValue {
    
    _currentValue = currentValue;
    [self setupFrames];
}

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    titleLabel.text = _title;
}

- (void)setTrackImage:(UIImage *)trackImage {

    _trackImage = trackImage;
    trackView.image = _trackImage;
    [self setupFrames];
}

- (void)setThumbImage:(UIImage *)thumbImage {
    
    _thumbImage = thumbImage;
    thumbView.image = _thumbImage;
    [self setupFrames];
}

#pragma mark - tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(thumbView.frame, touchPoint))
    {
        selected = YES;
    }
    
    return selected;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (selected) {
        
        touchPoint = [touch locationInView:self];
        _currentValue = (touchPoint.x - thumbWidth/2.0)*(_maxValue - _minValue)/useableLength + _minValue;
    }
    
    if (_currentValue < _minValue) {
        
        _currentValue = _minValue;
    }
    else if (_currentValue > _maxValue) {
        
        _currentValue = _maxValue;
    }

    [self setupFrames];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    selected = NO;
}

@end
