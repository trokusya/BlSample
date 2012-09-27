//
//  FieldView.m
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FieldView.h"
#import "BlViewController.h"

@implementation FieldView

@synthesize glids;
@synthesize ships;
@synthesize colNum;
@synthesize rowNum;
@synthesize size = _size;
@synthesize isPlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithGridNum:(int)num size:(int)size type:(FiledType)type
{
    _glidWidth = size, _glidHeight = _glidWidth;
    _size = size;
    
    self = [super initWithFrame:CGRectMake(0, 0, _glidWidth * num + FIELD_LINE_WIDTH, _glidHeight * num + FIELD_LINE_WIDTH)];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
        
        // 初期化
        glids = [[NSMutableArray alloc]init];
        ships = [[NSMutableDictionary alloc]init];
        
        // 列,行数
        colNum = num, rowNum = colNum;
        
        // 設定が終わるまでfalseにしておく
        isPlay = NO;
    }
    return self;
}

- (void)setTarget:(id)target selector:(SEL)selector
{
    _sendTarget = target;
    _sendSelector = selector;
}

// フィールドを描画
- (void)drawRect:(CGRect)rect
{
    // マス目の数分作る
    float delay = 0.5f / (rowNum * colNum);
    for (int i = 0; i < rowNum * colNum; i++) {
        
        int xIdx = i % colNum;
        int yIdx = i / rowNum;
        
        // マス目
        GlidView *glid;
        CGRect glidFrame = CGRectMake(_glidWidth * xIdx + FIELD_LINE_WIDTH/2, _glidHeight * yIdx + FIELD_LINE_WIDTH/2, _glidWidth, _glidHeight);
        switch (_type) {
            case FieldTypeOwn:
                glid = [[GlidView alloc]initWithFramae:glidFrame color:Hex2UIColor(0x90D7EC)];
                break;
            case FieldTypeOth:
                glid = [[GlidView alloc]initWithFramae:glidFrame color:Hex2UIColor(0xEF8F9C)];
                break;
            default:
                glid = [[GlidView alloc]initWithFrame:glidFrame];
                break;
        }
        
        glid.alpha = 0;
        [self addSubview:glid];
        [glids addObject:glid]; // 管理用配列に追加しとく
        
        [UIView animateWithDuration:0.3f // 完了するまでにかかる秒数
                              delay:0.0f+(i*delay) // 開始までの秒数
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             glid.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                         }];
        [glid release];
    }
}

// 戦艦をフィールドに配置する
- (void)addBattleShip:(BattleshipView*)ship glidIdx:(int)glidIdx
{
    DebugLog(@"glidIdx [%d]", glidIdx);
    
    // フィールド内で離された場合位置をマス目にあわせる
    GlidView *glid = [glids objectAtIndex:glidIdx];
    //    ship.center = glid.center;
    // 配置インデックス
    ship.index = glidIdx;
    // セット済みにする
    ship.isSet = YES;
    
    CGRect shipRect = ship.frame;
    DebugLog(@"shipFramex [%f],shipFrame [%f]", shipRect.origin.x, shipRect.origin.y);
    
    switch (ship.viewMode) {
        case ShipViewModeTop:
        case ShipViewModeBottom:
            // グリッドのx+(グリッドの幅/2 - 船の幅/2)
            shipRect.origin.x = glid.frame.origin.x + (glid.frame.size.width/2 - ship.frame.size.width/2);
            shipRect.origin.y = glid.frame.origin.y + (glid.frame.size.height*ship.glidNum - ship.frame.size.height)/2;
            break;
        case ShipViewModeRight:
        case ShipViewModeLeft:
            // グリッドのx+(グリッドの幅*船の必要マス数/2 - 船の幅/2)
            shipRect.origin.x = glid.frame.origin.x + (glid.frame.size.width*ship.glidNum/2 - ship.frame.size.width/2);
            shipRect.origin.y = glid.frame.origin.y + (glid.frame.size.height - ship.frame.size.height)/2;
            break;
        default:
            break;
    }
    
    ship.frame = shipRect;
    //    DebugLog(@"glidframex [%f],glidframey [%f]", glid.frame.origin.x,glid.frame.origin.x);
    // マスに配置
    [self addSubview:ship];
    
    // 船情報を格納しておく(長さ分)
    for (int i=0; i<ship.glidNum; i++) {
        
        switch (ship.viewMode) {
            case ShipViewModeTop:
            case ShipViewModeBottom:
                // 縦に長さ分追加
                [ships setObject:ship forKey:[NSString stringWithFormat:@"%d", glidIdx + rowNum*i]];
                break;
            case ShipViewModeRight:
            case ShipViewModeLeft:
                // 横に長さ分追加
                [ships setObject:ship forKey:[NSString stringWithFormat:@"%d", glidIdx + i]];
                break;
                
            default:
                break;
        }
    }
}

