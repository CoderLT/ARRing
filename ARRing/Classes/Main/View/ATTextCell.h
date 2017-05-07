//
//  ATTextCell.h
//  AT
//
//  Created by CoderLT on 15/10/25.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import "ATBaseXIBCell.h"
#import "ATTextField.h"
#import "ATTextView.h"

/**
 *  继承自NPTextCell的类必须要有textFiled
 */
@interface ATTextCell : ATBaseXIBCell

/**
 *  用户输入时回调,返回YES允许改变,返回NO放弃改变
 */
@property (nonatomic, copy) NSUInteger(^textDidChange)(ATTextCell *cell, NSString *text);
@end
