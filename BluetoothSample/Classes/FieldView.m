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
@synthesize hitGlids;
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
    
    self = [super initWithFrame:CGRectMake(0, 0, _glidWidth * num + 2, _glidHeight * num + 2)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        glids = [[NSMutableArray alloc]init];
        ships = [[NSMutableDictionary alloc]init];
        
        // 列,行数
        colNum = num, rowNum = colNum;
        
        // 当たりをランダムに設定
        hitGlids = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt: arc4random() % (colNum * rowNum)], nil];
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
        GlidView *glid = [[GlidView alloc]initWithFrame:CGRectMake(_glidWidth * xIdx + 1, _glidHeight * yIdx + 1, _glidWidth, _glidHeight)];
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
    
    // フィールド内で離された場合位置をマス目にあわせる
    GlidView *glid = [glids objectAtIndex:glidIdx];
    ship.center = glid.center;
    ship.index = glidIdx;
    ship.isSet = YES;
    
    // マスに配置
    [self addSubview:ship];
    
    // 当たりを設定
    [hitGlids addObject:[NSNumber numberWithInt: glidIdx]];
    
    // 船情報を格納しておく   
    [ships setObject:ship forKey:[NSString stringWithFormat:@"%d", glidIdx]];
}

@end
