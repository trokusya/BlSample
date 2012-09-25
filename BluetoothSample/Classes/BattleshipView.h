//
//  BattleshipView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "define.h"

// 戦艦のタイプ
typedef enum{
    ShipTypeSubmarine,
    ShipTypeDestroyer,
    ShipTypeBattleShip,
}ShipType;

// 表示モード
typedef enum{
    ShipViewModeTop,
    ShipViewModeRight,
    ShipViewModeBottom,
    ShipViewModeLeft,
}ShipViewMode;

@interface BattleshipView : UIView

// 戦艦タイプ
@property (nonatomic) ShipType type;
// 表示モード
@property (nonatomic) ShipViewMode viewMode;
// 配置に必要なマス数
@property (nonatomic, readonly) int glidNum;
// 配置マスindex番号
@property (nonatomic) int index;
// マス目に配置済みか
@property (nonatomic) BOOL isSet;

// タイプを指定して初期化する
- (id)initWithType:(ShipType)type;
@end
