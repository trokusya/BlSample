//
//  BlViewController.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlViewController.h"
#import "BomView.h"
#import "FieldView.h"
#import "BattleshipView.h"

#import "define.h"

@interface BlViewController ()

@end

#define TmpBattleShipTagName 1

@implementation BlViewController

// プロパティ = メンバ変数
@synthesize picker = _picker;
@synthesize gameSession = _gameSession;
@synthesize bullet = _bullet;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    {// init
//        _tmpBattleShips = [[NSMutableDictionary alloc]initWithCapacity:1];
    }
    // picker表示
//    [self startPicker];
    
    // フィールド
    _f = [[FieldView alloc]initWithGridNum:FIELD_LINE_NUM size:GLID_SIZE];
    _f.center = self.view.center;
    [self.view addSubview:_f];
    
    // 戦艦
    BattleshipView *battleShip = [[BattleshipView alloc]initWithType:ShipTypeBattleShip];
    // dragジェスチャーの登録
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [battleShip addGestureRecognizer:pan];
    [self.view addSubview:battleShip];
    [battleShip release];
    
    // 駆逐艦
    BattleshipView *destroyer = [[BattleshipView alloc]initWithType:ShipTypeDestroyer];
    // dragジェスチャーの登録
    pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [destroyer addGestureRecognizer:pan];
    [self.view addSubview:destroyer];
    [destroyer release];
    
    [pan release];

}

- (void)viewDidUnload
{
    [sendBtn release];
    sendBtn = nil;
    [_f release];_f=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [sendBtn release];
    [_f release];
    [super dealloc];
}

#pragma mark -
#pragma mark Peer Picker Related Methods

-(void)startPicker {
    
    _picker = [[GKPeerPickerController alloc] init];
    _picker.delegate = self;
    // 許可するネットワークタイプを設定
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    // pickerの表示
    [_picker show];
}

#pragma mark -
#pragma mark Event Handling Methods

#pragma mark touch gesture

// 戦艦の配置ドラッグイベント
- (void)pan:(UIPanGestureRecognizer *)sender
{
    UIGestureRecognizerState state = sender.state;
//    DebugLog(@"state [%d]", state);
    
    // フィールドから見た相対位置
    CGPoint ptF = [sender locationInView:_f];
    DebugLog(@"Filld %@",NSStringFromCGPoint(ptF));
    
    // 自身から見た相対位置
    CGPoint pt = [sender locationInView:sender.view];
    float shipHeightHalf = sender.view.frame.size.height / 2;
    if (pt.y < shipHeightHalf){
        DebugLog(@"掴んでいる位置が半分より上, [%f] < [%f]",pt.y,shipHeightHalf);
    }else{
        DebugLog(@"掴んでいる位置が半分より下, [%f] < [%f]",pt.y,shipHeightHalf);
    }    
    
    
    // 列インデックス
    int colIdx = ptF.x / _f.size;
    // 行インデックス
    int rowIdx = ptF.y / _f.size;
    
    DebugLog(@"_f.size[%d] col[%d] row[%d]", _f.size, colIdx, rowIdx);
    
    
    
    // 移動する戦艦View
    BattleshipView *ship = (BattleshipView*)sender.view;
    
    // 移動開始
    if (state == UIGestureRecognizerStateBegan) {
        ship.alpha = 0.5;
        
        // 移動しているのが未配置の戦艦なら次の移動用Viewを追加しておく
        if (ship.isSet == NO) {
            BattleshipView *copy = [[BattleshipView alloc]initWithType:ship.type];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
            [copy addGestureRecognizer:pan];
            [pan release];
            
            [self.view insertSubview:copy belowSubview:ship];
            [copy release];
        }
    }
    
    // 移動中
    if (state == UIGestureRecognizerStateChanged) {
        
        // 移動量の相対位置
        CGPoint pt = [sender translationInView:ship];
        
//        DebugLog(@"%@", NSStringFromCGPoint(pt));
        
        // 移動
        ship.center = CGPointMake(ship.center.x + pt.x, ship.center.y + pt.y);
        // 積算された移動量をクリアする
        [sender setTranslation:CGPointZero inView:ship];
    }
    
    // 移動終了
    if (state == UIGestureRecognizerStateEnded) {
        
        // フィールド外かどうか判定
        if (ptF.x < 0 || ptF.y < 0 || _f.colNum <= colIdx || _f.rowNum <= rowIdx) {
            
            // フィールド外にほおられたら消す
            [ship removeFromSuperview];
        }else{
            
            // フィールドに戦艦追加        
            [_f addBattleShip:ship colIdx:colIdx rowIdx:rowIdx];
        }
    }
}

