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
@synthesize hitGlid;
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
    
    self = [super initWithFrame:CGRectMake(0, 0, _glidWidth * num, _glidHeight * num)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        glids = [[NSMutableArray alloc]init];
        
        // 列,行数
        colNum = num, rowNum = colNum;
        
        // 当たりをランダムに設定
        hitGlid = arc4random() % (colNum * rowNum);
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
        GlidView *glid = [[GlidView alloc]initWithFrame:CGRectMake(_glidWidth * xIdx, _glidHeight * yIdx, _glidWidth, _glidHeight)];
        glid.alpha = 0;
        [self addSubview:glid];
        [glids addObject:glid]; // 配列に追加しとく
        
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

@end
