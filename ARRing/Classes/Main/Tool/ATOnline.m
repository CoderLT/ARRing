//
//  ATOnline.m
//  Yami
//
//  Created by 敖然 on 15/12/15.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATOnline.h"

@interface ATOnline ()
@property (nonatomic, assign) BOOL online;
@end

static NSString *ATOnlineKey = @"ATOnlineApiOnlineKey";
@implementation ATOnline

static ATOnline *_instance;
+ (void)load {
    [self shareInstance];
}
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.online = [[NSUserDefaults standardUserDefaults] boolForKey:ATOnlineKey];
#ifdef Check_Update_Auto
        [self checkUpdate:3];
#endif
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (BOOL)isOnline {
#if defined(DEBUG) || defined(AdHoc)
    return [[self shareInstance] online];
#endif
    return YES;
}
+ (void)switchEnvironment:(BOOL)isOnline {
    [[self shareInstance] setOnline:isOnline];
}

- (void)setOnline:(BOOL)online {
    _online = online;
    
    [[NSUserDefaults standardUserDefaults] setBool:_online forKey:ATOnlineKey];
}
+ (void)setApiIpAddr:(NSString *)apiIpAddr {
    [[ATOnline shareInstance] setIpAddr:apiIpAddr];
}

+ (NSString *)baseURL {
    NSString *_baseURL;
    if ([ATOnline isOnline]) {
        _baseURL = ATAPI_BASEURL_ONLINE;
    }
    else {
        _baseURL = ATAPI_BASEURL_DEBUG;
    }
//    if ([ATOnline shareInstance].ipAddr.length) {
//        _baseURL = [_baseURL stringByReplacingOccurrencesOfString:ATAPI_HOST withString:[ATOnline shareInstance].ipAddr];
//    }
    return _baseURL;
}



#define PGYER_APPID @"28db21d3c65ed8d7afe36b2beba4477d"
#define PGYER_APIKEY @"80228789cee6efaef85a4365892a5844"
+ (void)checkUpdate:(NSTimeInterval)delay {
    if (!_instance) {
        [self shareInstance];
    }
    [_instance performSelector:@selector(checkUpdate) withObject:nil afterDelay:delay];
}
- (void)checkUpdate {
#if defined(DEBUG) || defined(AdHoc)
    [ATHttpTool POST:@"http://www.pgyer.com/apiv1/app/viewGroup" params:@{@"_api_key" : PGYER_APIKEY, @"aId" : PGYER_APPID} success:^(id responseObject) {
        @try {
            NSDictionary *info = [responseObject[@"data"] lastObject];
            NSString *appStoreVersion = info[@"appVersionNo"];
            NSArray *appStoreVersions = [appStoreVersion componentsSeparatedByString:@"."];
            NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSArray *nowVersions = [nowVersion componentsSeparatedByString:@"."];
            BOOL needUpdate = NO;
            for (int i = 0; i < 3; i++) {
                int now = 0, app = 0;
                if (i < nowVersions.count) {
                    now = [nowVersions[i] intValue];
                }
                if (i < appStoreVersions.count) {
                    app = [appStoreVersions[i] intValue];
                }
                if (app > now) {
                    needUpdate = YES;
                    break;
                }
            }
            if (needUpdate) {
                [ATAlertView showTitle:[NSString stringWithFormat:ATLocalizedString(@"find_new_version", @"发现新版本V%@"), appStoreVersion]
                               message:[NSString stringWithFormat:ATLocalizedString(@"find_new_version_content", @"\r\nApp升级啦, 赶紧更新体验吧~\r\n更新日期:%@"), info[@"appCreated"]] normalButtons:@[ATLocalizedString(@"Cancel", @"取消")]
                      highlightButtons:@[ATLocalizedString(@"update_now", @"立即更新")]
                            completion:^(NSUInteger index, NSString *buttonTitle) {
                                if (index == 0) {
                                    return;
                                }
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.pgyer.com/apiv1/app/install?_api_key=%@&aKey=%@", PGYER_APIKEY, info[@"appKey"]]]];
                            }];
            }
        } @catch (NSException *exception) {
        }
    } failure:nil];
#else
    [ATHttpTool GET:@"http://itunes.apple.com/lookup" params:@{@"id" : SafeDicObj(APP_ID)} success:^(id responseObject) {
        @try {
            NSString *appStoreVersion = responseObject[@"results"][0][@"version"];
            NSArray *appStoreVersions = [appStoreVersion componentsSeparatedByString:@"."];
            NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSArray *nowVersions = [nowVersion componentsSeparatedByString:@"."];
            BOOL needUpdate = NO;
            for (int i = 0; i < 3; i++) {
                int now = 0, app = 0;
                if (i < nowVersions.count) {
                    now = [nowVersions[i] intValue];
                }
                if (i < appStoreVersions.count) {
                    app = [appStoreVersions[i] intValue];
                }
                if (app > now) {
                    needUpdate = YES;
                    break;
                }
            }
            if (needUpdate) {
                [ATAlertView showTitle:[NSString stringWithFormat:ATLocalizedString(@"find_new_version", @"发现新版本V%@"), appStoreVersion]
                               message:ATLocalizedString(@"find_new_version_content_appstore", @"\r\nApp升级啦, 赶紧更新体验吧~") normalButtons:@[ATLocalizedString(@"Cancel", @"取消")]
                      highlightButtons:@[ATLocalizedString(@"update_now", @"立即更新")]
                            completion:^(NSUInteger index, NSString *buttonTitle) {
                                if (index == 0) {
                                    return;
                                }
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", APP_ID]]];
                            }];
            }
        } @catch (NSException *exception) {
            
        }
    } failure:nil];
#endif
}
@end
