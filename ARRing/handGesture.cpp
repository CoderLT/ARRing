#include "handGesture.hpp"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>

using namespace cv;
using namespace std;

/*******************************************************************************************
 * 函数名称：HandGesture
 * 功能说明：重置变量的值
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
HandGesture::HandGesture()
{
    frameNumber=0;					//帧数量
    nrNoFinger=0;					//
    fontFace = FONT_HERSHEY_PLAIN;	//字体
}
/*******************************************************************************************
 * 函数名称：initVectors
 * 功能说明：初始化向量，这几个向量都是和凸包相关的参数
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::initVectors()
{
    hullI=vector<vector<int> >(contours.size());
    hullP=vector<vector<Point> >(contours.size());
    defects=vector<vector<Vec4i> > (contours.size());	//缺陷
}
/*******************************************************************************************
 * 函数名称：analyzeContours
 * 功能说明：分析轮廓，
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::analyzeContours()
{
    bRect_height=bRect.height;
    bRect_width=bRect.width;
}
/*******************************************************************************************
 * 函数名称：bool2string
 * 功能说明：将布尔型的数据转换成相应的字符串
 * 输入参数：tf->布尔型数据
 * 输出参数：返回字符串
 ********************************************************************************************/
string HandGesture::bool2string(bool tf)
{
    if(tf)
        return "true";
    else
        return "false";
}
/*******************************************************************************************
 * 函数名称：intToString
 * 功能说明：将整型数据转换为字符串
 * 输入参数：number->整型数据
 * 输出参数：返回字符串
 ********************************************************************************************/
string HandGesture::intToString(int number)
{
    stringstream ss;
    ss << number;
    string str = ss.str();
    return str;
}
/*******************************************************************************************
 * 函数名称：printGestureInfo
 * 功能说明：在原图中显示识别出来的信息
 * 输入参数：src->需要显示检测信息的三通道Mat图像数据
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::printGestureInfo(Mat src)
{
    int fontFace = FONT_HERSHEY_PLAIN;						//字体
    Scalar fColor(245,200,200);								//字体颜色
    int xpos=src.cols/1.5;									//在图像上显示的位置坐标
    int ypos=src.rows/1.6;									//
    float fontSize=0.7f;									//字体大小
    int lineChange=14;										//每显示完一行字符，需呀xpos坐标向下增加的像素行数
    string info= "Figure info:";
    putText(src,info,Point(ypos,xpos),fontFace,fontSize,fColor);
    xpos+=lineChange;
    info=string("Number of defects: ") + string(intToString(nrOfDefects)) ;//指缝的个数
    putText(src,info,Point(ypos,xpos),fontFace,fontSize  ,fColor);
    xpos+=lineChange;
    info=string("bounding box height, width ") + string(intToString(bRect_height)) + string(" , ") +  string(intToString(bRect_width)) ;
    putText(src,info,Point(ypos,xpos),fontFace,fontSize ,fColor); //手部轮廓外界矩形的高宽
    xpos+=lineChange;
    info=string("Is hand: ") + string(bool2string(isHand));
    putText(src,info,Point(ypos,xpos),fontFace,fontSize  ,fColor);//输出是否有手，true为检测到手，false为未检测到手
}
/*******************************************************************************************
 * 函数名称：detectIfHand
 * 功能说明：检测是否有手
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
bool HandGesture::detectIfHand()
{
    analyzeContours();				//轮廓分析，其实只起到给全局变量复制的工作
    double h = bRect_height;
    double w = bRect_width;
    isHand=true;
    if(fingerTips.size() > 5 )		//识别出来的指尖大于5个的时候
    {
        isHand=false;
    }
    else if(h==0 || w == 0)			//手部轮廓外接矩形为的宽高为0
    {
        isHand=false;
    }
    else if(h/w > 4 || w/h >4)		//手部轮廓外接矩形为的宽高比例过大的时候
    {
        isHand=false;
    }
    else if(bRect.x<20)				//手部轮廓外接矩形为的x坐标太小（太靠近左边界）
    {
        isHand=false;
    }
    return isHand;					//除了以上原因返回是个手
}
/*******************************************************************************************
 * 函数名称：distanceP2P
 * 功能说明：计算两点的距离
 * 输入参数：a，b->二维坐标点
 * 输出参数：无
 ********************************************************************************************/
