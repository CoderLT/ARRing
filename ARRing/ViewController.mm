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
#import "ATLine.h"
#import "ATHightlightButton.h"

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
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *ringImageView;
@property (nonatomic, assign) BOOL showDebug;
@property (nonatomic, strong) UISlider *slider0;
@property (nonatomic, strong) UISlider *slider1;
@property (nonatomic, strong) UISlider *slider2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *debugItem;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, assign) CGPoint tapPoint;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, strong) UIImageView *mask;
@property (nonatomic, strong) ATLine *angelLine;
@property (nonatomic, strong) ATLine *widthLine;
@property (nonatomic, strong) ATLine *centerXLine;
@property (nonatomic, strong) ATLine *centerYLine;


@property (weak, nonatomic) IBOutlet ATHightlightButton *flashItem;
@property (weak, nonatomic) IBOutlet ATHightlightButton *startItem;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"DIAMOND";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.videoSize = CGSizeMake(480, 640);
    CGFloat h = self.view.frame.size.width * self.videoSize.height / self.videoSize.width;
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              64 + 20,
                                                              self.view.frame.size.width,
                                                              h)];
    [self.view addSubview:self.videoView];
    
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bottomView.superview);
        make.top.equalTo(self.videoView.mas_bottom);
    }];
    [self startItem];
    [self flashItem];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
    
    self.showDebug = YES;
    self.angelLine = [ATLine new];
    self.widthLine = [ATLine new];
    self.centerYLine = [ATLine new];
    self.centerXLine = [ATLine new];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoCamera start];
    self.videoCamera.delegate = self;
    [self.videoView bringSubviewToFront:self.mask];
    [self.videoView bringSubviewToFront:self.ringImageView];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    AVCaptureDevice *device = self.device;
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
//        [device setTorchMode:AVCaptureTorchModeOn];
//        [device setFlashMode:AVCaptureFlashModeOn];
        
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
- (void)didTap:(UITapGestureRecognizer *)tap {
    CGPoint p = [tap locationInView:self.videoView];
    if (CGRectContainsPoint(self.videoView.bounds, p)) {
        p.x = p.x * self.videoSize.width / self.videoView.width;
        p.y = p.y * self.videoSize.height / self.videoView.height;
        self.tapPoint = p;
    }
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
//        self.flashItem.title = (device.isFlashActive ? @"关闭闪光灯" : @"打开闪光灯");
    }
}
- (void)setShowDebug:(BOOL)showDebug {
    _showDebug = showDebug;
    
//    self.debugItem.title = (_showDebug ? @"关闭调试信息" : @"显示调试信息");
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
    params[1] = self.tapPoint.x;
    params[2] = self.tapPoint.y;
    self.tapPoint = CGPointZero;
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
            float width = finger.size.width * scale * 1.1;
            float angle = atan2f(finger.ringLine[1], finger.ringLine[0]);
            [self.angelLine push:angle];
            [self.widthLine push:width];
            [self.centerXLine push:center.x];
            [self.centerYLine push:center.y];
//            printf("%f \n", angle * 180 / M_PI);
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                CGFloat width = self.widthLine.value;
                strongSelf.ringImageView.transform = CGAffineTransformIdentity;
                strongSelf.ringImageView.frame = CGRectMake(0, 0, width, self.ringImageView.image.size.height * width / self.ringImageView.image.size.width);
                strongSelf.ringImageView.center = CGPointMake(self.centerXLine.value, self.centerYLine.value);
                strongSelf.ringImageView.transform = CGAffineTransformMakeRotation(self.angelLine.value - M_PI_2);
            });
            findFinger = YES;
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGFloat alpha = strongSelf.ringImageView.alpha;
        if (findFinger) {
            alpha += 1/20.0f;
        }
        else {
            alpha -= 1/20.0f;
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
- (IBAction)didClickStart:(UIButton *)sender {
    if (hand.detectState == ATDetectStateDectect) {
        hand.detectState = ATDetectStateBackground;
        sender.selected = NO;
        self.mask.hidden = NO;
        hand.referencePoint.clear();
        hand.referenceHue.clear();
    }
    else {
        hand.detectState = ATDetectStateRefrence;
        sender.selected = YES;
        self.mask.hidden = YES;
    }
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
- (UIImageView *)mask {
    if (!_mask) {
        _mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask22"]];
        [self.videoView addSubview:_mask];
        [_mask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_mask.superview);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"请先寻找一面白色的背景墙, 然后点击开始";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        [_mask addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.superview).offset(0);
            make.centerX.equalTo(label.superview);
        }];
    }
    return _mask;
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

- (ATHightlightButton *)flashItem {
    if (!_flashItem) {
        _flashItem = [ATHightlightButton buttonWithImage:[UIImage imageNamed:@"闪光灯"] target:self action:@selector(didClickFlash:)];
        [self.bottomView addSubview:_flashItem];
        [_flashItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(_flashItem.superview);
            make.width.height.equalTo(@(60));
        }];
    }
    return _flashItem;
}

- (ATHightlightButton *)startItem {
    if (!_startItem) {
        _startItem = [ATHightlightButton buttonWithImage:[UIImage imageNamed:@"开始"] target:self action:@selector(didClickStart:)];
        [_startItem setImage:[UIImage imageNamed:@"清除"] forState:UIControlStateSelected];
        [self.bottomView addSubview:_startItem];
        [_startItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_startItem.superview);
        }];
    }
    return _flashItem;
}
@end
