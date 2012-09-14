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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        glids = [[NSMutableArray alloc]init];
        
        // 当たりをランダムに設定
        hitGlid = arc4random() % 49;
    }
    return self;
}

// フィールドを描画
- (void)drawRect:(CGRect)rect
{
    int boxW = 44, boxH = boxW;
    int rows = 7, cols = rows;
    
    // マス目の数分作る
    for (int i = 0; i < rows*cols; i++) {
        
        int xIdx = i % cols;
        int yIdx = i / rows;
        
        // マス目
        GlidView *glid = [[GlidView alloc]initWithFrame:CGRectMake(boxW * xIdx, boxH * yIdx, boxW, boxH)];
        glid.alpha = 0;
        [self addSubview:glid];
        [glids addObject:glid]; // 配列に追加しとく
        
        [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
                              delay:0.0f+(i*0.015f) // 開始までの秒数
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             glid.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

@end
