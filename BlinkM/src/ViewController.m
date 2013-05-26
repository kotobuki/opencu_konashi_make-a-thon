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

- (IBAction)fadeToRandomColorButtonPressed:(id)sender {
    // Fade to a random RGB color for each button press
    // ボタンがおされる度にランダムなRGBカラーにフェードする
    [blinkM fadeToRGBColor:(rand() % 255) green:(rand() % 255) blue:(rand() % 255)];
}

- (void)setup
{
    // Initialize the I2C bus and prepare for controlling a BkinkM device
    // I2Cバスを初期化してBlinkMデバイスをコントロールする準備をする
    [Konashi i2cMode:KONASHI_I2C_ENABLE_100K];
    blinkM = [[BlinkM alloc] init];

    // Set fade spped
    // フェード速度をセット
    [blinkM setFadeSpeed:10];
}

@end
