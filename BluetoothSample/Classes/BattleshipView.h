//
//  BattleshipView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "define.h"

// 船のタイプ
typedef enum{
    ShipTypeBattleShip,
    ShipTypeDestroyer
}ShipType;

@interface BattleshipView : UIView

// 配置に必要なマス数
@property (nonatomic, readonly) int glidNum;
// 配置マスindex番号
@property (nonatomic) int index;
// マス目に配置済みか
@property (nonatomic) BOOL isSet;

// タイプを指定して初期化する
- (id)initWithType:(ShipType)type;
@end
