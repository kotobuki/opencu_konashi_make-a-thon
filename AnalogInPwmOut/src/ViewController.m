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
    // Set mode for each pin
    [Konashi pinMode:S1 mode:INPUT];
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi pwmMode:LED2 mode:KONASHI_PWM_ENABLE_LED_MODE];

    // Add an observer to observe changes on AIO0
    [Konashi addObserver:self selector:@selector(analogInputUpdated) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
    
    // Create and fire a timer to request reading AIO0
    NSTimer *analogInputTimer = [NSTimer
                                 scheduledTimerWithTimeInterval:0.1f
                                 target:self
                                 selector:@selector(requestAnalogRead:)
                                 userInfo:nil
                                 repeats:YES
                                 ];
    [analogInputTimer fire];
}

- (void)requestAnalogRead:(NSTimer*)timer
{
    [Konashi analogReadRequest:AIO0];
}

- (void)analogInputUpdated
{
    int voltage = [Konashi analogRead:AIO0];
    [self.analogInputController setValue:voltage];
}

- (IBAction)analogOutputControllerChanged:(id)sender {
    int ratio = (int)round([self.analogOutputController value]);
    [Konashi pwmLedDrive:LED2 dutyRatio:ratio];
}

@end
