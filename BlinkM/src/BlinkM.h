//
//  BlinkM.h
//  I2cSample
//
//  Created by Shigeru Kobayashi on 2013/05/04.
//  Copyright (c) 2013年 Yukai Engineering. All rights reserved.
//
//  Reference
//  http://thingm.com/products/blinkm
//  http://thingm.com/fileadmin/thingm/downloads/BlinkM_datasheet.pdf

#import <Foundation/Foundation.h>

@interface BlinkM : NSObject
{
    unsigned char _data[4];
    unsigned char _address;
}

-(id)init:(unsigned char)address;

-(void)setFadeSpeed:(unsigned int)speed;
-(void)fadeToRGBColor:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue;
-(void)goToRGBColor:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue;
-(void)fadeToHSBColor:(unsigned char)hue saturation:(unsigned char)saturation value:(unsigned char)value;

@end