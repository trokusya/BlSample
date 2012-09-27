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
#import "define.h"

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
    
    id _sendTarget;
    SEL _sendSelector;
}

@property (nonatomic,retain) NSMutableArray *glids; // マス目の情報
@property (nonatomic,retain) NSMutableDictionary *ships; // 艦情報

@property (nonatomic,readonly) int rowNum; // 行数
@property (nonatomic,readonly) int colNum; // 列数
@property (nonatomic,readonly) int size;  // 1辺のマス数

@property (nonatomic) BOOL isPlay; // 対戦開始フラグ

- (id)initWithGridNum:(int)num size:(int)size type:(FiledType)type;
- (void)addBattleShip:(BattleshipView*)ship glidIdx:(int)glidIdx;
- (void)addBattleShip:(BattleshipView*)ship colIdx:(int)colIdx rowIdx:(int)rowIdx;
- (void)setTarget:(id)target selector:(SEL)selector;
- (void)selectGlidIdx:(int)glidIdx;
@end
