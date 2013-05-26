//
//  ViewController.h
//  BareMinimum
//
//  Created by Shigeru Kobayashi on 2013/05/12.
//  Copyright (c) 2013年 Shigeru Kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    int _thresholdLow;
    int _thresholdHigh;
    int _lastState;
}

@property (weak, nonatomic) IBOutlet UISlider *thresholdLowSlider;
@property (weak, nonatomic) IBOutlet UISlider *thresholdHighSlider;
@property (weak, nonatomic) IBOutlet UISlider *analogInputIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *outputStateIndicator;
@property (weak, nonatomic) IBOutlet UILabel *analogInputLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdHighLabel;
@property (weak, nonatomic) IBOutlet UITextView *usageTextView;

- (IBAction)thresholdLowChanged:(id)sender;
- (IBAction)thresholdHighChanged:(id)sender;

@end
