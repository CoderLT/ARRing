//
//  GestureRecognizer.cpp
//  ARRing
//
//  Created by CoderLT on 2017/4/29.
//  Copyright © 2017年 AT. All rights reserved.
//

#include "GestureRecognizer.hpp"

#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include "myImage.hpp"
#include "handGesture.hpp"
#include <vector>
#include <cmath>

#define RGB(r, g, b) RGBA(r, g, b, 255)
#define RGBA(r, g, b, a) Scalar(b, g, r, a)

#define ColorGreen RGB(0, 255, 0)
#define ColorBlue RGB(0, 0, 255)
#define ColorRed RGB(255, 0, 0)
#define ColorYellow RGB(255,215,0)
#define ColorPurple RGB(128,0,128)
#define ColorPlink RGB(255,192,203)
#define ColorGold RGB(255,215,0)
#define ColorMagenta RGB(255,0,255)

Point2f ringPos1 = Point2f(0, 0), ringPos2 = Point2f(0, 0);
bool showDebugMsg = false;
/*******************************************************************************************
* 函数名称：findBiggestContour
* 功能说明：查找最大的轮廓
* 输入参数：contours->是一个点集的轮廓向量
* 输出参数：返回一堆轮廓向量第几个向量是最大的，如果为负值表示没找到轮廓
********************************************************************************************/
int findBiggestContour(vector<vector<Point> > contours)
{
    int indexOfBiggestContour = -1;
    int sizeOfBiggestContour = 0;
    for (int i = 0; i < contours.size(); i++)
    {
        if(contours[i].size() > sizeOfBiggestContour)	//判断轮廓面积
        {
            sizeOfBiggestContour = (int)contours[i].size();
            indexOfBiggestContour = i;
        }
    }
    return indexOfBiggestContour;
}
/*******************************************************************************************
 * 函数名称：myDrawContours
 * 功能说明：绘制手部轮廓各种线和点
 * 输入参数：m->自定义图像数据结构体，hg->自定义手势识别结构体
 * 输出参数：返回一堆轮廓向量第几个向量是最大的，如果为负值表示没找到轮廓
 ********************************************************************************************/
string intToString(int number)
{
    stringstream ss;
    ss << number;
    string str = ss.str();
    return str;
}

