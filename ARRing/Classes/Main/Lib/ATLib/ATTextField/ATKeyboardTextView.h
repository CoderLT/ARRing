//
//  ATKeyboardTextView.h
//  AT
//
//  Created by xiao6 on 14-10-23.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTextBaseView.h"

@interface ATKeyboardTextView : UIView

+ (ATKeyboardTextView *)inputViewHidden:(BOOL)defaultHidden textWillSend:(void(^)(id params, NSString *text))block;

@property (nonatomic, assign) BOOL defaultHidden;
@property (nonatomic, copy) void(^textWillSendBlock)(id params, NSString *text);
@property (nonatomic, strong) id params;


/**
 *  开始编辑
 */
- (void)showWithPlaceholder:(NSString *)placeholder params:(id)params;
@end
