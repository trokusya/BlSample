//
//  FieldView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlidView.h"
#import "BattleshipView.h"

// フィールドのタイプ
typedef enum {
    FieldTypeOwn, // 自分の
    FieldTypeOth  // 相手の
}FiledType;

@interface FieldView : UIView <NSCoding>
{
    int _glidWidth;
    int _glidHeight;
    FiledType _type;
}

@property (nonatomic,retain) NSMutableArray *glids; // マス目の情報
@property (nonatomic,retain) NSMutableDictionary *ships; // 艦情報

@property (nonatomic,readonly) int rowNum; // 行数
@property (nonatomic,readonly) int colNum; // 列数
@property (nonatomic,readonly) int size;

- (id)initWithGridNum:(int)num size:(int)size type:(FiledType)type;
- (void)addBattleShip:(BattleshipView*)ship colIdx:(int)colIdx rowIdx:(int)rowIdx;
@end
