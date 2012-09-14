//
//  BomView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BomView.h"

@implementation BomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float strokeWidth = 2;
    float dx = strokeWidth - (strokeWidth / 2), dy = dx;
    
    // 描画する円の範囲(線幅の1/2外に飛び出すので範囲は狭くする)
    CGRect rectEllipse = CGRectInset(rect, dx, dy);
    
    //円の線を描画  
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1);  
    CGContextSetLineWidth(context, strokeWidth);  
    CGContextStrokeEllipseInRect(context, rectEllipse);  
}

@end
