//
//  BattleshipView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleshipView.h"

@implementation BattleshipView

@synthesize index;
@synthesize isSet;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        // マス目に未配置
        isSet = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"start");
//    [UIView animateWithDuration:0.3f 
//                          delay:0
//                        options:UIViewAnimationCurveLinear 
//                     animations:^{
//                         self.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
//                     } 
//                     completion:^(BOOL finished){
//                     }
//     ];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    DebugLog(@"start %@", NSStringFromCGPoint(pt));

//    
//    // ドラッグ中の座標を使って移動
//    self.transform = CGAffineTransformMakeTranslation(pt.x - self.center.x, pt.y - self.center.y);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"start");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"start");
}
@end
