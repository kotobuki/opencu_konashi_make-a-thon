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
    
    // Initialize
    // 初期化
    [Konashi initialize];
    
    // Add an observer for KONASHI_EVENT_READY events
    // KONASHI_EVENT_READYに対するオブザーバを追加する
    [Konashi addObserver:self selector:@selector(setup) name:KONASHI_EVENT_READY];
    
    // Show the list of BLE devices and ask the user to choose a konashi module
    // BLEデバイスのリストを表示してユーザにkonashiモジュールを選択してもらう
    [Konashi find];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    // Do any setups after connecting to a konashi module
    // konashiモジュールに接続が完了した後のセットアップを行う
}

@end