Point minDistance(Point a, vector<Point> contours, Range range = Range::all()) {
    if (contours.size() < 1) {
        return Point(0, 0);
    }
    
    int distanceMin = INT_MAX;
    Point resurt = contours[0];
    if (range.start >= range.end) {
        int tmp = range.start;
        range.start = range.end;
        range.end = tmp;
    }
    if (range.start <= 0) {
        range.start = 0;
    }
    for (int i = range.start; i < range.end && i < contours.size(); i++) {
        Point b = contours[i];
        int distance = ((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
        if (distance < distanceMin) {
            distanceMin = distance;
            resurt = b;
        }
    }
    return resurt;
}
Point crossPoint(Vec4f line, vector<Point> contours, int pos) {
    // b * x + (-a) * y + (-y0*a - x0*b) = 0
    // 设P(x0,y0)，直线方程为：Ax+By+C=0, 则P到直线的距离为:d=|Ax0+By0+C|/√(A²+B²)
    if (contours.size() < 1) {
        return Point(0, 0);
    }
    
    int distanceMin = INT_MAX;
    Point resurt = contours[0];
    int offset = 20, index = 0;
    for (int i = pos - offset; i < pos + offset; i++) {
        index = i;
        if (index < 0) {
            index = (int)contours.size() + index;
        }
        else if (index >= contours.size()) {
            index = index - (int)contours.size();
        }
        if (index < 0 || index >= contours.size()) {
            continue;
        }
        
        Point b = contours[index];
        int distance = abs((b.x-line[2])*line[1] - (b.y-line[3])*line[0]);
        if (distance < distanceMin) {
            distanceMin = distance;
            resurt = b;
        }
    }
    
    return resurt;
}
Point crossPoint2(Vec4f line, vector<Point> contours, Range range) {
    // b * x + (-a) * y + (-y0*a - x0*b) = 0
    // 设P(x0,y0)，直线方程为：Ax+By+C=0, 则P到直线的距离为:d=|Ax0+By0+C|/√(A²+B²)
    if (contours.size() < 1) {
        return Point(0, 0);
    }
    
    int distanceMin = INT_MAX;
    Point resurt = contours[0];
    int index = 0;
    for (int i = range.start; i < range.end; i++) {
        index = i;
        if (index < 0) {
            index = (int)contours.size() + index;
        }
        else if (index >= contours.size()) {
            index = index - (int)contours.size();
        }
        if (index < 0 || index >= contours.size()) {
            continue;
        }
        
        Point b = contours[index];
        int distance = abs((b.x-line[2])*line[1] - (b.y-line[3])*line[0]);
        if (distance < distanceMin) {
            distanceMin = distance;
            resurt = b;
        }
    }
    
    return resurt;
}
Point2f lineCrossPoint(Point a, Point b, Vec4f line) {
    // (b.y - a.y) * x + (a.x - b.x) * y - a.x * (b.y - a.y) + a.y * (b.x - a.x) = 0;
    // line[1] * x + (-line[0]) * y + line[3] * line[0] - line[2] * line[1] = 0
    float a1 = (b.y - a.y), b1 = (a.x - b.x), c1 = a.y * b.x - a.x * b.y;
    float a2 = line[1], b2 = -line[0], c2 = line[3] * line[0] - line[2] * line[1];
    
    //    x = (b1 * c2 - c1 * b2) / (a1 * b2 - a2 * b1)
    //    y = (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1)
    return Point2f((b1 * c2 - c1 * b2) / (a1 * b2 - a2 * b1),
                   (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1));
}

void myDrawContours(MyImage *m,HandGesture *hg)
{
    if (showDebugMsg) {
        drawContours(m->src, hg->contours, hg->cIdx, ColorBlue, 2, 1); // 绘制轮廓线
    }
    
    Mat src = m->src;
    vector<Point> contours = hg->contours[hg->cIdx];
    vector<Vec4i> defects = hg->defects[hg->cIdx];
    
    for (int defectIdx = 0; defectIdx < defects.size(); defectIdx++) {
        Vec4i& v = defects.at(defectIdx);
        Vec4i preV = defects.at(defectIdx >= 1 ? defectIdx - 1 : defects.size() - 1);
        Point ptStart(contours[v[0]]);
        Point ptEnd(contours[v[1]]);
        Point ptFar(contours[v[2]]);
        
        if (showDebugMsg) {
            //        putText(src, intToString(defectIdx), ptStart - Point(0,30), 0, 1.2f, Scalar(200,200,200), 2);
            //        circle(src, ptStart, 2, RGB(255, 255, 0), 2);
            //        circle(src, ptEnd, 2, RGB(255, 255, 0), 2);
            circle(src, ptFar, 2, ColorMagenta, 2);
            //
            //        Point center = (ptFar + contours[preV[2]]) * 0.5;
            //        Point ringCenter = center + (ptStart - center) * 0.1;
            //
            //        line(src, contours[preV[2]], ptFar, RGB(0, 0, 255), 1);
            //        line(src, ptStart, center, RGB(0, 0, 255), 1);
            //        circle(src, ringCenter, 2, RGB(0, 0, 255), 2);
        }
        
        Range range1 = v[0] < v[2] ? Range(v[0], v[2]) : Range(0, v[2]);
        Range range2 = preV[2] < preV[1] ? Range(preV[2], preV[1]) : Range(preV[2], (int)contours.size());
        
        vector<Point> points;
        for (int i = 1; i < range1.end - range1.start && i < range2.end - range2.start; i++) {
            Point a = contours[range1.start + i];
            Point b = contours[range2.end - i];
            points.push_back((a + b) * 0.5);
        }
        
        if (points.size() > 5) {
            Vec4f lineV;
            fitLine(points, lineV, CV_DIST_L2, 0, 0.01, 0.01);
            
            //画一个线段
            Point2f crossP = crossPoint(lineV, contours, v[0]);
            Point2f lineCross = lineCrossPoint(contours[v[2]], contours[preV[2]], lineV);
            if (showDebugMsg) {
                circle(src, crossP, 2, ColorRed, 2);
                circle(src, lineCross, 2, ColorBlue, 2);
                cv::line(src, crossP + (lineCross - crossP) * 2, crossP, ColorGreen, 1);
                putText(src, intToString(defectIdx), crossP - Point2f(0, 8), 0, 0.8f, ColorGreen, 2);
            }
            
            Point2f ringP = lineCross + (crossP - lineCross) * 0.1f;
            Vec4f lineH = Vec4f(-lineV[1], lineV[0], ringP.x, ringP.y);
            Point2f pos1 = crossPoint2(lineH, contours, range1);
            Point2f pos2 = crossPoint2(lineH, contours, range2);
            if (showDebugMsg) {
                cv::line(src, pos1, pos2, ColorGold, 4);
            }
            
            if (defectIdx == 2) {
                ringPos1 = pos1;
                ringPos2 = pos2;
            }
        }
    }
}

/*******************************************************************************************
 * 函数名称：makeContours
 * 功能说明：绘制手部轮廓各种线和点
 * 输入参数：m->自定义图像数据结构体，hg->自定义手势识别结构体
 * 输出参数：无
 ********************************************************************************************/
void makeContours(MyImage *m, HandGesture* hg)
{
    Mat aBw;
    
    pyrUp(m->bw, m->bw);
    m->bw.copyTo(aBw);
    findContours(aBw,hg->contours,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_NONE);//外部轮廓，存储轮廓上所有的点
    hg->initVectors();
    hg->cIdx=findBiggestContour(hg->contours);							 //查找最大的轮廓
    if(hg->cIdx!=-1)
    {
        hg->bRect=boundingRect(Mat(hg->contours[hg->cIdx]));									//计算点集的最外面矩形边界
        convexHull(Mat(hg->contours[hg->cIdx]),hg->hullP[hg->cIdx],false,true);					//逆时针查找凸包
        convexHull(Mat(hg->contours[hg->cIdx]),hg->hullI[hg->cIdx],false,false);
        approxPolyDP( Mat(hg->hullP[hg->cIdx]), hg->hullP[hg->cIdx], 8, true );
        
        vector<int> newHullI;
        for (size_t i = 0; i < hg->hullI[hg->cIdx].size(); i++) {
            for (size_t j = 0; j < hg->hullP[hg->cIdx].size(); j++) {
                Point point = hg->contours[hg->cIdx][hg->hullI[hg->cIdx][i]];
                Point point2 = hg->hullP[hg->cIdx][j];
                if (point.x == point2.x && point.y == point2.y) {
                    newHullI.push_back(hg->hullI[hg->cIdx][i]);
                    break;
                }
            }
        }
        hg->hullI[hg->cIdx] = newHullI;
        if (hg->hullI[hg->cIdx].size()>3 ) {
            convexityDefects(hg->contours[hg->cIdx],hg->hullI[hg->cIdx],hg->defects[hg->cIdx]);	//计算凸包缺陷
            //hg->eleminateDefects(m);															//清除缺陷
        }
//        hg->getFingerNumber(m);
//        bool isHand = hg->detectIfHand();														//检测是否有手
//        hg->printGestureInfo(m->src);															//在原图中显示识别出来的信息
//        if(isHand) {
//            hg->getFingerTips(m);																//获取指尖
//            hg->drawFingerTips(m);																//绘制指尖
//        }
        myDrawContours(m, hg);
    }
}

void SkinRGB(MyImage *m)
{
    m->bw = Mat(m->srcLR.rows, m->srcLR.cols, CV_8UC1);
    
    int height = m->srcLR.rows, width = m->srcLR.cols, channel = m->srcLR.channels(), step = (int)m->srcLR.step;
    unsigned char* p_src = (unsigned char*)m->srcLR.data;
    unsigned char* p_dst = (unsigned char*)m->bw.data;
    
    for (int j = 0; j < height; j++){
        for (int i = 0; i < width; i++){
            int offset = j * step + i * channel;
            int b = p_src[offset + 0], g = p_src[offset + 1], r = p_src[offset + 2];
            //均匀照明：R > 95 && G > 40 && B > 20 && R - B > 15 && R - G > 15 && R > B
            //侧向照明: R > 200 && G > 210 && B > 170 && R - B <= 15 && R > B && G > B
            if ((r > 95 && g > 40 && b > 20 && (r - b) > 15 && (r - g) > 15)
                || (r > 200 && g > 210 && b > 170 && ((r > g && r - g <= 15) || (g > r && g - r <= 15)) && r > b && g > b)) {
                p_dst[j * width + i] = 255;
            }
            else {
                p_dst[j * width + i] = 0;
            }
        }
    }
    
//    cvtColor(m->srcLR, m->srcLR, CV_BGR2HLS);
//    for (int j = 0; j < height; j++){
//        for (int i = 0; i < width; i++){
//            int offset = j*step + i*channel;
//            int h = p_src[offset + 0];
//            if (h >= 7 && h <= 29) {
//                p_dst[j*width + i] = 255;
//            }
//        }
//    }
//    cvtColor(m->srcLR, m->srcLR, CV_HLS2BGR);
    
    
    // 构建椭圆模型
    cv::Mat skinMat = cv::Mat::zeros(cv::Size(256, 256), CV_8UC1);
    ellipse(skinMat, cv::Point(113, 155.6), cv::Size(23.4, 15.2),
            43.0, 0.0, 360.0, cv::Scalar(255, 255, 255), -1);
    cv::Mat YcrcbMat;
    // 颜色空间转换YCrCb
    cvtColor(m->srcLR, YcrcbMat, CV_BGR2YCrCb);
    // 椭圆皮肤模型检测
    for (int j = 0; j < height; j++){
        cv::Vec3b* ycrcb = (cv::Vec3b*)YcrcbMat.ptr<cv::Vec3b>(j);
        for (int i = 0; i < width; i++){
            // 颜色判断
            if (skinMat.at<uchar>(ycrcb[i][1], ycrcb[i][2]) > 0){
                p_dst[j*width + i] = 255;
            }
        }
    }
    
    medianBlur(m->bw, m->bw, 9);
}

void gestureRecognizer(cv::Mat& image, bool debug) {
    MyImage m;
    HandGesture hg;
    m.src = image;
    
    showDebugMsg = debug;
    
    pyrDown(m.src, m.srcLR);
    cvtColor(m.srcLR, m.srcLR, CV_BGRA2BGR);
    SkinRGB(&m);
    makeContours(&m, &hg);
    
    pyrDown(m.bw,m.bw);
    pyrDown(m.bw,m.bw);
    cvtColor(m.bw, m.src(Rect({m.src.cols - m.bw.cols, 0}, m.bw.size())), CV_GRAY2RGBA);
}
