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

@implementation BlViewController

// プロパティ = メンバ変数
@synthesize bullet = _bullet;
@synthesize gameSession;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    {// init
        
        // viewのサイズを調整する
        CGSize appFrameSize = [[UIScreen mainScreen]applicationFrame].size;
        self.view.frame = CGRectMake(0, 0, appFrameSize.width, appFrameSize.height);
        
        self.gameSession = nil;
    }
    // picker表示
    [self startPicker];
    
    {// スクロールViewの配置
        CGRect svFrame = self.view.frame;
        _sv = [[UIScrollView alloc] initWithFrame:svFrame];
//        _sv.backgroundColor = [UIColor redColor];
        _sv.contentSize = CGSizeMake(svFrame.size.width * 2, svFrame.size.height); // 格納されるコンテンツサイズ
        _sv.pagingEnabled = YES;// ページ単位でのスクロール
        _sv.delegate = self;
        [self.view addSubview:_sv];
        [_sv release];
    }
    
    // 自分のフィールド
    _myF = [[FieldView alloc]initWithGridNum:FIELD_LINE_NUM size:GLID_SIZE type:FieldTypeOwn];
    _myF.center = self.view.center;
    [_sv addSubview:_myF];
    
    // 対戦相手のフィールド
    _othF = [[FieldView alloc]initWithGridNum:FIELD_LINE_NUM size:GLID_SIZE type:FieldTypeOth];
    CGRect otherFrame = _myF.frame;
    otherFrame.origin.x += _sv.frame.size.width;
    _othF.frame = otherFrame;
    [_sv addSubview:_othF];
    
    {// ページコントロールViewの配置
        CGRect pcFrame = CGRectMake(0, _myF.frame.origin.y+_myF.frame.size.height+10, self.view.frame.size.width, 30);
        _pc = [[UIPageControl alloc]initWithFrame:pcFrame];
//        _pc.backgroundColor = [UIColor cyanColor];
        _pc.numberOfPages = 2; // ページ数
        [self.view addSubview:_pc];
    }
    
    // スタートボタン
    UIButton *startBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake(_myF.frame.origin.x, _myF.frame.origin.y - 30, 64, 30);
    [startBtn setTitle:@"スタート" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchDown];
    [_sv addSubview:startBtn];
    
    // 潜水艦
    BattleshipView *submarine = [[BattleshipView alloc]initWithType:ShipTypeSubmarine];
    // dragジェスチャーの登録
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [submarine addGestureRecognizer:pan];
    [self.view addSubview:submarine];
    [submarine release];
    
    // 駆逐艦
    BattleshipView *destroyer = [[BattleshipView alloc]initWithType:ShipTypeDestroyer];
    // dragジェスチャーの登録
    pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [destroyer addGestureRecognizer:pan];
    [self.view addSubview:destroyer];
    [destroyer release];
    
    // 戦艦
    BattleshipView *battleShip = [[BattleshipView alloc]initWithType:ShipTypeBattleShip];
    // dragジェスチャーの登録
    pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [battleShip addGestureRecognizer:pan];
    [self.view addSubview:battleShip];
    [battleShip release];
    
    [pan release];
}

