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

@interface BlViewController : UIViewController<GKPeerPickerControllerDelegate,GKSessionDelegate>{
    
    IBOutlet UIButton *sendBtn;
    
    FieldView *_f;
}
- (IBAction)connect:(id)sender;

@property (nonatomic,retain) GKPeerPickerController *picker;
@property (nonatomic,retain) GKSession *gameSession;
@property (nonatomic,retain) UIView *bullet;
@end
