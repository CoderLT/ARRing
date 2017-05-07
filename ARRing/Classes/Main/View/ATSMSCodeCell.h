//
//  ATSMSCodeCell.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/20.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATTextCell.h"

@interface ATSMSCodeCell : ATTextCell
@property (nonatomic, weak) IBOutlet ATTextField *textField;
/**
 *  获取验证码按钮点击回调
 */
@property (nonatomic, copy) void(^didClickButton)(ATSMSCodeCell *cell);
/**
 *  获取验证码按钮倒计时
 */
- (void)setGetSMSCodeDelay;
- (void)setGetSMSCodeDelay:(NSUInteger)delay;
@end
