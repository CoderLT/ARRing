//
//  SATextFieldCell.h
//  SmartAquarium
//
//  Created by CoderLT on 16/5/2.
//  Copyright © 2016年 SA. All rights reserved.
//

#import "ATTextFieldCell.h"

@interface ATLoginTextFieldCell : ATTextFieldCell

@end


@interface ATPhoneCell : ATLoginTextFieldCell

@end


@interface ATPasswordCell : ATLoginTextFieldCell

@end


@interface ATSmsCodeCell : ATLoginTextFieldCell

/**
 *  获取验证码按钮点击回调
 */
@property (nonatomic, copy) void(^didClickButton)(ATSmsCodeCell *cell);
/**
 *  获取验证码按钮倒计时
 */
- (void)setGetSMSCodeDelay;
- (void)setGetSMSCodeDelay:(NSUInteger)delay;
@end