float HandGesture::distanceP2P(Point a, Point b)
{
    float d= sqrt(fabs( pow(a.x-b.x,2) + pow(a.y-b.y,2) )) ;
    return d;
}

/*******************************************************************************************
 * 函数名称：removeRedundantFingerTips
 * 功能说明：删除太接近彼此的指尖,(这个函数目前还有缺陷，作用不大！！！！！！！！)
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::removeRedundantFingerTips()
{
    vector<Point> newFingers;
    for(int i=0;i<fingerTips.size();i++)
    {
        for(int j=i;j<fingerTips.size();j++)
        {
            if(distanceP2P(fingerTips[i],fingerTips[j])<10 && i!=j)
            {
                cout << "he" << endl;
            }
            else
            {
                newFingers.push_back(fingerTips[i]);
                break;
            }
        }
    }
    fingerTips.swap(newFingers);
}
/*******************************************************************************************
 * 函数名称：computeFingerNumber
 * 功能说明：计算手指的数量，从很对帧图像识别的结果中，看看识别出的指头情况那种最多次
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::computeFingerNumber()
{
    std::sort(fingerNumbers.begin(), fingerNumbers.end());   //给数据排序，从小大排序
    int frequentNr;
    int thisNumberFreq=1;
    int highestFreq=1;
    frequentNr=fingerNumbers[0];
    for(int i=1;i<fingerNumbers.size(); i++)
    {
        if(fingerNumbers[i-1]!=fingerNumbers[i])
        {
            if(thisNumberFreq>highestFreq)
            {
                frequentNr=fingerNumbers[i-1];
                highestFreq=thisNumberFreq;
            }
            thisNumberFreq=0;
        }
        thisNumberFreq++;
    }
    if(thisNumberFreq>highestFreq)
    {
        frequentNr=fingerNumbers[fingerNumbers.size()-1];
    }
    mostFrequentFingerNumber=frequentNr;	//14帧图像识别出手指数量频率出现最高的判定为最可能的手指数量
}

/*******************************************************************************************
 * 函数名称：addFingerNumberToVector
 * 功能说明：将每帧的识别到的指尖数量存入，判断手指数量的向量
 * 输入参数：无
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::addFingerNumberToVector()
{
    int i=fingerTips.size();				//指尖的数量
    fingerNumbers.push_back(i);				//将每帧的识别到的指尖数量存入，判断手指数量的向量
}

// calculate most frequent numbers of fingers
// over 20 frames

/*******************************************************************************************
 * 函数名称：getFingerNumber
 * 功能说明：获取手指的数量
 * 输入参数：m->自定义数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::getFingerNumber(MyImage *m)
{
    removeRedundantFingerTips();                   //删除识别出来彼此太靠近的指尖
    if(bRect.height > m->src.rows/2 && nrNoFinger>12 && isHand )
    {
        numberColor=Scalar(0,200,0);
        addFingerNumberToVector();
        if(frameNumber>12)							//识别12+1帧话
        {
            nrNoFinger=0;
            frameNumber=0;
            computeFingerNumber();					//计算手指数量
            numbers2Display.push_back(mostFrequentFingerNumber);
            fingerNumbers.clear();
        }
        else
        {
            frameNumber++;
        }
    }
    else
    {
        nrNoFinger++;
        numberColor=Scalar(200,200,200);           //设置显示数字使用的颜色
    }
}
/*******************************************************************************************
 * 函数名称：getAngle
 * 功能说明：获取角度，三个点，一个为顶点，计算这个顶点的角度，用的是角度制
 * 输入参数：s，f，e代表描述凸包缺陷的单个坐标，s->起始坐标，f->角点坐标，e->结束坐标
 * 输出参数：float 类型的角度
 ********************************************************************************************/
