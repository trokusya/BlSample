//
//  FieldGlidView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlidView.h"

@implementation GlidView

@synthesize glidStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        glidStatus = GlidStateBegin;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int boxW = 44, boxH = boxW;
    
    // 描画する範囲
    CGRect _rect = CGRectMake(0, 0, boxW, boxH);
    
    switch (glidStatus) {
        case GlidStateBegin:
            CGContextSetRGBFillColor(context, 0.53, 0.81, 0.92, 1);
            break;
        case GlidStateHit:
            CGContextSetRGBFillColor(context, 1, 0, 0, 1);
            break;
        case GlidStateSelect:
            CGContextSetGrayFillColor(context, 0.5, 1.0);
            break;
        default:
            break;
    }
    CGContextFillRect(context, _rect); // 塗りを描画
    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineWidth(context, 2);
    CGContextStrokeRect(context, _rect); // 線を描画
}

@end