// コントローラタッチイベント
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"start");
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:_f];
    [self selectGlid:pt];
}


// マス目が選択されたら
- (void)selectGlid:(CGPoint)point
{
//    // 弾表示位置
//    NSData *data = [NSData dataWithBytes:&point length:sizeof(point)];
//    
//    // データ送信
//    [self mySendDataToPeers:data];
    
    
    // 列インデックス
    int colIdx = point.x / _f.size;
    
    // 行インデックス
    int rowIdx = point.y / _f.size;
    
//    NSLog(@"[%d] [%d]",colIdx,rowIdx);
    
    // フィールド外は無視
    if (point.x < 0 || point.y < 0 || _f.colNum <= colIdx || _f.rowNum <= rowIdx) {
        return;
    }
    
    // グリッドの再描画
    int glidIdx = colIdx + rowIdx * _f.rowNum;
    GlidView *glid = [_f.glids objectAtIndex:glidIdx];
    
    // 当たり？
    BOOL hit = [_f.ships.allKeys containsObject:[NSString stringWithFormat:@"%d", glidIdx]];
    glid.glidStatus = (hit)? GlidStateHit : GlidStateSelect;
    
    [_f bringSubviewToFront:glid]; // 指定のグリッドを一番上の階層に移動
   
    glid.alpha = 0;
    [UIView animateWithDuration:2.0f // 完了するまでにかかる秒数
                          delay:0.0f // 開始までの秒数
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         glid.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    [glid setNeedsDisplay];
    
    
//    [UIView animateWithDuration:0.2f // 完了するまでにかかる秒数
//                          delay:0.0f // 開始までの秒数
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         glid.alpha = 0.5f;
//                         glid.transform = CGAffineTransformMakeScale(2.0, 2.0);
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
//                                               delay:0.0f // 開始までの秒数
//                                             options:UIViewAnimationOptionCurveEaseIn
//                                          animations:^{
//                                              glid.alpha = 1.0f;
//                                              glid.transform = CGAffineTransformMakeScale(1, 1);
//                                          }
//                                          completion:^(BOOL finished){
//                                              NSLog(@"Completed Bom End Animation!");
//                                          }];
//                     }];
//    [glid setNeedsDisplay];
    
//    UIView *bom = [[BomView alloc]initWithFrame:CGRectMake(_f.frame.origin.x+boxW*col, _f.frame.origin.y+boxH*row, 44, 44)];
//    NSLog(@"col[%d] row[%d]",col,row);
//    [self.view addSubview:bom];
//    [bom release];
//    
//    [UIView animateWithDuration:0.4f // 完了するまでにかかる秒数
//                          delay:0.0f // 開始までの秒数
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         bom.alpha = 0.1f;
//                         bom.transform = CGAffineTransformMakeScale(2.0, 2.0);
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
//                                               delay:0.0f // 開始までの秒数
//                                             options:UIViewAnimationOptionCurveEaseIn
//                                          animations:^{
//                                              bom.alpha = 1.0f;
//                                              bom.transform = CGAffineTransformMakeScale(1, 1);
//                                          }
//                                          completion:^(BOOL finished){
//                                              NSLog(@"Completed Bom End Animation!");
//                                          }];
//
//                         NSLog(@"Completed Bom Start Animation!");
//                     }];
    
}

- (void)bullet:(CGPoint)point
{
    if (_bullet != nil) {
        return;
    }
    
    // 弾表示位置
    float rand_x = rand() % 320;
    float height = 6;
    float width = 3;
    CGRect rect = CGRectMake(rand_x, 460-height, width, height);
    NSData *data = [NSData dataWithBytes:&rect length:sizeof(rect)];
    
    [UIView animateWithDuration:2.0f // 完了するまでにかかる秒数
                          delay:0.0f // 開始までの秒数
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         
                         _bullet = [[UIView alloc]initWithFrame:rect];
                         _bullet.backgroundColor = [UIColor blackColor];
                         [self.view addSubview:_bullet];
                         
                         CGRect r = _bullet.frame;
                         r.origin.y = 0 - r.size.height;
                         _bullet.frame = r;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Completed! rand_x[%f]",rand_x);
                         [_bullet removeFromSuperview];
                         [_bullet release];
                         _bullet = nil;
                         
                         // データ送信
                         [self mySendDataToPeers:data];
                     }];
    //    NSString *message = @"メッセージ送るよ";
    //    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
}