float HandGesture::getAngle(Point s, Point f, Point e)
{
    float l1 = distanceP2P(f,s);
    float l2 = distanceP2P(f,e);
    float dot=(s.x-f.x)*(e.x-f.x) + (s.y-f.y)*(e.y-f.y);
    float angle = acos(dot/(l1*l2));
    angle=angle*180/M_PI;
    return angle;
}
/*******************************************************************************************
 * 函数名称：eleminateDefects
 * 功能说明：清除缺陷，使用了多种清除缺陷的条件
 1.指尖到指缝的距离不能小于手部轮廓的外接矩形高度的5分之一
 2.手指间的夹角不能小于99度
 * 输入参数：m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::eleminateDefects(MyImage *m)
{
    int tolerance =  bRect_height/5;
    float angleTol=99;             //凸包缺陷点，也就是指间夹角最大的允许为99度
    vector<Vec4i> newDefects;
    int startidx, endidx, faridx;
    vector<Vec4i>::iterator d=defects[cIdx].begin();
    while( d!=defects[cIdx].end() )
    {
   	    Vec4i& v=(*d);
        startidx=v[0]; Point ptStart(contours[cIdx][startidx] );
        endidx=v[1]; Point ptEnd(contours[cIdx][endidx] );
        faridx=v[2]; Point ptFar(contours[cIdx][faridx] );
        if (distanceP2P(ptStart, ptFar) > tolerance && distanceP2P(ptEnd, ptFar) > tolerance && getAngle(ptStart, ptFar, ptEnd) < angleTol)
        {
            if (ptEnd.y > (bRect.y + bRect.height - bRect.height / 4))
            {
                circle(m->src, ptFar, 4, Scalar(0x26, 0x66, 0xEB), 4);
            }
            else if (ptStart.y > (bRect.y + bRect.height - bRect.height / 4))
            {
                circle(m->src, ptFar, 4, Scalar(0x26, 0x66, 0xEB), 4);
            }
            else
            {
                newDefects.push_back(v);
            }
        }
        else
        {
            circle(m->src, ptFar, 4, Scalar(0x26, 0x66, 0xEB), 4);
        }
        d++;
    }
    nrOfDefects=newDefects.size();
    defects[cIdx].swap(newDefects);
    removeRedundantEndPoints(defects[cIdx], m);
}

// remove endpoint of convexity defects if they are at the same fingertip
/*******************************************************************************************
 * 函数名称：removeRedundantEndPoints
 * 功能说明：删除端点的凸性缺陷，如果他们在同一指尖
 * 输入参数：newDefects->凸包缺陷向量,m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::removeRedundantEndPoints(vector<Vec4i> newDefects,MyImage *m)
{
    Vec4i temp;
    float avgX, avgY;
    float tolerance=bRect_width/6;    //容忍的公差，为手部轮廓的外接矩形的宽的六分之一
    int startidx, endidx, faridx;
    int startidx2, endidx2;
    for(int i=0;i<newDefects.size();i++)
    {
        for(int j=i;j<newDefects.size();j++)
        {
            startidx=newDefects[i][0]; Point ptStart(contours[cIdx][startidx] );
            endidx=newDefects[i][1]; Point ptEnd(contours[cIdx][endidx] );
            startidx2=newDefects[j][0]; Point ptStart2(contours[cIdx][startidx2] );
            endidx2=newDefects[j][1]; Point ptEnd2(contours[cIdx][endidx2] );
            if(distanceP2P(ptStart,ptEnd2) < tolerance )
            {
                contours[cIdx][startidx]=ptEnd2;
                break;
            }
            if(distanceP2P(ptEnd,ptStart2) < tolerance )
            {
                contours[cIdx][startidx2]=ptEnd;
            }
        }
    }
}

/*******************************************************************************************
 * 函数名称：checkForOneFinger
 * 功能说明：单手指时使用次模式识别手指，凸包缺陷不适合用于单指检测，所以使用如下不通过凸包缺陷方式来识别单指
 * 输入参数：m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::checkForOneFinger(MyImage *m)
{
    int yTol=bRect.height/6;
    Point highestP;
    highestP.y=m->src.rows;
    vector<Point>::iterator d=contours[cIdx].begin();
    while( d!=contours[cIdx].end() )
    {
   	    Point v=(*d);
        if(v.y<highestP.y)
        {
            highestP=v;                 //查找最大轮廓上y最小的点，也是最靠近左边的点
            cout<<highestP.y<<endl;
        }
        d++;
    }
    int n=0;
    d=hullP[cIdx].begin();				//向量指向凸包上的点集
    while( d!=hullP[cIdx].end() )
    {
   	    Point v=(*d);
        cout<<"x " << v.x << " y "<<  v.y << " highestpY " << highestP.y<< "ytol "<<yTol<<endl;
        if(v.y<highestP.y+yTol && v.y!=highestP.y && v.x!=highestP.x)
        {
            n++;
        }
        d++;
    }
    if(n==0)
    {
        fingerTips.push_back(highestP);
    }
}

/*******************************************************************************************
 * 函数名称：checkForOneFinger1
 * 功能说明：单手指时使用次模式识别手指，手部轮廓的最大内接圆的圆心到指尖的距离大于某个值的时候判断为指尖
 * 输入参数：m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::checkForOneFinger1(MyImage *m)
{
    //cv::Mat drawing(m->src.size(), CV_8UC3);
    int yTol = bRect.height / 6;
    Point highestP;
    
    double dist, maxdist = -1;
    
    cv::Point center;
    for (int i = 0; i< m->src.cols; i++)   //轮廓的最大内切圆
    {
        for (int j = 0; j< m->src.rows; j++)
        {
            dist = pointPolygonTest(contours[cIdx], cv::Point(i, j), true);
            if (dist > maxdist)
            {
                maxdist = dist;
                center = cv::Point(i, j);
            }
        }
    }
    circle(m->src, center, maxdist, cv::Scalar(220, 75, 20), 1, CV_AA);
    
    vector<Point>::iterator d = contours[cIdx].begin();
    double distance;
    double t = 0;
    while (d != contours[cIdx].end())
    {
        Point v = (*d);
        distance = powf((v.x - center.x), 2) + powf((v.y - center.y), 2);
        distance = sqrtf(distance);
        if (distance > t)
        {
            t = distance;
            highestP = v;                 //查找最大轮廓上y最小的点，也是最靠近左边的点
            cout << highestP.y << endl;
        }
        d++;
    }
    if (t > yTol)
    {
        fingerTips.push_back(highestP);
    }
}
/*******************************************************************************************
 * 函数名称：drawFingerTips
 * 功能说明：画出指尖坐标
 * 输入参数：m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::drawFingerTips(MyImage *m)
{
    Point p;
    int k=0;
    for(int i=0;i<fingerTips.size();i++)
    {
        p=fingerTips[i];
        putText(m->src,intToString(i),p-Point(0,30),fontFace, 1.2f,Scalar(200,200,200),2);
        //绘制指尖坐标
        circle( m->src,p,   5, Scalar(100,255,100), 1 );
        line(m->src, p, p-Point(0, 25), Scalar(0, 255, 0), 1);
        line(m->src, p, p+Point(0, 25), Scalar(0, 255, 0), 1);
        line(m->src, p, p-Point(25, 0), Scalar(0, 255, 0), 1);
        line(m->src, p, p+Point(25, 0), Scalar(0, 255, 0), 1);
    }
}
/*******************************************************************************************
 * 函数名称：getFingerTips
 * 功能说明：获取指尖
 * 输入参数：m->自定义图像数据结构体
 * 输出参数：无
 ********************************************************************************************/
