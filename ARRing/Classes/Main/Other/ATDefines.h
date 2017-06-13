//
//  defines.h
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#ifndef AT_defines_h
#define AT_defines_h
#ifdef __OBJC__

#import <pthread.h>
#import "ATApi.h"
#import "ATLocTool.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "UIColor+Util.h"
#import "NSURL+String.h"
#import "NSArray+Log.h"
#import "UIView+Common.h"
#import "UIImage+Util.h"
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import "ATAlertView.h"
#import "ATActionSheet.h"
#import "MBProgressHUD+Add.h"
#import <YYKit/UIApplication+YYAdd.h>
#import "ATDevTool.h"
#import "ATHttpTool.h"

/**
 *  App设置
 */
#if DEBUG
#define APP_CHANNEL (@"Developers")
#else
#define APP_CHANNEL (@"App Store")
#endif
#define ATAPI_PAGESIZE ((NSUInteger)10)
#define ATAPI_STARTPAGE (1)

/**
 *  图片缓存选项
 */
#define DEFAULT_IMAGE_OPTION (SDWebImageRetryFailed)
#define COOKMAIN_IMAGE_OPTION (SDWebImageRetryFailed | SDWebImageHighPriority)
#define IMPORTANT_IMAGE_OPTION (SDWebImageRetryFailed | SDWebImageHighPriority)
#define SCROLLVIEW_IMAGE_OPTION (SDWebImageRetryFailed | SDWebImageLowPriority)
#define SD_OPTION_DEFAULT (SDWebImageRetryFailed)
#define SD_OPTION_HIGH (SDWebImageRetryFailed | SDWebImageHighPriority | SDWebImageContinueInBackground)
#define SD_OPTION_LOW (SDWebImageRetryFailed | SDWebImageLowPriority)

/**
 *  本地路径
 */
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_DOCUMENT_HIDDEN    ([PATH_OF_DOCUMENT stringByAppendingPathComponent:@".local"])
#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_SHORTVERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLENAME      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_BUNDLEID        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
/**
 *  屏幕适配
 */
#define SCALEW(value) ((int)((SCREEN_WIDTH * (value) / 375)))

#define MAIN_FRAME          ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)
#define STATUS_BAR_HIGHT    (20)
#define NAVI_BAR_HIGHT      (44)
#define TAB_HIGHT           (49)
#define NAVI_HIGHT          (STATUS_BAR_HIGHT + NAVI_BAR_HIGHT)
#define SEGMENT_HIGHT       (0)

/**
 *  多语言
 */
#if 0
#define ATLocalizedString(key, val)  [[ATLanguage sharedInstance] getStringForKey:key table:nil value:(val)]//[[NSBundle mainBundle] localizedStringForKey:(key) value:(val) table:nil]
#define ATLocalizedStringFromTable(key, tbl, val) [[ATLanguage sharedInstance] getStringForKey:key table:tbl value:(val)]// NSLocalizedStringFromTable(key, tbl, comment)
#define ATLocalizedStringFromTableInBundle(key, tbl, bundle, comment) NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment)
#define ATLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment)
#else
#define ATLocalizedString(key, comment) (comment)
#define ATLocalizedStringFromTable(key, tbl, comment) (comment)
#define ATLocalizedStringFromTableInBundle(key, tbl, bundle, comment) (comment)
#define ATLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) (comment)
#endif

/**
 *  多线程
 */
static inline void ATAsyncMainQueue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
static inline void ATSyncMainQueue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 *  文字宽度处理
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define AT_SIGLELINE_TEXTSIZE(text, font) ([(text) length] > 0 ? [(text) sizeWithAttributes:@{NSFontAttributeName:(font)}] : CGSizeZero)
#else
#define AT_SIGLELINE_TEXTSIZE(text, font) ([(text) length] > 0 ? [(text) sizeWithFont:(font)] : CGSizeZero)
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define AT_TEXTSIZE(text, font, maxSize) ([(text) length] > 0 ? [(text) boundingRectWithSize:(maxSize) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:(font)} context:nil].size : CGSizeZero)
#else
#define AT_TEXTSIZE(text, font, maxSize) ([(text) length] > 0 ? [(text) sizeWithFont:(font) constrainedToSize:(maxSize) lineBreakMode:(NSLineBreakByWordWrapping)] : CGSizeZero)
#endif

#define IS_IPHONE_4     ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5     ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6     ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P    ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IOS7         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IOS9         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)

//添加字典时数据安全
#define SafeDicObj(obj) ((obj) ? (obj) : @"")

/**
 * 打印相关
 */
#ifdef DEBUG
#    define ATLog(...) NSLog(__VA_ARGS__)
#else
#    define ATLog(...) /* */
#endif


#define RGB(R, G, B)        RGBA(R, G, B, 1.0)
#define RGBA(R, G, B, A)    [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:A]

#define APP_COLOR               ([UIColor colorWithHexString:@"#000000"])
#define APP_COLOR_LIGHT         ([UIColor colorWithHexString:@"#000000"])
#define APP_COLOR_HL            ([UIColor colorWithHexString:@"#000000"])
#define APP_COLOR_DISABLE       ([UIColor colorWithHexString:@"#000000"])
#define APP_TitleButtonColor    ([UIColor colorWithHexString:@"#ffffff"])
#define APP_TitleButtonColorHL  ([UIColor colorWithHexString:@"#ffffff"])
#define APP_TitleButtonColorDis ([UIColor colorWithHexString:@"#ffffff"])
#define APP_TitleButtonColorSel ([UIColor colorWithHexString:@"#ffffff"])
#define APP_NavBgColor          ([UIColor colorWithHexString:@"#000000"])
#define APP_NavTitleColor       ([UIColor colorWithHexString:@"#ffffff"])
#define APP_TabBgColor          ([UIColor colorWithHexString:@"#f9f9f9"])
#define APP_TabTitleColor       ([UIColor colorWithHexString:@"#8b8b8b"])
#define APP_TabTitleColorHL     ([UIColor colorWithHexString:@"#A6D0FF"])


#define APP_COLOR_BG            ([UIColor colorWithHexString:@"#f3f3f3"])
#define TableViewSeparatorColor ([UIColor colorWithHexString:@"#E8E8E8"])
#define ATHeaderTitleColor      ([UIColor colorWithHexString:@"#333333"])
#define ATTitleColor            ([UIColor colorWithHexString:@"#333333"])
#define ATSubTitleColor         ([UIColor colorWithHexString:@"#666666"])
#define ATDescColor             ([UIColor colorWithHexString:@"#999999"])
#define ATNotifyColor           ([UIColor colorWithHexString:@"#cccccc"])
#define ATPlaceholderColor      ([UIColor colorWithHexString:@"#c8c7cc"])
#define TableViewDeleteColor    ([UIColor colorWithHexString:@"#FF3B30"])

#define ATBigFont               ([UIFont systemFontOfSize:22])
#define ATHeaderFont            ([UIFont systemFontOfSize:18])
#define ATTitleFont             ([UIFont systemFontOfSize:16])
#define ATSubTitleFont          ([UIFont systemFontOfSize:13])
#define ATNotifyFont            ([UIFont systemFontOfSize:12])
#define ATSmallFont             ([UIFont systemFontOfSize:11])

#define ATSubTitleWithTitleFont ATTitleFont




#endif
#endif

