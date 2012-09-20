//
//  FieldView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FieldView.h"

@implementation FieldView

@synthesize glids;
@synthesize ships;
@synthesize colNum;
@synthesize rowNum;
@synthesize size = _size;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithGridNum:(int)num size:(int)size
{
    _glidWidth = size, _glidHeight = _glidWidth;
    _size = size;
    
    self = [super initWithFrame:CGRectMake(0, 0, _glidWidth * num + FIELD_LINE_WIDTH, _glidHeight * num + FIELD_LINE_WIDTH)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        glids = [[NSMutableArray alloc]init];
        ships = [[NSMutableDictionary alloc]init];
        
        // 列,行数
        colNum = num, rowNum = colNum;
    }
    return self;
}

// フィールドを描画
- (void)drawRect:(CGRect)rect
{
    // マス目の数分作る
    float delay = 0.5f / (rowNum * colNum);
    for (int i = 0; i < rowNum * colNum; i++) {
        
        int xIdx = i % colNum;
        int yIdx = i / rowNum;
        
        // マス目
        GlidView *glid = [[GlidView alloc]initWithFrame:CGRectMake(_glidWidth * xIdx + FIELD_LINE_WIDTH/2, _glidHeight * yIdx + FIELD_LINE_WIDTH/2, _glidWidth, _glidHeight)];
        glid.alpha = 0;
        [self addSubview:glid];
        [glids addObject:glid]; // 管理用配列に追加しとく
        
        [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
                              delay:0.0f+(i*delay) // 開始までの秒数
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             glid.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                         }];
        [glid release];
    }
}

// 戦艦をフィールドに配置する
- (void)addBattleShip:(BattleshipView*)ship colIdx:(int)colIdx rowIdx:(int)rowIdx
{
    int glidIdx = colIdx + rowIdx * rowNum;
    DebugLog(@"glidIdx [%d]", glidIdx);
    
    // フィールド内で離された場合位置をマス目にあわせる
    GlidView *glid = [glids objectAtIndex:glidIdx];
//    ship.center = glid.center;
    
    CGRect shipRect = ship.frame;
    shipRect.origin.x = glid.frame.origin.x + (glid.frame.size.width/2 - ship.frame.size.width/2);
    shipRect.origin.y = glid.frame.origin.y + (glid.frame.size.height*ship.glidNum - ship.frame.size.height)/2;
    ship.frame = shipRect;
//    DebugLog(@"glidframex [%f],glidframey [%f]", glid.frame.origin.x,glid.frame.origin.x);

    ship.index = glidIdx;
    ship.isSet = YES;
    
    // マスに配置
    [self addSubview:ship];
    
    // 船情報を格納しておく
    [ships setObject:ship forKey:[NSString stringWithFormat:@"%d", glidIdx]];
}

@end
