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

	locationManager = [[CLLocationManager alloc] init];
	if ([CLLocationManager locationServicesEnabled]) {
		// 位置情報サービスが有効になっていれば位置情報の取得を開始
		locationManager.delegate = self;
		[locationManager startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // 緯度・経度を確認用にログに出力
    NSLog(@"didUpdateToLocation lat=%f, lng=%f", [newLocation coordinate].latitude, [newLocation coordinate].longitude);

    // 地図の中心座標に現在地を設定
    _mapView.centerCoordinate = newLocation.coordinate;
    
    // 表示領域を現在地の周囲500m四方に設定
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.centerCoordinate, 500.0, 500.0);
    [_mapView setRegion:region animated:YES];
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

    // Set mode for the S1 (PIO0) pin
    // S1（PIO0）ピンのモードをセット
    [Konashi pinMode:S1 mode:INPUT];
    
    // Add an observer to observe changes on PIO input pins
    // PIO入力ピンの変化を検知するためのオブザーバをセット
    [Konashi addObserver:self selector:@selector(pioInputUpdated) name:KONASHI_EVENT_UPDATE_PIO_INPUT];
}

- (void)pioInputUpdated
{
    // If the switch is pressed
    // もしスイッチが押されたら
    if ([Konashi digitalRead:S1] == HIGH) {
        NSLog(@"S1 pressed");

        // Add an annotation at the user location to the map
        // 地図の現在地にピンをドロップ
        MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = locationManager.location.coordinate;
        [_mapView addAnnotation:pin];
    }
}

@end
