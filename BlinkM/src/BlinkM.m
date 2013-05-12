//
//  BlinkM.m
//  I2cSample
//
//  Created by Shigeru Kobayashi on 2013/05/04.
//  Copyright (c) 2013年 Yukai Engineering. All rights reserved.
//

#import "Konashi.h"
#import "BlinkM.h"

@implementation BlinkM

-(id)init
{
    return [self init:0x09];  // 0x09 is the default address of BlinkM devices
}

-(id)init:(unsigned char)address
{
    self = [super init];
    if (self != nil) {
        _address = address;
        [self _stopScript];
        [self fadeToRGBColor:0 green:0 blue:0];
    }
    
    return self;
}

-(void)_stopScript
{
    _data[0] = 'o';
    
    [self _writeCommand:_address command:_data length:1];
}

-(void)setFadeSpeed:(unsigned int)speed
{
    _data[0] = 'f';
    _data[1] = speed;
    
    [self _writeCommand:_address command:_data length:2];
}

-(void)fadeToRGBColor:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue
{
    _data[0] = 'c';
    _data[1] = red;
    _data[2] = green;
    _data[3] = blue;
    
    [self _writeCommand:_address command:_data length:4];
}

-(void)goToRGBColor:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue
{
    _data[0] = 'n';
    _data[1] = red;
    _data[2] = green;
    _data[3] = blue;
    
    [self _writeCommand:_address command:_data length:4];
}

-(void)fadeToHSBColor:(unsigned char)hue saturation:(unsigned char)saturation value:(unsigned char)value
{
    _data[0] = 'h';
    _data[1] = hue;
    _data[2] = saturation;
    _data[3] = value;
    
    [self _writeCommand:_address command:_data length:4];
}

-(void)_writeCommand:(unsigned char)address command:(unsigned char *)command length:(unsigned char)length
{
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cWrite:length data:command address:address];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    [NSThread sleepForTimeInterval:0.01];
}

@end