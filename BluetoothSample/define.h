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

// フィールドの枠線の幅
#define FIELD_LINE_WIDTH 2
// フィールドの1辺のグリッド数
#define FIELD_LINE_NUM 6
// グリッドの1辺のサイズ
#define GLID_SIZE 42