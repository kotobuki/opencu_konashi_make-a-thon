//
//  ViewController.m
//  BareMinimum
//
//  Created by Shigeru Kobayashi on 2013/05/12.
//  Copyright (c) 2013年 Shigeru Kobayashi. All rights reserved.
//

#import "ViewController.h"

// Import the konashi library
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Initialize the variable to show LED state
    // LEDの状態を示す変数を初期化
    _ledIsOn = NO;
    
    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
    [Konashi find];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");

    if (![Konashi isConnected]) {
        return;
    }
    
    if (_ledIsOn) {
        [Konashi digitalWrite:LED2 value:LOW];
        _ledIsOn = NO;
    } else {
        [Konashi digitalWrite:LED2 value:HIGH];
        _ledIsOn = YES;
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"ended");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancelled");
}

- (void)setup
{
    [Konashi pinMode:LED2 mode:OUTPUT];
}

@end
