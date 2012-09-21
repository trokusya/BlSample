//
//  FieldGlidView.h
//  BluetoothSample
//
//  Created by 六車 俊博 on 12/09/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "define.h"

enum GlidState{
    GlidStateBegin,
    GlidStateHit,
    GlidStateSelect
};

@interface GlidView : UIView
{
    UIColor *_glidColor;
}

- (id)initWithFramae:(CGRect)frame color:(UIColor*)color;

@property (nonatomic) NSInteger glidStatus;

@end
