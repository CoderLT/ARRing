//
//  ViewController.m
//  ARRing
//
//  Created by CoderLT on 2017/4/29.
//  Copyright © 2017年 AT. All rights reserved.
//

#import "ViewController.h"

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>
#include "GestureRecognizer.hpp"

// Macros for time measurements
#if 1
#define TS(name) int64 t_##name = cv::getTickCount()
#define TE(name) printf("TIMER_" #name ": %.2fms\n", \
1000.*((cv::getTickCount() - t_##name) / cv::getTickFrequency()))
#else
#define TS(name)
#define TE(name)
#endif

@interface ViewController () <CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *ringImageView;
@property (nonatomic, assign) BOOL showDebug;
@property (nonatomic, strong) UISlider *slider0;
@property (nonatomic, strong) UISlider *slider1;
@property (nonatomic, strong) UISlider *slider2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flashItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *debugItem;
@property (nonatomic, strong) AVCaptureDevice *device;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"AR试戴💍";
    
    CGFloat h = self.view.frame.size.width * 640 / 480;
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              (self.view.frame.size.height - h) / 2,
                                                              self.view.frame.size.width,
                                                              h)];
    [self.view addSubview:self.videoView];
    
//    self.showDebug = NO;
    self.slider0.value = 0.5f;
    self.slider1.value = 0.5f;
    self.slider2.value = 0.5f;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoCamera start];
    self.videoCamera.delegate = self;
    [self.videoView bringSubviewToFront:self.ringImageView];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    AVCaptureDevice *device = self.device;
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device setFlashMode:AVCaptureFlashModeOn];
        
        [device.formats enumerateObjectsUsingBlock:^(AVCaptureDeviceFormat * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"IOS is duration: %.2f - %.2f, IOS: %.2f - %.2f", (CGFloat)obj.minExposureDuration.value / obj.minExposureDuration.timescale, (CGFloat)obj.maxExposureDuration.value / obj.maxExposureDuration.timescale, obj.minISO, obj.maxISO);
        }];
        
//        device.exposureMode = AVCaptureExposureModeCustom;
//        [device setExposureModeCustomWithDuration:device.activeFormat.maxExposureDuration ISO:device.activeFormat.minISO completionHandler:nil];
        
        [device unlockForConfiguration];
    }
    [self updateFlashItem];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.videoCamera stop];
    self.videoCamera.delegate = nil;
    
    AVCaptureDevice *device = self.device;
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
    }
    [self updateFlashItem];
}
- (void)didValueChange:(UISlider *)slider {
//    AVCaptureDeviceFormat *format = self.device.activeFormat;
//    static CGFloat time0 = CMTimeGetSeconds(self.device.exposureDuration);
//    [self.device lockForConfiguration:nil];
//    self.device.exposureMode = AVCaptureExposureModeCustom;
//    Float64 time = time0 * self.slider0.value/0.5f;
//    float iso = format.minISO + (format.maxISO - format.minISO) * self.slider1.value;
//    
//    NSLog(@"IOS is duration: %.2f>%2f<<%.2f, IOS: %.2f>>%.2f<<%.2f", (CGFloat)format.minExposureDuration.value / format.minExposureDuration.timescale, (CGFloat)time, (CGFloat)format.maxExposureDuration.value / format.maxExposureDuration.timescale, format.minISO, iso, format.maxISO);
//    
//    [self.device setExposureModeCustomWithDuration:CMTimeMakeWithSeconds(time, 1000000) ISO:iso completionHandler:nil];
//    [self.device unlockForConfiguration];
    
}
- (IBAction)didClickDebug:(UIBarButtonItem *)sender {
    self.showDebug = !self.showDebug;
}
- (IBAction)didClickFlash:(UIBarButtonItem *)sender {
    AVCaptureDevice *device = self.device;
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if (device.isFlashActive) {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
        } else {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        }
        [device unlockForConfiguration];
    }
    [self updateFlashItem];
}
- (void)updateFlashItem {
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device hasTorch] && [device hasFlash]){
        self.flashItem.title = (device.isFlashActive ? @"关闭闪光灯" : @"打开闪光灯");
    }
}
- (void)setShowDebug:(BOOL)showDebug {
    _showDebug = showDebug;
    
    self.debugItem.title = (_showDebug ? @"关闭调试信息" : @"显示调试信息");
}
//前后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)processImage:(cv::Mat &)image {
    TS(Detect);
    
    cv::Vec6i params = {0,0,0,0,0,0};
    params[0] = self.showDebug;
