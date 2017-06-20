#ifndef _MYIMAGE_
#define _MYIMAGE_ 

#include <opencv2/imgproc/imgproc.hpp>
#include<opencv2/opencv.hpp>
#include <vector>

using namespace cv;
using namespace std;

class MyImage{
public:
    MyImage();
    Mat srcLR;
    Mat srcLRB_BGR;
    Mat src;
    Mat bw;
    Mat bw2;
    Mat histImage;
};

#endif
