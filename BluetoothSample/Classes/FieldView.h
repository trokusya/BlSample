//
//  FieldView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlidView.h"

@interface FieldView : UIView
{
    int _glidWidth;
    int _glidHeight;
}

@property (nonatomic,retain) NSMutableArray *glids;
@property (nonatomic) NSInteger hitGlid;

@property (nonatomic,readonly) int rowNum; // 行数
@property (nonatomic,readonly) int colNum; // 列数
@property (nonatomic,readonly) int size;

- (id)initWithGridNum:(int)num size:(int)size;
@end
