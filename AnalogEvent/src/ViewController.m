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

// Definitions to describe sensor states
// センサの状態を表すための定義
#define SENSOR_STATE_UNKNOWN -1
#define SENSOR_STATE_LOW    0
#define SENSOR_STATE_HIGH    1

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Set a localized text to the usage text view
    // 使用法のテキストを表示するビューにローカライズしたテキストをセット
    [self.usageTextView setText:NSLocalizedString(@"Usage", nil)];
    
    // Get initial values from sliders
    // スライダから初期値を取得する
    [self updateThresholdLow];
    [self updateThresholdHigh];
    
    // Initialize the variable to show a last sensor state with SENSOR_STATE_UNKNOWN
    // センサの前回の状態を示す変数をSENSOR_STATE_UNKNOWNで初期化する
    _lastState = SENSOR_STATE_UNKNOWN;
    
    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
    [Konashi find];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // それぞれのピンのモードをセット
    [Konashi pinMode:S1 mode:INPUT];
    [Konashi pinMode:LED2 mode:OUTPUT];

    // Add an observer to observe changes on AIO0
    // AIO0の変化をみるオブザーバを追加
    [Konashi addObserver:self selector:@selector(analogInputUpdated) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
    
    // Create and fire a timer to request reading AIO0
    // AIO0の値をリクエストするタイマを生成して起動
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
    // Request to read the voltage of AIO0
    // AIO0の電圧読み取りをリクエストする
    [Konashi analogReadRequest:AIO0];
}

- (void)analogInputUpdated
{
    int state = _lastState;

    // Read the voltage of AIO0 and update the label
    // AIO0の電圧を読み取りラベルを更新する
    int voltage = [Konashi analogRead:AIO0];
    [self.analogInputIndicator setValue:voltage];
    NSString *label = [NSString stringWithFormat:@"AIO0: %d", voltage];
    [_analogInputLabel setText:label];
    
    if (voltage < _thresholdLow) {
        // If the voltage is under the lower threshold, set the sensor state to SENSOR_STATE_LOW
        // 電圧が低い方の閾値よりも低ければセンサの状態をSENSOR_STATE_LOWにセット
        state = SENSOR_STATE_LOW;
    } else if (voltage > _thresholdHigh) {
        // If the voltage is over the higher threshold, set the sensor state to SENSOR_STATE_HIGH
        // 電圧が高い方の閾値よりも高ければセンサの状態をSENSOR_STATE_HIGHにセット
        state = SENSOR_STATE_HIGH;
    }

    if (_lastState != SENSOR_STATE_LOW && state == SENSOR_STATE_LOW) {
        // If the last state was not SENSOR_STATE_LOW and the state is SENSOR_STATE_LOW, turn on the LED
        // もし前回の状態がSENSOR_STATE_LOWでなく今回の状態がSENSOR_STATE_LOWであれば、LEDを点灯する
        [Konashi digitalWrite:LED2 value:HIGH];
        _outputStateIndicator.on = YES;
    } if (_lastState != SENSOR_STATE_HIGH && state == SENSOR_STATE_HIGH) {
        // If the last state was not SENSOR_STATE_HIGH and the state is SENSOR_STATE_HIGH, turn off the LED
        // もし前回の状態がSENSOR_STATE_HIGHでなく今回の状態がSENSOR_STATE_HIGHであれば、LEDを消灯する
        [Konashi digitalWrite:LED2 value:LOW];
        _outputStateIndicator.on = NO;
    }

    // Set the state as the last state for the next update
    // 次回更新時のために現在の状態を前回の状態としてセットする
    _lastState = state;
}

@end
