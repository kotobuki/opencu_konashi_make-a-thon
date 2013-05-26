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

#define KEY_FOR_THE_PREVIOUS_CONNECETD_DEVICE @"thePreviousConnectedDeviceName"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
    
    // Try to find a previous connected device in NSUserDefaults
    // NSUserDefaultsの中で前回接続したデバイス名を探す
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *thePreviousConnectedDeviceName = [defaults stringForKey:KEY_FOR_THE_PREVIOUS_CONNECETD_DEVICE];
    
    // If there is a record of a previous connected device in NSUserDefaults
    // もし前回接続したデバイス名がNSUserDefaultsにあれば
    if (thePreviousConnectedDeviceName) {
        NSLog(@"Found the previous connected device, so let's try connecting to the device");
        
        // Try to connect to the previous connected device
        // 取得したデバイス名で接続を試みる
        [Konashi findWithName:thePreviousConnectedDeviceName];
        
        // Add an observer in preparation for failure of connecting to the prebious connected device
        // 接続に失敗した時にfind処理を行うためのオブザーバをセットする
        [Konashi addObserver:self selector:@selector(failedToConnectToThePreviousConnectedDevice) name:KONASHI_EVENT_PERIPHERAL_NOT_FOUND];
    } else {
        // If there is a no recoard of a previous connected device, execute find to let the user choose a konashi module
        // 前回接続されたデバイス名がNSUserDefaultsの中になければfindを実行してユーザに接続を促す
        [Konashi find];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)failedToConnectToThePreviousConnectedDevice
{
    NSLog(@"Failed to connect to the previous connected device");
    
    // If failed to the previous connected device, execute find to let the user choose another konashi module
    // 前回接続されたデバイス名に接続できなければfindを実行してユーザに接続を促す
    [Konashi find];
}

- (void)setup
{
    NSString *name = [Konashi peripheralName];
    NSLog(@"Connected to %s", name.UTF8String);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:KEY_FOR_THE_PREVIOUS_CONNECETD_DEVICE];
    
    BOOL successful = [defaults synchronize];
    if (successful) {
        NSLog(@"Saved to NSUserDefaults successfully");
    } else {
        NSLog(@"Failed saving to NSUserDefaults");
    }

    // Set the drive mode of the pin connected to LED2
    // LED2に接続されたピンのドライブモードをセットする
    [Konashi pwmMode:LED2 mode:KONASHI_PWM_ENABLE_LED_MODE];
    
    // Start blinking the LED (interval: 0.5s)
    // LEDを点滅する（間隔：0.5秒）
    [Konashi pwmPeriod:LED2 period:1000000];    // 1.0s
    [Konashi pwmDuty:LED2 duty:500000];         // 0.5s
    [Konashi pwmMode:LED2 mode:ENABLE];
}

@end