// Connectボタン
- (IBAction)connect:(id)sender
{
    [self startPicker];
}

#pragma mark -
#pragma mark Bluetooth
// 設定済みセッションの所有権を受け取る
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.gameSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    // pickerの削除
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
    // ゲーム開始する
}
// ユーザがピッカーをキャンセル
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
    
    // invalidate and release game session if one is around.
	if(self.gameSession != nil)	{
		[self invalidateSession:self.gameSession];
		self.gameSession = nil;
	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateConnected:
            // ほかのピアのpeerIDwを記録する
            // ピアが接続したことをゲームに通知する
            break;
        case GKPeerStateDisconnected:
            // ピアがいなくなったことをゲームに通知する
            [self.gameSession release];
            self.gameSession = nil;
            break;
        default:
            break;
    }
}

#pragma mark session Related Methods

//
// invalidate session
//
- (void)invalidateSession:(GKSession *)session {
	if(session != nil) {
		[session disconnectFromAllPeers]; 
		session.available = NO; 
		[session setDataReceiveHandler: nil withContext: NULL]; 
		session.delegate = nil; 
	}
}

#pragma mark data Send/Receive Methods

// ほかのピアにデータを送信する
- (void) mySendDataToPeers:(NSData *)data
{
    BOOL ok = [self.gameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    
    NSLog(@"Data send [%d]", ok);
    
}

// ほかのピアからデータを受け取る
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    NSLog(@"Data receive [%@]", data);
    
    {// CGPointを受け取る
        CGPoint center = *(CGPoint*)[data bytes];
        UIView *bom = [[BomView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        bom.center = center;
        [self.view addSubview:bom];
        [bom release];
        
//        [UIView animateWithDuration:0.4f // 完了するまでにかかる秒数
//                              delay:0.0f // 開始までの秒数
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             bom.alpha = 0.0f;
//                             bom.transform = CGAffineTransformMakeScale(10, 10);
//                         }
//                         completion:^(BOOL finished){
//                             NSLog(@"Completed Bom Animation!");
//                         }];
    }
    
    /*
    {// NSStringメッセージを受け取る
        // データのバイトを読み取り、アプリケーション固有のアクションを実行する
        NSString *message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];	
        [message release];
    }
     */
    
    /*
    {// CGRectを受け取る
        CGRect rect = *(CGRect*)[data bytes];
        [UIView animateWithDuration:2.0f // 完了するまでにかかる秒数
                              delay:0.0f // 開始までの秒数
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             
                             _bullet = [[UIView alloc]initWithFrame:rect];
                             _bullet.backgroundColor = [UIColor blackColor];
                             [self.view addSubview:_bullet];
                             
                             CGRect r = _bullet.frame;
                             r.origin.y = 0 - r.size.height;
                             _bullet.frame = r;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Completed!");
                             [_bullet removeFromSuperview];
                             [_bullet release];
                             _bullet = nil;
                         }];
    }
     */

}
#pragma mark -
@end

