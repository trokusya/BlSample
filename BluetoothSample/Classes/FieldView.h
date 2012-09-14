//
//  FieldView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlidView.h"

@interface FieldView : UIView

@property (nonatomic,retain) NSMutableArray *glids;
@property (nonatomic) NSInteger hitGlid;

@end
