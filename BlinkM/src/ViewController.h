//
//  ViewController.h
//  BareMinimum
//
//  Created by Shigeru Kobayashi on 2013/05/12.
//  Copyright (c) 2013年 Shigeru Kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlinkM.h"

@interface ViewController : UIViewController
{
    BlinkM *blinkM;
}

- (IBAction)fadeToRandomColorButtonPressed:(id)sender;

@end
