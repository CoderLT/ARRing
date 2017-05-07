//
//  ATDevTool.h
//  AT
//
//  Created by 林涛 on 15/3/31.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDevTool : NSObject
/**
 *  获取公网IP
 */
+ (NSString *)publicNetworkIp;
/**
 *  获取 IDFA
 */
+ (NSString *)IDFAString;
/**
 *  拨打电话
 */
+ (void)callTel:(NSString *)tel;
/**
 *  打开系统设置
 */
+ (BOOL)openSystemSetting;
+ (BOOL)openSystemSettingWifi;
+ (BOOL)openSystemURLString:(NSString *)urlString;
/**
 *  获取最近一张照片
 */
+ (void)getLatestPhoto:(void(^)(UIImage *image))completion;
@end
