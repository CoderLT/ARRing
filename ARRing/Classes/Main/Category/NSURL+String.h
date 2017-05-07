//
//  NSURL+String.h
//  AT
//
//  Created by CoderLT on 15/1/29.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (String)
/**
 *  URL 避免非法字符
 *
 *  @param string urlString
 *
 *  @return URL
 */
+ (instancetype)URLWithEncodeString:(NSString *)string;
//+ (instancetype)safeURLWithString:(NSString *)string;
@end

@interface NSString (NSURLParameters)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSDictionary *)getURLParameters;
@end
