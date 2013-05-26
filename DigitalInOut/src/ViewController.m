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

- (IBAction)digitalOutputControlChanged:(id)sender {
    if (self.digitalOutputControl.selectedSegmentIndex == 1) {
        [Konashi digitalWrite:LED2 value:HIGH];
    } else {
        [Konashi digitalWrite:LED2 value:LOW];
    }
}

- (void)setup
{
    // Set mode for each pin
    [Konashi pinMode:S1 mode:INPUT];
    [Konashi pinMode:LED2 mode:OUTPUT];

    // Add an observer to observe changes on PIO input pins
    [Konashi addObserver:self selector:@selector(pioInputUpdated) name:KONASHI_EVENT_UPDATE_PIO_INPUT];
}

- (void)pioInputUpdated
{
    if ([Konashi digitalRead:S1] == HIGH) {
        [self.digitalInputControl setSelectedSegmentIndex:1];
    } else {
        [self.digitalInputControl setSelectedSegmentIndex:0];
    }
}

@end