void HandGesture::getFingerTips(MyImage *m)
{
    int i=0;
    fingerTips.clear();								//清除指尖坐标
    vector<Vec4i>::iterator d=defects[cIdx].begin();//指缝向量
    while( d!=defects[cIdx].end() )
    {
   	    Vec4i& v=(*d);
        int startidx=v[0]; Point ptStart(contours[cIdx][startidx] );
        int endidx=v[1]; Point ptEnd(contours[cIdx][endidx] );
        int faridx=v[2]; Point ptFar(contours[cIdx][faridx] );
        if(i==0)
        {
            fingerTips.push_back(ptStart);
            i++;
        }
        fingerTips.push_back(ptEnd);
        d++;
        i++;
   	}
    if(fingerTips.size()==0)						//通过以上过程没有找到指尖的情况下（因为只有两个指尖的时候才有指缝）
    {
        checkForOneFinger(m);						//单手指检测模式
        //checkForOneFinger1(m);
    }
}
/*
 void GetContourCenter(InputArray contour, Point2f &pt)
 {
	//重心法抓中心点
	int contourlength = contour.size;
	CvPoint *pt = 0;
	double avg_px = 0, avg_py = 0;
	for (int i = 0; i < contourlength; i++)
	{
 pt = CV_GET_SEQ_ELEM(CvPoint, contour, i);
 avg_px += pt->x;
 avg_py += pt->y;
	}
	p.x = avg_px / contourlength;
	p.y = avg_py / contourlength;
 }*/
