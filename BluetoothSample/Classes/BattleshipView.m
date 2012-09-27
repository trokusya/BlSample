//
//  BattleshipView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleshipView.h"

@implementation BattleshipView

@synthesize type;
@synthesize viewMode;
@synthesize glidNum;
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
        
        glidNum = 2;
    }
    return self;
}

- (id)initWithType:(ShipType)shipType
{
    // タイプを設定
    type = shipType;    
    switch (shipType) {
        case ShipTypeSubmarine:
            glidNum = 1;
            // 横幅はグリッドの2/3, 縦幅はグリッドの4/5
            self = [super initWithFrame:CGRectMake(0, 0, GLID_SIZE/3*2, GLID_SIZE*glidNum/5*4)];
            break;
        case ShipTypeDestroyer:
            glidNum = 2;
            self = [super initWithFrame:CGRectMake(0, 0, GLID_SIZE/3*2, GLID_SIZE*glidNum/5*4)];
            break;
        case ShipTypeBattleShip:
            glidNum = 3;
            self = [super initWithFrame:CGRectMake(0, 0, GLID_SIZE/3*2, GLID_SIZE*glidNum/5*4)];
            break;
        default:
            break;
    }
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        // マス目に未配置
        isSet = NO;
        
        // 表示モード
        viewMode = ShipViewModeTop;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 三角形
    //    CGContextSetFillColor(context, CGColorGetComponents([UIColor blueColor].CGColor)); // 青
    CGContextSetGrayFillColor(context, 0, 1.0); // 黒
    
    CGContextMoveToPoint(context, self.frame.size.width/2, 0);
    CGContextAddLineToPoint(context, 0, 7);
    CGContextAddLineToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, 7);
    CGContextAddLineToPoint(context, self.frame.size.width/2, 0);
        
    CGContextFillPath(context); // 塗り描画
}

//#pragma mark touch event
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    DebugLog(@"start");
////    [UIView animateWithDuration:0.3f 
////                          delay:0
////                        options:UIViewAnimationCurveLinear 
////                     animations:^{
////                         self.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
////                     } 
////                     completion:^(BOOL finished){
////                     }
////     ];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [touches anyObject];
//	CGPoint pt = [touch locationInView:self];
//    DebugLog(@"start %@", NSStringFromCGPoint(pt));
//
////    
////    // ドラッグ中の座標を使って移動
////    self.transform = CGAffineTransformMakeTranslation(pt.x - self.center.x, pt.y - self.center.y);
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    DebugLog(@"start");
//}
//

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 回転させる
    self.transform = CGAffineTransformRotate(self.transform, M_PI/2);
    
    // 表示モードの変更
    switch (viewMode) {
        case ShipViewModeTop:
            viewMode = ShipViewModeRight;
            break;
        case ShipViewModeRight:
            viewMode = ShipViewModeBottom;
            break;
        case ShipViewModeBottom:
            viewMode = ShipViewModeLeft;
            break;
        case ShipViewModeLeft:
            viewMode = ShipViewModeTop;
            break;
        default:
            viewMode = ShipViewModeTop;
            break;
    }
}
@end
