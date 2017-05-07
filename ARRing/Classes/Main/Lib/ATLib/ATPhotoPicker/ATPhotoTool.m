//
//  ATPhotoTool.m
//  AT
//
//  Created by CoderLT on 15/3/23.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATPhotoTool.h"
#import <objc/runtime.h>
#import "ATActionSheet.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "UIViewController+Util.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ATPhotoTool () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, CTAssetsPickerControllerDelegate >
/**
 *  完成时调用
 */
@property (nonatomic, copy) ATPhotoPickerCompletion completion;
@property (nonatomic, copy) ATPhotoMutiPickerCompletion mutiPickerCompletion;
/**
 *  最多选择图片数
 */
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ATPhotoTool
static ATPhotoTool *_instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (UIViewController *)photoPickerVCWithSourceType:(UIImagePickerControllerSourceType)sourceType
                                    allowsEditing:(BOOL)allowsEditing
                                       completion:(ATPhotoPickerCompletion)completion
{
    [ATPhotoTool sharedInstance].completion = completion;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.allowsEditing = allowsEditing;
    picker.delegate = [ATPhotoTool sharedInstance];

    return (UIViewController *)picker;
}

+ (UIViewController *)photoPickerVCWithMultiSelect:(NSUInteger)maxCount
                                     pickingAssets:(NSArray *)assets
                                        completion:(ATPhotoMutiPickerCompletion)completion
{
    [ATPhotoTool sharedInstance].maxCount = maxCount;
    [ATPhotoTool sharedInstance].mutiPickerCompletion = completion;

    CTAssetsPickerController * picker = [[CTAssetsPickerController alloc] init];
    picker.delegate = [ATPhotoTool sharedInstance];
    // create options for fetching photo only
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
    
    // assign options
    picker.assetsFetchOptions = fetchOptions;
//    picker.assetsFilter = [ALAssetsFilter allPhotos]; // Only pick photos.
    if (assets.count) {
        picker.selectedAssets = [assets mutableCopy];
    }

    return (UIViewController *)picker;
}

+ (void)showPhotoPickerVCWithMultiSelect:(NSUInteger)maxCount pickingAssets:(NSArray *)assets completion:(ATPhotoMutiPickerCompletion)completion {
    [self showPhotoPicterWithMultiSelect:maxCount allowsEditing:NO pickingAssets:assets completion:completion];
}
+(void)showPhotoPicter:(BOOL)allowsEditing completion:(ATPhotoPickerCompletion)completion {
    return [self showPhotoPicter:allowsEditing message:nil completion:completion];
}
+ (void)showPhotoPicter:(BOOL)allowsEditing message:(NSString *)message completion:(ATPhotoPickerCompletion)completion {
    [self showPhotoPicterWithMultiSelect:1 message:message allowsEditing:allowsEditing pickingAssets:nil completion:^(NSArray *imageArray, NSArray *assets) {
        if (completion) {
            if (imageArray.count) {
                completion(imageArray[0]);
            }
        }
    }];
}
+(void)showPhotoPicterWithMultiSelect:(NSUInteger)maxCount allowsEditing:(BOOL)allowsEditing pickingAssets:(NSArray *)assets completion:(ATPhotoMutiPickerCompletion)completion {
    return [self showPhotoPicterWithMultiSelect:maxCount message:nil allowsEditing:allowsEditing pickingAssets:assets completion:completion];
}
+(void)showPhotoPicterWithMultiSelect:(NSUInteger)maxCount message:(NSString *)message allowsEditing:(BOOL)allowsEditing pickingAssets:(NSArray *)assets completion:(ATPhotoMutiPickerCompletion)completion
{    [ATActionSheet showWithTitle:message
                    normalButtons:@[ATLocalizedString(@"Take Photo", @"拍照"), ATLocalizedString(@"Choose from mobile phone album", @"从手机相册选择")
]
                highlightButtons:nil
                      completion:^(NSInteger index, NSString *buttonTitle) {
                          UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
                          if (index == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                              type =  UIImagePickerControllerSourceTypeCamera;
                          }
                          if (type == UIImagePickerControllerSourceTypeCamera) {
                              AVAuthorizationStatus authStatusCamera = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                              if (authStatusCamera == kCLAuthorizationStatusRestricted || authStatusCamera == AVAuthorizationStatusDenied) {
                                  [ATAlertView showTitle:ATLocalizedString(@"Tips", @"温馨提示") message:ATLocalizedString(@"Setting_camera_Permission", @"请到设置->隐私中开启本程序相机权限") normalButtons:@[ATLocalizedString(@"Cancel", @"取消")] highlightButtons:@[ATLocalizedString(@"Confirm", @"确定")] completion:^(NSUInteger index, NSString *buttonTitle) {
                                      if (index == 0) {
                                          return;
                                      }
                                      else {
                                          NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                          if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                              [[UIApplication sharedApplication] openURL:url];
                                          }
                                      }
                                  }];
                                  return ;
                              }
                          } else {
                              ALAuthorizationStatus authStatusAlbum = [ALAssetsLibrary authorizationStatus];
                              if (authStatusAlbum == AVAuthorizationStatusDenied || authStatusAlbum == AVAuthorizationStatusDenied) {
                                  [ATAlertView showTitle:ATLocalizedString(@"Tips", @"温馨提示") message:ATLocalizedString(@"Setting_photoAlbum_Permission", @"请到设置->隐私中开启本程序相册权限") normalButtons:@[ATLocalizedString(@"Cancel", @"取消")] highlightButtons:@[ATLocalizedString(@"Confirm", @"确定")] completion:^(NSUInteger index, NSString *buttonTitle) {
                                      if (index == 0) {
                                          return;
                                      }
                                      else {
                                          NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                          if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                              [[UIApplication sharedApplication] openURL:url];
                                          }
                                      }
                                  }];
                                  return ;
                              }
                          }
                          UIViewController *picker;
                          if (maxCount > 1 && type != UIImagePickerControllerSourceTypeCamera) {
                              picker = [ATPhotoTool photoPickerVCWithMultiSelect:maxCount pickingAssets:assets completion:completion];
                          }
                          else {
                              picker = [ATPhotoTool photoPickerVCWithSourceType:type allowsEditing:allowsEditing completion:^(UIImage *image) {
                                  if (completion && image) {
                                      completion(@[image], nil);
                                  }
                              }];
                          }
                          
                          [[UIViewController rootTopPresentedVC] presentViewController:picker
                                                                              animated:YES
                                                                            completion:nil];
                      }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    if (self.completion) {
        self.completion(image);
        self.completion = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.completion) {
        self.completion = nil;
    }
}

#pragma mark - CTAssetsPickerControllerDelegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    return (picker.selectedAssets.count < self.maxCount);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *imageArray = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
//        ALAssetRepresentation *representation = asset.defaultRepresentation;
//        UIImage *fullResolutionImage = [UIImage imageWithCGImage:representation.fullResolutionImage
//                                                           scale:1.0f
//                                                     orientation:(UIImageOrientation)representation.orientation];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //设置图片
            [imageArray addObject:result];
            
            if (idx == assets.count - 1) {
                if (self.mutiPickerCompletion) {
                    self.mutiPickerCompletion(imageArray, assets);
                    self.mutiPickerCompletion = nil;
                }
            }
        }];
    }];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.mutiPickerCompletion) {
        self.mutiPickerCompletion = nil;
    }
}


@end
