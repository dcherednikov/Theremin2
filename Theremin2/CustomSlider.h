//
//  CustomSlider.h
//  Theremin2
//
//  Created by MacBookPro on 18.02.16.
//  Copyright (c) 2016 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomSlider : UIControl 

@property (nonatomic, assign) IBInspectable CGFloat maxValue;
@property (nonatomic, assign) IBInspectable CGFloat minValue;
@property (nonatomic, assign) IBInspectable CGFloat currentValue;
@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, strong) IBInspectable UIImage *trackImage;
@property (nonatomic, strong) IBInspectable UIImage *thumbImage;

@end