// 戦艦をフィールドに配置する
- (void)addBattleShip:(BattleshipView*)ship colIdx:(int)colIdx rowIdx:(int)rowIdx
{
    int glidIdx = colIdx + rowIdx * rowNum;
    [self addBattleShip:ship glidIdx:glidIdx];
}

#pragma mark -
#pragma mark タッチイベント

// フィールドビュータッチイベント
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"start");
    if (isPlay) {
        UITouch* touch = [touches anyObject];
        CGPoint pt = [touch locationInView:self];
        [self selectGlidPt:pt];
    }
}

// マス目が選択されたら
- (void)selectGlidPt:(CGPoint)point
{
    //    // 弾表示位置
    //    NSData *data = [NSData dataWithBytes:&point length:sizeof(point)];
    //    
    //    // データ送信
    //    [self mySendDataToPeers:data];
    
    
    // 列インデックス
    int colIdx = point.x / self.size;
    
    // 行インデックス
    int rowIdx = point.y / self.size;
    
//    NSLog(@"[%d] [%d]",colIdx,rowIdx);
    
    // フィールド外は無視
    if (point.x < 0 || point.y < 0 || self.colNum <= colIdx || self.rowNum <= rowIdx) {
        return;
    }
    
    // グリッドインデックスを算出
    int glidIdx = colIdx + rowIdx * self.rowNum;
    
    // グリッド選択
    [self selectGlidIdx:glidIdx];
}

// マス目が選択されたら
- (void)selectGlidIdx:(int)glidIdx
{
    //    // 弾表示位置
    //    NSData *data = [NSData dataWithBytes:&point length:sizeof(point)];
    //
    //    // データ送信
    //    [self mySendDataToPeers:data];
    
    GlidView *glid = [self.glids objectAtIndex:glidIdx];
    
    if (_type == FieldTypeOwn) {
        // 自分のフィールド
        glid.glidStatus = GlidStateSelected;
    }else{
        // 相手のフィールド
        // 当たり判定
        BOOL hit = [self.ships.allKeys containsObject:[NSString stringWithFormat:@"%d", glidIdx]];
        glid.glidStatus = (hit)? GlidStateHit : GlidStateSelect;
        
        [self bringSubviewToFront:glid]; // 指定のグリッドを一番上の階層に移動
    }
    
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
    
    // 選択したグリッドindexを対戦相手に送る
    [_sendTarget performSelector:_sendSelector withObject:[NSNumber numberWithInt:GameStatusPlay] withObject:[NSNumber numberWithInt:glidIdx]];
    
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
    
    //    UIView *bom = [[BomView alloc]initWithFrame:CGRectMake(self.frame.origin.x+boxW*col, self.frame.origin.y+boxH*row, 44, 44)];
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

#pragma mark -
#pragma mark NSCoding
// シリアライズ
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_glidWidth forKey:@"_glidWidth"];
    [aCoder encodeInt:_glidHeight forKey:@"_glidHeight"];
    [aCoder encodeInt:_size forKey:@"_size"];
    [aCoder encodeInt:colNum forKey:@"colNum"];
    [aCoder encodeInt:rowNum forKey:@"rowNum"];
    
    [aCoder encodeObject:glids forKey:@"glids"];
    [aCoder encodeObject:ships forKey:@"ships"];
}
// デシリアライズ
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _glidWidth = [aDecoder decodeIntForKey:@"_glidWidth"];
        _glidHeight = [aDecoder decodeIntForKey:@"_glidHeight"];
        
        _size = [aDecoder decodeIntForKey:@"_size"];
        colNum = [aDecoder decodeIntForKey:@"colNum"];
        rowNum = [aDecoder decodeIntForKey:@"rowNum"];
        
        glids = [[aDecoder decodeObjectForKey:@"glids"] retain];
        ships = [[aDecoder decodeObjectForKey:@"ships"] retain];
    }
    return self;
}

@end
