//
//  ATLocTool.m
//  AT
//
//  Created by CoderLT on 15/4/14.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATLocTool.h"
#import <INTULocationManager/INTULocationManager.h>
#import "MBProgressHUD+Add.h"

static CLLocation *loc;
@implementation ATLocTool
+ (CLLocation *)currentLoction {
    return loc;
}
+ (void)LocationWithCompeletion:(ATLocToolBlock)compeletion {
    [ATLocTool LocationWithHighAccuracy:NO delayUntilAuthorized:YES compeletion:compeletion];
}
+ (void)LocationWithHighAccuracy:(BOOL)highAccuracy compeletion:(ATLocToolBlock)compeletion {
    [ATLocTool LocationWithHighAccuracy:highAccuracy delayUntilAuthorized:YES compeletion:compeletion];
}
+ (void)LocationWithHighAccuracy:(BOOL)highAccuracy
            delayUntilAuthorized:(BOOL)delayUntilAuthorized
                     compeletion:(ATLocToolBlock)compeletion {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:highAccuracy ? INTULocationAccuracyHouse : INTULocationAccuracyCity
                                                                     timeout:30
                                                        delayUntilAuthorized:delayUntilAuthorized
                                                                       block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status)
     {
         assert(ATLocStatusError == INTULocationStatusError);
         if (status == INTULocationStatusSuccess) {
             loc = currentLocation;
         }
         if (compeletion) {
             compeletion(currentLocation, (ATLocStatus)status);
         }
    }];
}
+ (void)LocationInfoWithCompeletion:(ATLocToolInfoBlock)compeletion {
    [ATLocTool LocationWithHighAccuracy:NO compeletion:^(CLLocation *currentLocation, ATLocStatus status) {
        if (ATLocStatusSuccess == status) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currentLocation
                           completionHandler:^(NSArray *placemarks, NSError *error){
                               if (compeletion) {
                                   compeletion(currentLocation, [placemarks firstObject], (error ? ATLocStatusError : ATLocStatusSuccess));
                               }
                           }];
        }
        else {
            if (compeletion) {
                compeletion(currentLocation, nil, status);
            }
        }
    }];
}
@end