//    params[1] = (int)(self.slider0.value * 20);
//    params[2] = (int)(self.slider1.value * 20);
//    params[3] = (int)(self.slider2.value * 20);
//    
//    printf("%d/%d/%d/%d/%d/%d  ", params[0], params[1], params[2], params[3], params[4], params[5]);
    
    gestureRecognizer(image, params);
    
    __weak typeof(self) weakSelf = self;
    BOOL findFinger = NO;
    for (int i = 0; i < hand.figers.size(); i++) {
        ATFinger finger = hand.figers[i];
        if (finger.index == 2) {
            float scale = (self.videoView.frame.size.width / image.cols);
            cv::Point2f center = Point2f(finger.ringLine[2], finger.ringLine[3]) * scale;
            float width = finger.size.width * scale;
            float angle = atan2f(finger.ringLine[1], finger.ringLine[0]);
//            printf("%f \n", angle * 180 / M_PI);
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.ringImageView.transform = CGAffineTransformIdentity;
                strongSelf.ringImageView.frame = CGRectMake(0, 0, width, self.ringImageView.image.size.height * width / self.ringImageView.image.size.width);
                strongSelf.ringImageView.center = CGPointMake(center.x, center.y);
                strongSelf.ringImageView.transform = CGAffineTransformMakeRotation(angle - M_PI_2);
            });
            findFinger = YES;
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGFloat alpha = strongSelf.ringImageView.alpha;
        if (findFinger) {
            alpha += 0.1;
        }
        else {
            alpha -= 0.1;
        }
        if (alpha > (_showDebug ? 0.5f : 1.0f)) {
            alpha = _showDebug ? 0.5f : 1.0f;
        }
        else if (alpha < 0) {
            alpha = 0;
        }
        strongSelf.ringImageView.alpha = alpha;
    });
    
//    TE(Detect);
}

- (void)dealloc {
    [self.videoCamera stop];
    self.videoCamera.delegate = nil;
}

#pragma mark - getter
- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    return _device;
}
- (UIImageView *)ringImageView {
    if (!_ringImageView) {
        _ringImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring"]];
        _ringImageView.alpha = 0;
        [self.videoView addSubview:_ringImageView];
    }
    return _ringImageView;
}
- (CvVideoCamera *)videoCamera {
    if (!_videoCamera) {
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.videoView];
        _videoCamera.delegate = self;
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        _videoCamera.defaultFPS = 30;
    }
    return _videoCamera;
}
//- (UISlider *)slider0 {
//    if (!_slider0) {
//        _slider0 = [[UISlider alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 30 * 3, self.view.frame.size.width - 24, 20)];
//        _slider0.value = 0;
//        [_slider0 addTarget:self action:@selector(didValueChange:) forControlEvents:UIControlEventValueChanged];
//        [self.view addSubview:_slider0];
//    }
//    return _slider0;
//}
//- (UISlider *)slider1 {
//    if (!_slider1) {
//        _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 30 * 2, self.view.frame.size.width - 24, 20)];
//        _slider1.value = 0;
//        [_slider1 addTarget:self action:@selector(didValueChange:) forControlEvents:UIControlEventValueChanged];
//        [self.view addSubview:_slider1];
//    }
//    return _slider1;
//}
//- (UISlider *)slider2 {
//    if (!_slider2) {
//        _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 30 * 1, self.view.frame.size.width - 24, 20)];
//        _slider2.value = 0;
//        [self.view addSubview:_slider2];
//    }
//    return _slider2;
//}
@end
