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

    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
    [Konashi find];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    NSTimer *signalStrengthRequestTimer = [NSTimer
                                 scheduledTimerWithTimeInterval:0.5f
                                 target:self
                                 selector:@selector(requestSignalStrength:)
                                 userInfo:nil
                                 repeats:YES
                                 ];
    [signalStrengthRequestTimer fire];

    [Konashi addObserver:self selector:@selector(updateSignalStrength) name:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];
}

- (void) requestSignalStrength:(NSTimer*)timer
{
    [Konashi signalStrengthReadRequest];
}

- (void) updateSignalStrength
{
    float progress = -1.0 * [Konashi signalStrengthRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.signalStrengthIndicator.progress = progress / 100;
}

@end
