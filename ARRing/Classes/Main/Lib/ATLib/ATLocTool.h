//
//  ATLocTool.h
//  AT
//
//  Created by CoderLT on 15/4/14.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>
/** A status that will be passed in to the completion block of a location request. */
typedef NS_ENUM(NSInteger, ATLocStatus) {
    // These statuses will accompany a valid location.
    /** Got a location and desired accuracy level was achieved successfully. */
    ATLocStatusSuccess = 0,
    /** Got a location, but the desired accuracy level was not reached before timeout. (Not applicable to subscriptions.) */
    ATLocStatusTimedOut,

    // These statuses indicate some sort of error, and will accompany a nil location.
    /** User has not yet responded to the dialog that grants this app permission to access location services. */
    ATLocStatusServicesNotDetermined,
    /** User has explicitly denied this app permission to access location services. */
    ATLocStatusServicesDenied,
    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
    ATLocStatusServicesRestricted,
    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
    ATLocStatusServicesDisabled,
    /** An error occurred while using the system location services. */
    ATLocStatusError
};

typedef void(^ATLocToolBlock)(CLLocation *currentLocation, ATLocStatus status);
typedef void(^ATLocToolInfoBlock)(CLLocation *currentLocation, CLPlacemark *place, ATLocStatus status);
@interface ATLocTool : NSObject
+ (CLLocation *)currentLoction;
+ (void)LocationWithCompeletion:(ATLocToolBlock)compeletion;
+ (void)LocationWithHighAccuracy:(BOOL)highAccuracy compeletion:(ATLocToolBlock)compeletion;
+ (void)LocationWithHighAccuracy:(BOOL)highAccuracy
            delayUntilAuthorized:(BOOL)delayUntilAuthorized
                     compeletion:(ATLocToolBlock)compeletion;
+ (void)LocationInfoWithCompeletion:(ATLocToolInfoBlock)compeletion;
@end
