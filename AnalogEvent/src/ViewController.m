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

#define SENSOR_STATE_UNKNOWN -1
#define SENSOR_STATE_LOW    0
#define SENSOR_STATE_HIGH    1

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.usageTextView setText:NSLocalizedString(@"usage", nil)];
    
    // Get initial values from sliders
    [self updateThresholdLow];
    [self updateThresholdHigh];
    _lastState = SENSOR_STATE_UNKNOWN;
    
    // Initialize
    [Konashi initialize];
    
    // Add an observer for KONASHI_EVENT_READY events
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findButtonPressed:(id)sender
{
    [Konashi find];
}

- (IBAction)thresholdLowChanged:(id)sender
{
    [self updateThresholdLow];
}

- (void)updateThresholdLow
{
    _thresholdLow = self.thresholdLowSlider.value;
    NSString *label = [NSString stringWithFormat:@"Threshold L: %d", _thresholdLow];
    [_thresholdLowLabel setText:label];
}

- (IBAction)thresholdHighChanged:(id)sender
{
    [self updateThresholdHigh];
}

- (void)updateThresholdHigh
{
    _thresholdHigh = self.thresholdHighSlider.value;
    NSString *label = [NSString stringWithFormat:@"Threshold H: %d", _thresholdHigh];
    [_thresholdHighLabel setText:label];
}

- (void)setup
{
    // Set mode for each pin
    [Konashi pinMode:S1 mode:INPUT];
    [Konashi pinMode:LED2 mode:OUTPUT];

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
    int state = _lastState;

    int voltage = [Konashi analogRead:AIO0];
    [self.analogInputIndicator setValue:voltage];
    NSString *label = [NSString stringWithFormat:@"AIO0: %d", voltage];
    [_analogInputLabel setText:label];
    
    if (voltage < _thresholdLow) {
        state = SENSOR_STATE_LOW;
    } else if (voltage > _thresholdHigh) {
        state = SENSOR_STATE_HIGH;
    }

    if (state != _lastState) {
        if (state == SENSOR_STATE_HIGH) {
            // Turn off the LED
            [Konashi digitalWrite:LED2 value:LOW];
            _outputStateIndicator.on = NO;
        } else {
            // Turn on the LED
            [Konashi digitalWrite:LED2 value:HIGH];
            _outputStateIndicator.on = YES;
        }
    }
    
    _lastState = state;
}

@end
