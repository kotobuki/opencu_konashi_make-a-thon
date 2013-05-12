//
//  ViewController.h
//  BareMinimum
//
//  Created by Shigeru Kobayashi on 2013/05/12.
//  Copyright (c) 2013年 Shigeru Kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *analogInputController;
@property (weak, nonatomic) IBOutlet UISlider *analogOutputController;

- (IBAction)findButtonPressed:(id)sender;
- (IBAction)analogOutputControllerChanged:(id)sender;

@end
