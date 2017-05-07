//
//  ATDevTool.m
//  AT
//
//  Created by 林涛 on 15/3/31.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATDevTool.h"
#import <AdSupport/AdSupport.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ATDevTool

+ (NSString *)publicNetworkIp {
    NSString *publicNetworkIp = @"192.168.1.101";
    NSStringEncoding enc;
    NSString *returnStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"] usedEncoding:&enc error:nil];
    returnStr = [returnStr componentsSeparatedByString:@"="][1];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[returnStr dataUsingEncoding:enc] options:0 error:nil];
    if ([dic isKindOfClass:[NSDictionary class]] && dic[@"cip"]) {
        publicNetworkIp = dic[@"cip"];
    }
    return publicNetworkIp;
}

+ (NSString *)IDFAString {
    static NSString *idfaString;
    if (!idfaString) {
        idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return idfaString;
}

+ (void)callTel:(NSString *)tel {
    if (tel.length < 3) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)openSystemSetting {
    return [self openSystemURLString:UIApplicationOpenSettingsURLString];
}
+ (BOOL)openSystemSettingWifi {
    if (![self openSystemURLString:@"prefs:root=WIFI"]) {
        NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[LSApplicationWorkspace performSelector:NSSelectorFromString(@"defaultWorkspace")] performSelector:NSSelectorFromString(@"openSensitiveURL:withOptions:") withObject:url withObject:nil];
#pragma clang diagnostic pop
    }
    return YES;
}
+ (BOOL)openSystemURLString:(NSString *)urlString {
    NSURL * url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

#pragma mark - 获取最近一张照片
+ (void)getLatestPhoto:(void(^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
        [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            // Within the group enumeration block, filter to enumerate just photos.
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            // Get the photo at the last index
            NSUInteger index              = [group numberOfAssets];
            if (index < 1) {
                return;
            }
            NSIndexSet* lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index - 1];
            [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                // The end of the enumeration is signaled by asset == nil.
                if (result == nil) {
                    return;
                }
                
                ALAssetRepresentation* representation = [result defaultRepresentation];
                
                // Retrieve the image orientation from the ALAsset
                UIImageOrientation orientation = UIImageOrientationUp;
                NSNumber* orientationValue = [result valueForProperty:@"ALAssetPropertyOrientation"];
                if (orientationValue != nil) {
                    orientation = [orientationValue intValue];
                }
                
                UIImage* image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:orientation];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(image);
                    }
                });
            }];
        } failureBlock:^(NSError *error) {
            
        }];
    });
}
@end
