//
//  SynthVC.m
//  Theremin2
//
//  Created by Admin on 04/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "SynthVC.h"
#import "CustomSlider.h"
#import "Dashboard.h"
#import "Keyboard.h"


@interface SynthVC () {
    
    IBOutlet CustomSlider *firstOscillatorVolumeSlider;
    IBOutlet CustomSlider *secondOscillatorVolumeSlider;
    IBOutlet CustomSlider *phaseShiftSlider;
    IBOutlet CustomSlider *reverbSlider;
    
    IBOutlet UIButton *firstOscillatorWaveFormButton;
    IBOutlet UIButton *secondOscillatorWaveFormButton;
    IBOutlet UIButton *secondOscillatorRegisterTypeButton;
    IBOutlet UIButton *saveButton;
    IBOutletCollection(UIButton) NSArray *patchButtons;
    
    IBOutlet UIImageView *firstOscillatorWaveFormImageView;
    IBOutlet UIImageView *secondOscillatorWaveFormImageView;
    IBOutlet UIImageView *secondOscillatorRegisterTypeImageView;
    IBOutletCollection(UIImageView)NSArray *patchIndicators;
    
    IBOutlet UIImageView *keyboardView;
    
    IBOutlet UIView *dashboardQuarter1;
    IBOutlet UIView *dashboardQuarter2;
    IBOutlet UIView *dashboardQuarter3;
    IBOutlet UIView *dashboardQuarter4;
}


@end


@implementation SynthVC


#pragma mark - UIViewController life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray<UIView *> *containers = @[dashboardQuarter1,
                                      dashboardQuarter2,
                                      dashboardQuarter3,
                                      dashboardQuarter4];
    for (int i = 0; i < containers.count; ++i) {
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *nibName = [NSString stringWithFormat:@"DashboardQuarter%d", i + 1];
        UIView *contentView = [[mainBundle loadNibNamed:nibName
                                                  owner:self
                                                options:nil] firstObject];
        contentView.frame = containers[i].bounds;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [containers[i] addSubview:contentView];
    }
    
    NSArray<UIImage *> *images = @[[UIImage imageNamed:@"LightOn.png"],
                                   [UIImage imageNamed:@"LightOff.png"]];
    for (UIImageView *indicator in patchIndicators) {
        
        indicator.animationImages = images;
        indicator.animationDuration = 0.5;
    }
}

- (void)viewDidAppear:(BOOL)animated {

    _keyboard.view = keyboardView;
    [_dashboard dashboardAppeared];
}

#pragma mark - public

- (void)showFirstOscillatorWaveForm:(WaveForm)waveForm {
    
    [self showWaveForm:waveForm inImageView:firstOscillatorWaveFormImageView];
}

- (void)showSecondOscillatorWaveForm:(WaveForm)waveForm {
    
    [self showWaveForm:waveForm inImageView:secondOscillatorWaveFormImageView];
}

- (void)showSecondOscillatorRegisterType:(RegisterType)registerType {
    
    NSString *imageName = @"";
    switch (registerType) {
        case RegisterTypeTwo:
            imageName = @"TwoUp.png";
            break;
        case RegisterTypeFour:
            imageName = @"OneUp.png";
            break;
        case RegisterTypeEight:
            imageName = @"Null.png";
            break;
        case RegisterTypeSixteen:
            imageName = @"OneDown.png";
            break;
        case RegisterTypeThirtyTwo:
            imageName = @"TwoDown.png";
            break;
    }
    secondOscillatorRegisterTypeImageView.image = [UIImage imageNamed:imageName];
}

- (void)setFirstOscillatorVolumeControlValue:(double)newValue {
    
    firstOscillatorVolumeSlider.currentValue = newValue;
}

- (void)setSecondOscillatorVolumeControlValue:(double)newValue {
    
    secondOscillatorVolumeSlider.currentValue = newValue;
}

- (void)setPhaseShiftControlValue:(double)newValue {
    
    phaseShiftSlider.currentValue = newValue;
}

- (void)setReverbControlValue:(double)newValue {
    
    reverbSlider.currentValue = newValue;
}

- (void)lightUpPatch:(NSUInteger)patchIndex {
    
    [self turnOffAllPatchIndicators];
    for (UIImageView *indicator in patchIndicators) {
        
        if (indicator.tag == patchIndex) {
            
            indicator.highlighted = YES;
        }
    }
}

- (void)startFlickerPatchLight:(NSUInteger)patchIndex {
    
    [self turnOffAllPatchIndicators];
    for (UIImageView *indicator in patchIndicators) {
        
        if (indicator.tag == patchIndex) {
            
            [indicator startAnimating];
        }
    }
}

#pragma mark - private

- (void)turnOffAllPatchIndicators {

    for (UIImageView *indicator in patchIndicators) {
        
        [indicator stopAnimating];
        indicator.highlighted = NO;
    }
}

- (void)showWaveForm:(WaveForm)waveForm inImageView:(UIImageView *)imageView {
    
    NSString *imageName = @"";
    switch (waveForm) {
            
        case WaveFormSine:
            imageName = @"SineWave.png";
            break;
        case WaveFormSquare:
            imageName = @"SquareWave.png";
            break;
        case WaveFormRamp:
            imageName = @"RampWave.png";
            break;
        case WaveFormTriangle:
            imageName = @"TriangleWave.png";
            break;
    }
    imageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - controls callbacks

- (IBAction)firstOscillatorWaveFormButtonPressed:(UIButton *)button {
    
    [_dashboard firstOscillatorWaveFormControlSignaled];
}

- (IBAction)secondOscillatorWaveFormButtonPressed:(UIButton *)button {
    
    [_dashboard secondOscillatorWaveFormControlSignaled];
}

- (IBAction)secondOscillatorRegisterTypeButtonPressed:(UIButton *)button {
    
    [_dashboard registerTypeControlSignaled];
}

- (IBAction)saveButtonPressed:(UIButton *)button {
    
    [_dashboard saveContorlSignaled];
}

- (IBAction)patchButtonPressed:(UIButton *)button {
 
    [_dashboard patchControlSignaled:button.tag];
}

- (IBAction)firstOscillatorVolumeSliderValueChanged:(CustomSlider *)slider {
   
    [_dashboard firstOscillatorVolumeControlValueChanged:slider.currentValue];
}

- (IBAction)secondOscillatorVolumeSliderValueChanged:(CustomSlider *)slider {
    
    [_dashboard secondOscillatorVolumeControlValueChanged:slider.currentValue];
}

- (IBAction)phaseShiftSliderValueChanged:(CustomSlider *)slider {

    [_dashboard phaseShiftControlValueChanged:slider.currentValue];
}

- (IBAction)reverbSliderValueChanged:(CustomSlider *)slider {
    
    [_dashboard reverbControlValueChanged:slider.currentValue];
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_keyboard touchBegan:[touches anyObject]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_keyboard touchMoved:[touches anyObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_keyboard touchEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_keyboard touchEnded];
}

@end
