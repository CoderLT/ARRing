//
//  GestureRecognizer.hpp
//  ARRing
//
//  Created by CoderLT on 2017/4/29.
//  Copyright © 2017年 AT. All rights reserved.
//

#ifndef GestureRecognizer_hpp
#define GestureRecognizer_hpp

#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <vector>
#include <string>

using namespace cv;
using namespace std;

class ATHand;
class ATFinger {
public:
    float confidence; // 0 - 1.0
    int index; // 0: 大拇指, ..., 4: 小拇指
    cv::Point top;
    cv::Point bottom;
    cv::Size size;
    cv::Vec4f ringLine;
    cv::Point lastDefect;
    cv::Point nextDefect;
};

class ATHand {
public:
    float confidence; // 0 - 1.0
    bool isLeft;
    bool isBack;
    cv::Vector<ATFinger> figers;
};

extern ATHand hand;
void gestureRecognizer(cv::Mat& image, cv::Vec6i params);

#endif /* GestureRecognizer_hpp */
