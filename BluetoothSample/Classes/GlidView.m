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
    
    int boxW = rect.size.width, boxH = boxW;
    
    // 描画する範囲
    CGRect _rect = CGRectMake(0, 0, boxW, boxH);
    CGRect _markRect = CGRectInset(_rect, boxW / 2.5, boxH / 2.5);
    
    switch (glidStatus) {
        case GlidStateBegin:
            CGContextSetRGBFillColor(context, 0.53, 0.81, 0.92, 1); // 色
            CGContextFillRect(context, _rect); // 塗りを描画
            break;
        case GlidStateHit:
            CGContextSetRGBFillColor(context, 1, 0, 0, 1); // 色
            CGContextFillRect(context, _rect); // 塗りを描画
            break;
        case GlidStateSelect:
            
            // 塗りつぶしの色
            CGContextSetGrayFillColor(context, 0.45, 1.0); // 色
            CGContextFillRect(context, _rect); // 塗りを描画
            
            // マーク
            CGContextSetLineWidth(context, 2);
            CGContextMoveToPoint(context, _markRect.origin.x, _markRect.origin.y);  // 始点
            CGContextAddLineToPoint(context, _markRect.origin.x+_markRect.size.width, _markRect.origin.y+_markRect.size.height);  // 終点
            CGContextStrokePath(context);  // 線描画
            
            CGContextMoveToPoint(context, _markRect.origin.x+_markRect.size.width, _markRect.origin.y);  // 始点
            CGContextAddLineToPoint(context, _markRect.origin.x, _markRect.size.height+_markRect.origin.y);  // 終点
            CGContextStrokePath(context);  // 線描画
            
            break;
        default:
            break;
    }
    
    // 枠線
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineWidth(context, FIELD_LINE_WIDTH);
    CGContextStrokeRect(context, _rect); // 線を描画
}

@end
