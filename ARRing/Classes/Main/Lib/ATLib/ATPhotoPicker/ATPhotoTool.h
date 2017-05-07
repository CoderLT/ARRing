//
//  ATPhotoTool.h
//  AT
//
//  Created by CoderLT on 15/3/23.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ATPhotoPickerCompletion)(UIImage *image);
typedef void (^ATPhotoMutiPickerCompletion)(NSArray *imageArray, NSArray *assets);

@interface ATPhotoTool : NSObject

+ (UIViewController *)photoPickerVCWithSourceType:(UIImagePickerControllerSourceType)sourceType
                                    allowsEditing:(BOOL)allowsEditing
                                       completion:(ATPhotoPickerCompletion)completion;

+ (UIViewController *)photoPickerVCWithMultiSelect:(NSUInteger)maxCount
                                    pickingAssets:(NSArray *)assets
                                       completion:(ATPhotoMutiPickerCompletion)completion;
/**
 *  显示图片选择器
 */
+ (void)showPhotoPicter:(BOOL)allowsEditing completion:(ATPhotoPickerCompletion)completion;
+ (void)showPhotoPicter:(BOOL)allowsEditing message:(NSString *)message completion:(ATPhotoPickerCompletion)completion;
+ (void)showPhotoPickerVCWithMultiSelect:(NSUInteger)maxCount pickingAssets:(NSArray *)assets completion:(ATPhotoMutiPickerCompletion)completion;
+ (void)showPhotoPicterWithMultiSelect:(NSUInteger)maxCount allowsEditing:(BOOL)allowsEditing pickingAssets:(NSArray *)assets completion:(ATPhotoMutiPickerCompletion)completion;

@end
