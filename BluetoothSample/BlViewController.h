//
//  BlViewController.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "FieldView.h"

@interface BlViewController : UIViewController<GKPeerPickerControllerDelegate,GKSessionDelegate,UIScrollViewDelegate>{
    
    IBOutlet UIButton *sendBtn;
    
    // スクロールビュー
    UIScrollView *_sv;
    
    // ページコントロールビュー
    UIPageControl *_pc;
    
    // 自分のフィールド
    FieldView *_myF;
    
    // 対戦相手のフィールド
    FieldView *_othF;
    
    // 戦艦配置用一時格納配列
    NSMutableDictionary *_tmpBattleShips;
}
- (IBAction)connect:(id)sender;

@property (nonatomic,retain) GKPeerPickerController *picker;
@property (nonatomic,retain) GKSession *gameSession;
@property (nonatomic,retain) UIView *bullet;
@end
