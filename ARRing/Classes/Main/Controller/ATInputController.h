//
//  ATInputController.h
//  LeJi
//
//  Created by CoderLT on 16/4/16.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ATBaseTableViewController.h"

@interface ATInputController : ATBaseTableViewController

/**
 *  输入完成时的回调
 */
@property (nonatomic, copy) void(^completion)(NSString *content);

/**
 *  文本修改
 *
 *  @param title             页面标题
 *  @param content           默认文本信息
 *  @param placeHolder       提示信息
 *  @param keyboardType      键盘设置
 *  @param textDidChange     值改变时回调, 返回限制的最大字符数
 *  @param completion        完成时回调
 *
 *  @return 返回页面实例
 */
+ (instancetype)vcWithTitle:(NSString *)title
                    content:(NSString *)content
                placeholder:(NSString *)placeHolder
               keyboardType:(UIKeyboardType)keyboardType
              textDidChange:(NSUInteger(^)(NSString *text, UIButton *finishButton))textDidChange
                 completion:(void(^)(NSString *content))completion;
@end
@interface ATInputTextViewController : ATInputController
@end
