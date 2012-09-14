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

@interface BlViewController ()

@end

@implementation BlViewController

// プロパティ = メンバ変数
@synthesize picker = _picker;
@synthesize gameSession = _gameSession;
@synthesize bullet = _bullet;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // picker表示
//    [self startPicker];
    
    // フィールド
    _f = [[FieldView alloc]initWithFrame:CGRectMake(0, 0, 44*7+2, 44*7+2)];
    _f.center = self.view.center;
    [self.view addSubview:_f];
    
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    
    float boxW = 44, boxH = boxW;
    
    // 列インデックス
    int col = point.x / boxW;
    
    // 行インデックス
    int row = point.y / boxH;
    
    // フィールド外は無視
    if (col < 0 || row < 0) {
        return;
    }
    
    NSLog(@"col[%d] row[%d]",col,row);
    
    // グリッドの再描画
    int glidIdx = col+row*7;
    GlidView *glid = [_f.glids objectAtIndex:glidIdx];
    
    if (_f.hitGlid == glidIdx) {
        // 当たり
        glid.glidStatus = GlidStateHit;
    }else{
        // ハズレ
        glid.glidStatus = GlidStateSelect;
    }
    [_f bringSubviewToFront:glid]; // 指定のグリッドを一番上の階層に移動
    
    [UIView animateWithDuration:0.2f // 完了するまでにかかる秒数
                          delay:0.0f // 開始までの秒数
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         glid.alpha = 0.5f;
                         glid.transform = CGAffineTransformMakeScale(2.0, 2.0);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
                                               delay:0.0f // 開始までの秒数
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              glid.alpha = 1.0f;
                                              glid.transform = CGAffineTransformMakeScale(1, 1);
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"Completed Bom End Animation!");
                                          }];
                     }];
    [glid setNeedsDisplay];
    
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

#pragma mark -
#pragma mark Session Related Methods

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

#pragma mark Data Send/Receive Methods

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
@end
