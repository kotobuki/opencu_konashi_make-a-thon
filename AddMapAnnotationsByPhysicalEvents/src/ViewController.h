//
//  ViewController.h
//  BareMinimum
//
//  Created by Shigeru Kobayashi on 2013/05/12.
//  Copyright (c) 2013年 Shigeru Kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
