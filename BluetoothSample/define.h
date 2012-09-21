//
//  define.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef BluetoothSample_define_h
#define BluetoothSample_define_h



#endif

#define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// 16進数表記でUIColorを生成する
#define Hex2UIColor(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

// フィールドの枠線の幅
#define FIELD_LINE_WIDTH 2
// フィールドの1辺のグリッド数
#define FIELD_LINE_NUM 6
// グリッドの1辺のサイズ
#define GLID_SIZE 42