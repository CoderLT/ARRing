//
//  ATOnline.h
//  Yami
//
//  Created by 敖然 on 15/12/15.
//  Copyright © 2015年 AT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOnline : NSObject

+ (instancetype)shareInstance;


// 是否 正式环境
+ (BOOL)isOnline;
+ (void)switchEnvironment:(BOOL)isOnline;

/**
 *  直连IP地址
 */
@property (nonatomic, copy) NSString *ipAddr;
+ (NSString *)baseURL;
+ (void)setApiIpAddr:(NSString *)apiIpAddr;

/**
 *  检查更新: 应用启动后自动执行
 *
 *  @param delay 延迟执行
 */
#define Check_Update_Auto
+ (void)checkUpdate:(NSTimeInterval)delay;
@end
