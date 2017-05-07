//
//  ATListSwitchItem.h
//  NoPi
//
//  Created by CoderLT on 15/10/10.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import "ATListItem.h"

@class ATListSwitchItem;
typedef void(^ATListSwitchValueChange)(ATListSwitchItem *item, UISwitch *switchButton);
@interface ATListSwitchItem : ATListItem


/**
 *  开关
 */
@property (nonatomic, assign) BOOL on;
@property (nonatomic, copy) ATListSwitchValueChange valueChangeBlock;

+ (instancetype)itemWithTitle:(NSString *)title on:(BOOL)on;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)on;

@end
