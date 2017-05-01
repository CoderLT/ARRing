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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat h = self.view.frame.size.width * 640 / 480;
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              (self.view.frame.size.height - h) / 2,
                                                              self.view.frame.size.width,
                                                              h)];
    [self.view addSubview:self.videoView];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.videoView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoCamera start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
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
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        self.showDebug = !self.showDebug;
    }
    return;  
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
    TS(DetectAndAnimateFaces);
    gestureRecognizer(image, self.showDebug);
    cv::Point2f center = (ringPos1 + ringPos2) * (0.5 * self.videoView.frame.size.width / image.cols);
    float width = sqrtf((ringPos2.x - ringPos1.x) * (ringPos2.x - ringPos1.x) + (ringPos2.y - ringPos1.y) * (ringPos2.y - ringPos1.y)) * (self.videoView.frame.size.width / image.cols);
    float angle = atanf((ringPos2.y - ringPos1.y)/(ringPos2.x - ringPos1.x));
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ringImageView.transform = CGAffineTransformIdentity;
        self.ringImageView.frame = CGRectMake(0, 0, width, self.ringImageView.image.size.height * width / self.ringImageView.image.size.width);
        self.ringImageView.center = CGPointMake(center.x, center.y);
        self.ringImageView.transform = CGAffineTransformMakeRotation(angle);
    });
    TE(DetectAndAnimateFaces);
}

- (void)dealloc
{
    [self.videoCamera stop];
    self.videoCamera.delegate = nil;
}

#pragma mark - getter
- (UIImageView *)ringImageView {
    if (!_ringImageView) {
        _ringImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring"]];
        [self.videoView addSubview:_ringImageView];
    }
    return _ringImageView;
}
@end
