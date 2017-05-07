//
//  ATDatePicker
//  AT
//
//  Created by ATDatePicker on 15/11/15.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>

@interface ATDatePicker : MMPopupView
/**
 *  日期选择控件
 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/**
 *  时间改变时回调
 */
@property (nonatomic, copy) void(^dateDidChange)(UIDatePicker *datePicker);

@end