- (void)viewDidUnload
{
    [sendBtn release];
    sendBtn = nil;
    [_myF release];_myF=nil;
    [_othF release];_othF=nil;
    [self.gameSession release];self.gameSession=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [sendBtn release];
    [_myF release];
    [_othF release];
    
    
	[self invalidateSession:self.gameSession];
    [self.gameSession release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

// スクロールされたら呼ばれる
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;  
//    DebugLog(@"start x[%f] page[%f]",scrollView.contentOffset.x,floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    _pc.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;  
}

#pragma mark -
#pragma mark Peer Picker Related Methods

-(void)startPicker {
    
    GKPeerPickerController *picker;
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    // 許可するネットワークタイプを設定
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    // pickerの表示
    [picker show];
}

#pragma mark -
#pragma mark Event Handling Methods

// 戦艦の配置ドラッグイベント
- (void)pan:(UIPanGestureRecognizer *)sender
{
    UIGestureRecognizerState state = sender.state;
//    DebugLog(@"state [%d]", state);
    
    // フィールドから見た相対位置
    CGPoint ptF = [sender locationInView:_myF];
//    DebugLog(@"Filld %@",NSStringFromCGPoint(ptF));
    
//    // 自身から見た相対位置
//    CGPoint pt = [sender locationInView:sender.view];
//    float shipHeightHalf = sender.view.frame.size.height / 2;
//    if (pt.y < shipHeightHalf){
//        DebugLog(@"掴んでいる位置が半分より上, [%f] < [%f]",pt.y,shipHeightHalf);
//    }else{
//        DebugLog(@"掴んでいる位置が半分より下, [%f] < [%f]",pt.y,shipHeightHalf);
//    }    
    
    
    // 列インデックス
    int colIdx = ptF.x / _myF.size;
    // 行インデックス
    int rowIdx = ptF.y / _myF.size;
    
    DebugLog(@"_f.size[%d] col[%d] row[%d]", _myF.size, colIdx, rowIdx);
    
    // 移動する戦艦View
    BattleshipView *ship = (BattleshipView*)sender.view;
    
    // 移動開始
    if (state == UIGestureRecognizerStateBegan) {
        ship.alpha = 0.5;
        
        if (ship.isSet) {
            // 配置済みの戦艦を動かしているので古い当たり情報を削除する
            for (int i=0; i<ship.glidNum; i++) {
                switch (ship.viewMode) {
                    case ShipViewModeTop:
                    case ShipViewModeBottom:
                        // 縦に長さ分削除
                        [_myF.ships removeObjectForKey:[NSString stringWithFormat:@"%d", ship.index+_myF.rowNum*i]];
                        break;
                    case ShipViewModeRight:
                    case ShipViewModeLeft:
                        // 横に長さ分削除
                        [_myF.ships removeObjectForKey:[NSString stringWithFormat:@"%d", ship.index+i]];
                        break;
                    default:
                        break;
                }
            }
        }else{
            // 移動しているのが未配置の戦艦なら次の移動用Viewを追加しておく
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
        CGPoint pt = [sender translationInView:self.view];
        
//        DebugLog(@"%@", NSStringFromCGPoint(pt));
        
        // 移動
        ship.center = CGPointMake(ship.center.x + pt.x, ship.center.y + pt.y);
        // 積算された移動量をクリアする
        [sender setTranslation:CGPointZero inView:ship];
    }
    
    // 移動終了
    if (state == UIGestureRecognizerStateEnded) {
        
        ship.alpha = 1.0;
        
        // 追加するグリッドインデックス
        int addGlidIdx = 0;
        // 重なり合ってるグリッドの数
        NSMutableArray *hitCnt = [[NSMutableArray alloc]init];
        // 重なっているGlidを検査
        for (int i=0; i<[_myF.glids count]; i++) {
            
            CGRect rect1 = ((GlidView *)[_myF.glids objectAtIndex:i]).frame;
            
            if (!ship.isSet) {
                // グリッドの位置をself.viewから見た位置とあわせるためフィールドのxとyを足す
                rect1.origin.x += _myF.frame.origin.x;
                rect1.origin.y += _myF.frame.origin.y;
            }
            
            // 船の位置
            CGRect rect2 = ship.frame;
            
            // 重なっている部分があったらhitCntを増やす
            if (CGRectIntersectsRect(rect1, rect2)) {
                
                [hitCnt addObject:[NSNumber numberWithInt:i]];
            }
        }
        
        
        // 必要なマス数がヒット数以上なら
        if (ship.glidNum <= [hitCnt count]) {
            
            DebugLog(@"フィールドに追加");
            
            switch (ship.viewMode) {
                case ShipViewModeTop:
                case ShipViewModeBottom:
                case ShipViewModeRight:
                case ShipViewModeLeft:
                    // 番上のインデックス番号に追加
                    addGlidIdx = [[hitCnt objectAtIndex:0] intValue];
                    break;
                default:
                    break;
            }
            
            // フィールドに戦艦追加
            [_myF addBattleShip:ship glidIdx:addGlidIdx];
        }else{
            
            DebugLog(@"フィールドに追加できない");
            // 追加できないので消す
            [ship removeFromSuperview];
        }
    }
}

// 当り設定
- (void)startBtn:(UIButton *)sender
{
    DebugLog(@"start");
    // NSDataにシリアライズして初回設定値を受け渡す
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_myF];
    [self mySendDataToPeers:data];
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
//    [self startPicker];
    
    // NSDataにシリアライズして初回設定値を受け渡す
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_myF];
    [self mySendDataToPeers:data];
}

#pragma mark -
#pragma mark Bluetooth
// 設定済みセッションの所有権を受け取る
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.gameSession = session;
    self.gameSession.delegate = self;
    [self.gameSession setDataReceiveHandler:self withContext:nil];
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
        case GKPeerStateAvailable:
            DebugLog(@"%@ を見つけた！",peerID);
            break;
        case GKPeerStateUnavailable:
            DebugLog(@"%@ を見失った！",peerID);
            break;
        case GKPeerStateConnected:
            DebugLog(@"%@ が接続した！",peerID);
            break;
        case GKPeerStateDisconnected:
            DebugLog(@"%@ が切断された！",peerID);
            break;
        case GKPeerStateConnecting:
            DebugLog(@"%@ が接続中！",peerID);
            break;
        default:
            break;
    }
    switch (state) {
        case GKPeerStateConnected:
            // ほかのピアのpeerIDwを記録する
            // ピアが接続したことをゲームに通知する
            DebugLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            // ピアがいなくなったことをゲームに通知する
            [self invalidateSession:self.gameSession];
            self.gameSession = nil;
            DebugLog(@"disconnected");
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
    NSError *error = nil;
    BOOL ok = [self.gameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    
    NSString *message = @"";
    if (ok) {
        message = @"対戦相手にデータを送信しました";
    }else{
        message = @"データの送信に失敗しました";
        DebugLog(@"%@", error);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"データ送信"
													message:message
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	[alert show];
	[alert release];
//    NSLog(@"Data send [%d]", ok);
    
}

// ほかのピアからデータを受け取る
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
//    NSLog(@"Data receive [%@]", data);
    
    {// フィールド情報を受け取る
        FieldView *field = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // 当り情報を設定する
        _othF.ships = field.ships;
        // 開始フラグをたてる
        _othF.isPlay = YES;
    }
    
    NSString *message = @"対戦相手のデータを受信しました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"データ送信"
													message:message
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	[alert show];
	[alert release];
    
//    {// CGPointを受け取る
//        CGPoint center = *(CGPoint*)[data bytes];
//        UIView *bom = [[BomView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//        bom.center = center;
//        [self.view addSubview:bom];
//        [bom release];
//        
////        [UIView animateWithDuration:0.4f // 完了するまでにかかる秒数
////                              delay:0.0f // 開始までの秒数
////                            options:UIViewAnimationOptionCurveLinear
////                         animations:^{
////                             bom.alpha = 0.0f;
////                             bom.transform = CGAffineTransformMakeScale(10, 10);
////                         }
////                         completion:^(BOOL finished){
////                             NSLog(@"Completed Bom Animation!");
////                         }];
//    }
    
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

