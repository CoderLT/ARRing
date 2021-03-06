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

#define ColorWhite RGB(255,255,255)
#define ColorBlack RGB(0,0,0)
#define ColorGreen RGB(0, 255, 0)
#define ColorBlue RGB(0, 0, 255)
#define ColorRed RGB(255, 0, 0)
#define ColorYellow RGB(255,215,0)
#define ColorPurple RGB(128,0,128)
#define ColorPlink RGB(255,192,203)
#define ColorGold RGB(255,215,0)
#define ColorMagenta RGB(255,0,255)

#define setDefectError(d) d[3] = -1
#define isDefectError(d) (d[3] < 0)

ATHand hand;
bool showDebugMsg = false;
Vec6i params = {0,0,0,0,0,0};
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
    for (int i = 0; i < contours.size(); i++) {
        if(contours[i].size() > sizeOfBiggestContour) { //判断轮廓面积
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
// 计算两点的距离
float distanceP2P(Point2f a, Point2f b)
{
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}
/*******************************************************************************************
 * 函数名称：getAngle
 * 功能说明：获取角度，三个点，一个为顶点，计算这个顶点的角度，用的是角度制
 * 输入参数：s，f，e代表描述凸包缺陷的单个坐标，s->起始坐标，f->角点坐标，e->结束坐标
 * 输出参数：float 类型的角度
 ********************************************************************************************/
float getAngle(Point s, Point f, Point e)
{
    float dot = (s.x - f.x) * (e.x - f.x) + (s.y - f.y) * (e.y - f.y);
    return acos(dot / (distanceP2P(f, s) * distanceP2P(f, e))) * 180 / M_PI;
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
    int offset = 150, index = 0;
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
    float ab2 = sqrt(line[1] * line[1] + line[0] * line[0]);
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
        if (distance < distanceMin || distance < ab2) {
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
Point2f pointToLine(Point p, Vec4f line) {
    // x2 = y1, y2 = -x1
    // line[1] * x + (-line[0]) * y + line[3] * line[0] - line[2] * line[1] = 0
    float a1 = -line[0], b1 = -line[1], c1 = p.x * line[0] + p.y * line[1];
    float a2 = line[1], b2 = -line[0], c2 = line[3] * line[0] - line[2] * line[1];
    
    //    x = (b1 * c2 - c1 * b2) / (a1 * b2 - a2 * b1)
    //    y = (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1)
    return Point2f((b1 * c2 - c1 * b2) / (a1 * b2 - a2 * b1),
                   (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1));
}

void myDrawContours(MyImage *m,HandGesture *hg)
{
    Mat src = m->src;
    vector<Point> contours = hg->contours[hg->cIdx];
    vector<Vec4i>& defects = hg->defects[hg->cIdx];
    
    if (showDebugMsg) {
        drawContours(m->src, hg->contours, hg->cIdx, ColorBlue, 2, 1); // 绘制轮廓线
    }
    
    if ((hg->bRect.size().width + 10 >= src.cols && hg->bRect.size().height * 1.1 >= src.rows)
        || (hg->bRect.size().width * 1.1 >= src.cols && hg->bRect.size().height + 10 >= src.rows)) {
        vector<int> hullIs = hg->hullI[hg->cIdx];
        float minD = MAXFLOAT;
        int index = -1;
        for (int i = 0; i < hullIs.size(); i++) {
            Point p = contours[hullIs[i]];
            float d = src.cols - p.x + p.y;
            circle(src, p, 4, ColorGold, 2);
            if (d < minD) {
                minD = d;
                index = hullIs[i];
            }
        }
        if (index >= 0) {
            for (int defectIdx = 0; defectIdx < defects.size(); defectIdx++) {
                Vec4i& v = defects.at(defectIdx);
                Point ptStart(contours[v[0]]);
                Point ptEnd(contours[v[1]]);
                Point ptFar(contours[v[2]]);
                if (v[0] != index) {
                    if (showDebugMsg) {
                        circle(m->src, ptFar, 3, ColorBlack, 2);
                    }
                    continue;
                }
                if (showDebugMsg) {
                    circle(src, ptFar, 2, ColorMagenta, 2);
                }
                
                Vec4i preV = defects.at(defectIdx >= 1 ? defectIdx - 1 : defects.size() - 1);
                
                Range range1 = v[0] < v[2] ? Range(v[0], v[2]) : Range(0, v[2]);
                Range range2 = preV[2] < preV[1] ? Range(preV[2], preV[1]) : Range(preV[2], (int)contours.size());
                
                vector<Point> points;
                for (int i = 1;
                     ((i < range1.end - range1.start))
                     && (i < range2.end - range2.start);
                     i++) {
                    Point a = contours[(range1.start + i)%contours.size()];
                    Point b = contours[(range2.end - i)%contours.size()];
                    if (a.x + 2 >= src.cols || b.x + 2 >= src.cols
                        || a.y <= 2 || b.y <= 2) {
                        continue;
                    }
                    points.push_back((a + b) * 0.5);
                }
                
                if (showDebugMsg) {
                    for (int i = 0; i < points.size(); i++) {
                        circle(src, points[i], 2, ColorRed, 2);
                    }
                }
                
                if (points.size() > 5) {
                    Vec4f lineV;
                    fitLine(points, lineV, CV_DIST_L2, 0, 0.01, 0.01);
                    
                    //画一个线段
                    Point2f crossP = crossPoint(lineV, contours, v[0]);
                    lineV[2] = crossP.x;
                    lineV[3] = crossP.y;
                    
                    //            Point2f lineCross = lineCrossPoint(contours[v[2]], contours[preV[2]], lineV);
                    Point2f point2Line1 = pointToLine(contours[preV[2]], lineV);
                    Point2f point2Line2 = pointToLine(contours[v[2]], lineV);
                    float d1 = distanceP2P(point2Line1, crossP);
                    float d2 = distanceP2P(point2Line2, crossP);
                    float d = d2 > d1 ? d1 : d2;
                    
                    float angle = atan2(lineV[1], lineV[0]);
                    Point2f offset = Point2f(d * cos(angle), d * sin(angle));
                    if (fabs(offset.x) > fabs(offset.y)) {
                        if ((point2Line1.x - crossP.x) * offset.x < 0) {
                            offset = -offset;
                        }
                    }
                    else {
                        if ((point2Line1.y - crossP.y) * offset.y < 0) {
                            offset = -offset;
                        }
                    }
                    if (offset.x > 0 && offset.y < 0) {
                        continue;
                    }
                    
                    Point2f lineCross = crossP + offset;
                    Point2f ringP = lineCross + (crossP - lineCross) * 0.1f;
                    Vec4f lineH = Vec4f(lineCross.x - ringP.x, lineCross.y - ringP.y, ringP.x, ringP.y);
                    Vec4f lineH2 = Vec4f(-lineCross.y + ringP.y, lineCross.x - ringP.x, ringP.x, ringP.y);
                    
                    Point2f pos1 = crossPoint2(lineH2, contours, range1);
                    Point2f pos2 = crossPoint2(lineH2, contours, range2);
                    
                    if (distanceP2P(pos2, ringP) >= distanceP2P(pos1, ringP) * 1.5) {
                        circle(src, pos2, 8, ColorGold, 8);
                        Point2f pos3 = crossPoint2(lineH2, contours, range2);
                    }
                    
                    ATFinger finger;
                    finger.index = 2;
                    finger.top = crossP;
                    finger.bottom = lineCross;
                    finger.ringLine = lineH;
                    finger.size = Size(distanceP2P(pos1, pos2), d);
                    finger.lastDefect = point2Line2;
                    finger.nextDefect = point2Line1;
                    hand.figers.push_back(finger);
                    
                    if (showDebugMsg) {
                        circle(src, crossP, 2, ColorRed, 2);
                        //                circle(src, point2Line, 2, ColorBlue, 2);
                        circle(src, lineCross, 2, ColorBlue, 2);
                        cv::line(src, pos1, pos2, ColorGold, 1);
                        //                cv::line(src, contours[preV[2]], point2Line2, ColorGreen, 1);
                        if (finger.index == 2) {
                            cv::line(src, crossP + (lineCross - crossP) * 2, crossP, ColorGreen, 1);
                        }
                        putText(src, intToString(finger.index), crossP - Point2f(0, 8), 0, 0.8f, ColorGreen, 2);
                        //                putText(src, intToString(((int)distanceP2P(point2Line, crossP))), point2Line - Point2f(0, 8), 0, 0.4f, ColorGreen, 2);
                        putText(src, intToString(((int)distanceP2P(lineCross, crossP))), lineCross - Point2f(0, 8), 0, 0.4f, ColorGreen, 2);
                        //                putText(src, intToString(v[3]), ptFar - Point(0, 8), 0, 0.4f, ColorGreen, 2);
                    }
                    return;
                }
            }
        }
    }
    
    
    for (int defectIdx = 0; defectIdx < defects.size(); defectIdx++) {
        Vec4i& v = defects.at(defectIdx);
        Point ptStart(contours[v[0]]);
        Point ptEnd(contours[v[1]]);
        Point ptFar(contours[v[2]]);
        float angle = getAngle(ptStart, ptFar, ptEnd);
        
        if (angle > 50) {
            setDefectError(v);
        }
        else {
            v[3] = angle;
        }
    }
    
    if (defects.size() > 1) {
        while (!isDefectError(defects.back())) {
            defects.insert(defects.begin(), defects.back());
            defects.pop_back();
        }
    }
    
    float d0 = 0;
    int fingerIndex = 0;
    for (int defectIdx = 0; defectIdx < defects.size(); defectIdx++) {
        Vec4i& v = defects.at(defectIdx);
        Vec4i preV = defects.at(defectIdx >= 1 ? defectIdx - 1 : defects.size() - 1);
        Point ptStart(contours[v[0]]);
        Point ptEnd(contours[v[1]]);
        Point ptFar(contours[v[2]]);
        
        if (showDebugMsg) {
            if (isDefectError(v)) {
                circle(m->src, ptFar, 3, ColorBlack, 2);
            }
            else {
                circle(src, ptFar, 2, ColorMagenta, 2);
            }
        }
        
        if (isDefectError(v) && isDefectError(preV)) {
            continue;
        }
        
        Range range1 = v[0] < v[2] ? Range(v[0], v[2]) : Range(0, v[2]);
        Range range2 = preV[2] < preV[1] ? Range(preV[2], preV[1]) : Range(preV[2], (int)contours.size());
        
        vector<Point> points;
        for (int i = 1;
             (isDefectError(v) || (i < range1.end - range1.start))
             && (isDefectError(preV) || i < range2.end - range2.start);
             i++) {
            Point a = contours[(range1.start + i)%contours.size()];
            Point b = contours[(range2.end - i)%contours.size()];
            points.push_back((a + b) * 0.5);
        }
        
        if (points.size() > 5) {
            Vec4f lineV;
            fitLine(points, lineV, CV_DIST_L2, 0, 0.01, 0.01);
            
            //画一个线段
            Point2f crossP = crossPoint(lineV, contours, v[0]);
            lineV[2] = crossP.x;
            lineV[3] = crossP.y;
            
            //            Point2f lineCross = lineCrossPoint(contours[v[2]], contours[preV[2]], lineV);
            Point2f point2Line1 = pointToLine(contours[preV[2]], lineV);
            Point2f point2Line2 = pointToLine(contours[v[2]], lineV);
            float d1 = distanceP2P(point2Line1, crossP);
            float d2 = distanceP2P(point2Line2, crossP);
            
            if (fingerIndex >= 1 || v[3] < 45) {
                fingerIndex++;
            }
            
            if (fingerIndex == 1) {
                d1 = d1 * 0.667;
            }
            else if (fingerIndex == 2) {
                d1 = d0 * 220 / 200 > d1 ? d0 * 220 / 200 : d1;
            }
            else if (fingerIndex == 3) {
                d1 = d0 > d1 ? d0 : d1;
            }
            else if (fingerIndex == 4) {
                d1 = d0 * 180 / 200 > d1 ? d0 * 180 / 200 : d1;
            }
            float d = d2 > d1 ? d2 : d1;
            if (fingerIndex == 1) {
                d0 = d;
            }
            
            float angle = atan2(lineV[1], lineV[0]);
            Point2f offset = Point2f(d * cos(angle), d * sin(angle));
            if (fabs(offset.x) > fabs(offset.y)) {
                if ((point2Line1.x - crossP.x) * offset.x < 0) {
                    offset = -offset;
                }
            }
            else {
                if ((point2Line1.y - crossP.y) * offset.y < 0) {
                    offset = -offset;
                }
            }
            
            if (offset.x > 0 && offset.y < 0) {
                continue;
            }
//            if (fingerIndex == 2) {
//                printf("%.1f, %.1f, %.1f \n", angle * 180 / M_PI, offset.x, offset.y);
//            }
            
            Point2f lineCross = crossP + offset;
            Point2f ringP = lineCross + (crossP - lineCross) * 0.1f;
            Vec4f lineH = Vec4f(lineCross.x - ringP.x, lineCross.y - ringP.y, ringP.x, ringP.y);
            
            ATFinger finger;
            finger.index = fingerIndex;
            finger.top = crossP;
            finger.bottom = lineCross;
            finger.ringLine = lineH;
            finger.size = Size(d * 55 / 220, d);
            finger.lastDefect = point2Line2;
            finger.nextDefect = point2Line1;
            hand.figers.push_back(finger);
            
            
            if (showDebugMsg) {
                circle(src, crossP, 2, ColorRed, 2);
//                circle(src, point2Line, 2, ColorBlue, 2);
                circle(src, lineCross, 2, ColorBlue, 2);
//                cv::line(src, contours[v[2]], point2Line, ColorGreen, 1);
//                cv::line(src, contours[preV[2]], point2Line2, ColorGreen, 1);
                if (fingerIndex == 2) {
                    cv::line(src, crossP + (lineCross - crossP) * 2, crossP, ColorGreen, 1);
                }
                putText(src, intToString(fingerIndex), crossP - Point2f(0, 8), 0, 0.8f, ColorGreen, 2);
//                putText(src, intToString(((int)distanceP2P(point2Line, crossP))), point2Line - Point2f(0, 8), 0, 0.4f, ColorGreen, 2);
                putText(src, intToString(((int)distanceP2P(lineCross, crossP))), lineCross - Point2f(0, 8), 0, 0.4f, ColorGreen, 2);
//                putText(src, intToString(v[3]), ptFar - Point(0, 8), 0, 0.4f, ColorGreen, 2);
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
    if(hg->cIdx!=-1) {
        hg->bRect=boundingRect(Mat(hg->contours[hg->cIdx]));									//计算点集的最外面矩形边界
        convexHull(Mat(hg->contours[hg->cIdx]),hg->hullP[hg->cIdx],false,true);					//逆时针查找凸包
        convexHull(Mat(hg->contours[hg->cIdx]),hg->hullI[hg->cIdx],false,false);
        
//        for (int i = 0; i < hg->hullP[hg->cIdx].size(); i++) {
//            circle(m->src, hg->hullP[hg->cIdx].at(i), 3, ColorPlink, 2);
//        }
        
        approxPolyDP( Mat(hg->hullP[hg->cIdx]), hg->hullP[hg->cIdx], 15, true );

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
        if (hg->hullI[hg->cIdx].size() >= 3 ) {
            convexityDefects(hg->contours[hg->cIdx],hg->hullI[hg->cIdx],hg->defects[hg->cIdx]);	//计算凸包缺陷
        }
        
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
    
    cvtColor(m->srcLR, m->srcLR, CV_BGR2HLS);
    for (int j = 0; j < height; j++){
        for (int i = 0; i < width; i++){
            int offset = j*step + i*channel;
            int h = p_src[offset + 0];
            if (h <= 29) {
                p_dst[j*width + i] = 255;
            }
        }
    }
    cvtColor(m->srcLR, m->srcLR, CV_HLS2BGR);
    
    
    // 构建椭圆模型
//    cv::Mat skinMat = cv::Mat::zeros(cv::Size(256, 256), CV_8UC1);
//    ellipse(skinMat, cv::Point(113, 155.6), cv::Size(23.4, 15.2),
//            43.0, 0.0, 360.0, cv::Scalar(255, 255, 255), -1);
//    cv::Mat YcrcbMat;
//    // 颜色空间转换YCrCb
//    cvtColor(m->srcLR, YcrcbMat, CV_BGR2YCrCb);
//    // 椭圆皮肤模型检测
//    for (int j = 0; j < height; j++){
//        cv::Vec3b* ycrcb = (cv::Vec3b*)YcrcbMat.ptr<cv::Vec3b>(j);
//        for (int i = 0; i < width; i++){
//            // 颜色判断
//            if (skinMat.at<uchar>(ycrcb[i][1], ycrcb[i][2]) > 0){
//                p_dst[j*width + i] = 255;
//            }
//        }
//    }
    
    
    medianBlur(m->bw, m->bw, 9);
    
    // 形态学操作，去除噪声，并使手的边界更加清晰
    Mat element = getStructuringElement(MORPH_RECT, Size(3,3));
    erode(m->bw, m->bw, element);
    morphologyEx(m->bw, m->bw, MORPH_OPEN, element);
    dilate(m->bw, m->bw, element);
    morphologyEx(m->bw, m->bw, MORPH_CLOSE, element);
}
void RGB2HLS( double *h, double *l, double *s, uint8_t r, uint8_t g, uint8_t b)
{
    double dr = (double)r/255;
    double dg = (double)g/255;
    double db = (double)b/255;
    double cmax = MAX(dr, MAX(dg, db));
    double cmin = MIN(dr, MIN(dg, db));
    double cdes = cmax - cmin;
    double hh, ll, ss;
    
    ll = (cmax+cmin)/2;
    if(cdes){
        if(ll <= 0.5)
            ss = (cmax-cmin)/(cmax+cmin);
        else
            ss = (cmax-cmin)/(2-cmax-cmin);
        
        if(cmax == dr)
            hh = (0+(dg-db)/cdes)*60;
        else if(cmax == dg)
            hh = (2+(db-dr)/cdes)*60;
        else// if(cmax == b)
            hh = (4+(dr-dg)/cdes)*60;
        if(hh<0)
            hh+=360;
    }else
        hh = ss = 0;
    
    *h = hh;
    *l = ll;
    *s = ss;
}
void SkinRGB2(MyImage *m)
{
    m->bw = Mat(m->srcLR.rows, m->srcLR.cols, CV_8UC1);
    
    int height = m->srcLR.rows, width = m->srcLR.cols, channel = m->srcLR.channels(), step = (int)m->srcLR.step;
    unsigned char* p_src = (unsigned char*)m->srcLR.data;
    unsigned char* p_src_bgr = (unsigned char*)m->srcLRB_BGR.data;
    unsigned char* p_dst = (unsigned char*)m->bw.data;
    
    int diff = 10;
    for (int j = 0; j < height; j++){
        for (int i = 0; i < width; i++){
            int offset = j * step + i * channel;
            p_dst[j * width + i] = 0;
            
            // 太灰的认为是墙, s值再过滤一下，只留下10>s>60的
            int h = p_src[offset + 0];
//            int l = p_src[offset + 1];
//            int s = p_src[offset + 2];
//            if (s > 60 * 2.55f || s < 10 * 2.55f) {
////                continue;
//            }
            
            // 太灰的认为是墙, rgb三个值相差不超过15的，认为是灰色，就去掉
            int b = p_src_bgr[offset + 0];
            int g = p_src_bgr[offset + 1];
            int r = p_src_bgr[offset + 2];
            if (fabs(b - g) < 15 && fabs(g - r) < 15 && fabs(r - b) < 15) {
                continue;
            }
            //饱和度=（最大值－最小值）/最大值
            int maxRGB = MAX(r, MAX(g, b));
            int minRGB = MIN(r, MIN(g, b));
            int s = (maxRGB - minRGB) * 100 / maxRGB;
            if (s > 60 || s < 10) {
                continue;
            }
            
//            double hh, ll, ss;
//            RGB2HLS(&hh, &ll, &ss, r, g, b);
//            
//            printf("0x%02X%02X%02X, %d %d %d, %.0f %.0f %.0f\n", r, g, b, h * 360 / 0xff, l * 100 / 0xff, s * 100 / 0xff, hh, ll * 100, ss * 100);
            
            // 手
            for (int n = 0; n < hand.referenceHue.size(); n++) {
                int H = hand.referenceHue[n];
                
                if (h < H + diff && ((h + diff) & 0xFF) > H) {
                    p_dst[j * width + i] = 255;
                    break;
                }
            }
        }
    }
    
    
    medianBlur(m->bw, m->bw, 9);
    
    // 形态学操作，去除噪声，并使手的边界更加清晰
    Mat element = getStructuringElement(MORPH_RECT, Size(3,3));
    erode(m->bw, m->bw, element);
    morphologyEx(m->bw, m->bw, MORPH_OPEN, element);
    dilate(m->bw, m->bw, element);
    morphologyEx(m->bw, m->bw, MORPH_CLOSE, element);
}


void showRGB(MyImage *m) {
    /// 分割成3个单通道图像 ( R, G 和 B )
    vector<Mat> rgb_planes;
    cvtColor(m->srcLR, m->histImage, CV_BGR2HLS_FULL);
    split( m->histImage, rgb_planes );
    /// 设定bin数目
    int histSize = 32;
    int channels[]={0,1};
    
    /// 设定取值范围 ( R,G,B) )
    float range[] = { 0, 255 } ;
    const float* histRange = { range };
    
    bool uniform = true; bool accumulate = false;
    
    Mat r_hist, g_hist, b_hist;
    
    /// 计算直方图:
    calcHist( &rgb_planes[0], 1, 0, Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &rgb_planes[1], 1, 0, Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &rgb_planes[2], 1, 0, Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate );
    
    // 创建直方图画布
    int hist_w = 300; int hist_h = 300;
    int bin_w = cvRound( (double) hist_w/histSize );
    
    Mat histImage;
    Mat histNormal;
    calcHist(&m->histImage,2,channels,Mat(),histImage,1,&histSize,&histRange,true,false);
    normalize(histImage,histNormal,0,255,NORM_MINMAX,-1,Mat());
    calcBackProject(&m->histImage,2,channels,histNormal,histImage,&histRange,1,true);
    
    // 将直方图归一化到范围 [ 0, histImage.rows ]
    normalize(r_hist, r_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
    
    cvtColor(histImage, histImage, CV_GRAY2RGB);
    
    // 在直方图画布上画出直方图
    Point p0 = Point(0, histImage.rows);
    for( int i = 0; i < histSize; i++ ) {
        int n = cvRound(r_hist.at<float>(i));
        Point p = Point( bin_w*(i), hist_h - n);
//        circle(histImage, p, 2, ColorRed, 2);
        line(histImage, p0, p, ColorRed, 1);
        if (n > histImage.rows * 0.05) {
            putText(histImage, intToString(i)+"."+intToString(n), p + Point(0, 8), 0, 0.3f, ColorGreen, 1);
        }
        p0 = p;
    }
    
    m->histImage = histImage;
}

void setupBackground(Mat src) {
    pyrDown(src, src);
    pyrDown(src, src);
    
}

void gestureRecognizer(cv::Mat& image, cv::Vec6i params) {
    showDebugMsg = params[0];
    if (hand.referencePoint.size() == 0) {
        hand.referencePoint.push_back(Point2i(104, 366));
        hand.referencePoint.push_back(Point2i(171, 322));
        hand.referencePoint.push_back(Point2i(239, 328));
        hand.referencePoint.push_back(Point2i(288, 352));
        hand.referencePoint.push_back(Point2i(152, 408));
        hand.referencePoint.push_back(Point2i(229, 450));
        hand.referencePoint.push_back(Point2i(260, 243));
        hand.referencePoint.push_back(Point2i(182, 253));
        hand.referencePoint.push_back(Point2i(316, 299));
//        hand.referencePoint.push_back(Point2i(230, 302));
//        hand.referencePoint.push_back(Point2i(371, 168));
//        hand.referencePoint.push_back(Point2i(328, 250));
//        hand.referencePoint.push_back(Point2i(285, 321));
//        hand.referencePoint.push_back(Point2i(261, 406));
//        hand.referencePoint.push_back(Point2i(415, 402));
//        hand.referencePoint.push_back(Point2i(349, 445));
//        hand.referencePoint.push_back(Point2i(252, 456));
    }
    
    if (hand.detectState == ATDetectStateBackground) {
        if (showDebugMsg) {
            for (int i = 0; i < hand.referencePoint.size(); i++) {
                circle(image, hand.referencePoint[i], 2, ColorRed, 2);
            }
        }
        return;
    }
    
    MyImage m;
    HandGesture hg;
    m.src = image;
    pyrDown(m.src, m.srcLR);
    cvtColor(m.srcLR, m.srcLRB_BGR, CV_BGRA2BGR);
    cvtColor(m.srcLRB_BGR, m.srcLR, CV_BGR2HLS_FULL);
    
    if (hand.detectState == ATDetectStateRefrence) {
        for (int i = 0; i < hand.referencePoint.size(); i++) {
            Point2i point = hand.referencePoint[i];
            int channel = m.srcLR.channels(), step = (int)m.srcLR.step;
            int offset = point.y/2 * step + point.x/2 * channel;
            hand.referenceHue.push_back(m.srcLR.data[offset + 0]);
        }
        hand.detectState = ATDetectStateDectect;
    }
    
    SkinRGB2(&m);
    
    hand.figers.clear();
    makeContours(&m, &hg);
    
    if (showDebugMsg) {
        pyrDown(m.bw,m.bw);
        pyrDown(m.bw,m.bw);
        cvtColor(m.bw, m.src(Rect({m.src.cols - m.bw.cols, 0}, m.bw.size())), CV_GRAY2RGBA);
        
//        cvtColor(m.histImage, m.src(Rect({0, 0}, m.histImage.size())), CV_RGB2RGBA);
    }
}
