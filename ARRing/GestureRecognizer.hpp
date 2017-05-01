//
//  GestureRecognizer.hpp
//  ARRing
//
//  Created by CoderLT on 2017/4/29.
//  Copyright © 2017年 AT. All rights reserved.
//

#ifndef GestureRecognizer_hpp
#define GestureRecognizer_hpp

#include <stdio.h>
#include <opencv2/opencv.hpp>

extern cv::Point2f ringPos1, ringPos2;
void gestureRecognizer(cv::Mat& image, bool debug);

#endif /* GestureRecognizer_hpp */
