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
* �������ƣ�HandGesture
* ����˵�������ñ�����ֵ
* �����������
* �����������
********************************************************************************************/
HandGesture::HandGesture()
{
	frameNumber=0;					//֡����	
	nrNoFinger=0;					//
	fontFace = FONT_HERSHEY_PLAIN;	//����
}
/*******************************************************************************************
* �������ƣ�initVectors
* ����˵������ʼ���������⼸���������Ǻ�͹����صĲ���
* �����������
* �����������
********************************************************************************************/
void HandGesture::initVectors()
{
	hullI=vector<vector<int> >(contours.size());						
	hullP=vector<vector<Point> >(contours.size());
	defects=vector<vector<Vec4i> > (contours.size());	//ȱ��
}
/*******************************************************************************************
* �������ƣ�analyzeContours
* ����˵��������������
* �����������
* �����������
********************************************************************************************/
void HandGesture::analyzeContours()
{
	bRect_height=bRect.height;
	bRect_width=bRect.width;
}
/*******************************************************************************************
* �������ƣ�bool2string
* ����˵�����������͵�����ת������Ӧ���ַ���
* ���������tf->����������
* ��������������ַ���
********************************************************************************************/
string HandGesture::bool2string(bool tf)
{
	if(tf)
		return "true";
	else
		return "false";
}
/*******************************************************************************************
* �������ƣ�intToString
* ����˵��������������ת��Ϊ�ַ���
* ���������number->��������
* ��������������ַ���
********************************************************************************************/
string HandGesture::intToString(int number)
{
	stringstream ss;
	ss << number;
	string str = ss.str();
	return str;
}
/*******************************************************************************************
* �������ƣ�printGestureInfo
* ����˵������ԭͼ����ʾʶ���������Ϣ
* ���������src->��Ҫ��ʾ�����Ϣ����ͨ��Matͼ������
* �����������
********************************************************************************************/
void HandGesture::printGestureInfo(Mat src)
{
	int fontFace = FONT_HERSHEY_PLAIN;						//����	
	Scalar fColor(245,200,200);								//������ɫ	
	int xpos=src.cols/1.5;									//��ͼ������ʾ��λ������
	int ypos=src.rows/1.6;									//
	float fontSize=0.7f;									//�����С
	int lineChange=14;										//ÿ��ʾ��һ���ַ�����ѽxpos�����������ӵ���������
	string info= "Figure info:";
	putText(src,info,Point(ypos,xpos),fontFace,fontSize,fColor);
	xpos+=lineChange;
	info=string("Number of defects: ") + string(intToString(nrOfDefects)) ;//ָ��ĸ���
	putText(src,info,Point(ypos,xpos),fontFace,fontSize  ,fColor);
	xpos+=lineChange;
	info=string("bounding box height, width ") + string(intToString(bRect_height)) + string(" , ") +  string(intToString(bRect_width)) ;
	putText(src,info,Point(ypos,xpos),fontFace,fontSize ,fColor); //�ֲ����������εĸ߿�
	xpos+=lineChange;
	info=string("Is hand: ") + string(bool2string(isHand));		
	putText(src,info,Point(ypos,xpos),fontFace,fontSize  ,fColor);//����Ƿ����֣�trueΪ��⵽�֣�falseΪδ��⵽��
}
/*******************************************************************************************
* �������ƣ�detectIfHand
* ����˵��������Ƿ�����
* �����������
* �����������
********************************************************************************************/
bool HandGesture::detectIfHand() 
{
	analyzeContours();				//������������ʵֻ�𵽸�ȫ�ֱ������ƵĹ���
	double h = bRect_height; 
	double w = bRect_width;
	isHand=true;
	if(fingerTips.size() > 5 )		//ʶ�������ָ�����5����ʱ��
	{
		isHand=false;
	}
	else if(h==0 || w == 0)			//�ֲ�������Ӿ���Ϊ�Ŀ��Ϊ0
	{
		isHand=false;
	}
	else if(h/w > 4 || w/h >4)		//�ֲ�������Ӿ���Ϊ�Ŀ�߱��������ʱ��
	{
		isHand=false;	
	}
	else if(bRect.x<20)				//�ֲ�������Ӿ���Ϊ��x����̫С��̫������߽磩
	{
		isHand=false;	
	}	
	return isHand;					//��������ԭ�򷵻��Ǹ���
}
/*******************************************************************************************
* �������ƣ�distanceP2P
* ����˵������������ľ���
* ���������a��b->��ά�����
* �����������
********************************************************************************************/
float HandGesture::distanceP2P(Point a, Point b)
{
	float d= sqrt(fabs( pow(a.x-b.x,2) + pow(a.y-b.y,2) )) ;  
	return d;
}

/*******************************************************************************************
* �������ƣ�removeRedundantFingerTips
* ����˵����ɾ��̫�ӽ��˴˵�ָ��,(�������Ŀǰ����ȱ�ݣ����ò��󣡣�������������)
* �����������
* �����������
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
* �������ƣ�computeFingerNumber
* ����˵����������ָ���������Ӻܶ�֡ͼ��ʶ��Ľ���У�����ʶ�����ָͷ�����������
* �����������
* �����������
********************************************************************************************/
void HandGesture::computeFingerNumber()
{
	std::sort(fingerNumbers.begin(), fingerNumbers.end());   //���������򣬴�С������
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
	mostFrequentFingerNumber=frequentNr;	//14֡ͼ��ʶ�����ָ����Ƶ�ʳ�����ߵ��ж�Ϊ����ܵ���ָ����
}

/*******************************************************************************************
* �������ƣ�addFingerNumberToVector
* ����˵������ÿ֡��ʶ�𵽵�ָ���������룬�ж���ָ����������
* �����������
* �����������
********************************************************************************************/
void HandGesture::addFingerNumberToVector()
{
	int i=fingerTips.size();				//ָ�������
	fingerNumbers.push_back(i);				//��ÿ֡��ʶ�𵽵�ָ���������룬�ж���ָ����������
}

// calculate most frequent numbers of fingers 
// over 20 frames

/*******************************************************************************************
* �������ƣ�getFingerNumber
* ����˵������ȡ��ָ������
* ���������m->�Զ������ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::getFingerNumber(MyImage *m)
{
	removeRedundantFingerTips();                   //ɾ��ʶ������˴�̫������ָ��
	if(bRect.height > m->src.rows/2 && nrNoFinger>12 && isHand )
	{
		numberColor=Scalar(0,200,0);
		addFingerNumberToVector();
		if(frameNumber>12)							//ʶ��12+1֡��
		{
			nrNoFinger=0;
			frameNumber=0;	
			computeFingerNumber();					//������ָ����
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
		numberColor=Scalar(200,200,200);           //������ʾ����ʹ�õ���ɫ
	}
}
/*******************************************************************************************
* �������ƣ�getAngle
* ����˵������ȡ�Ƕȣ������㣬һ��Ϊ���㣬�����������ĽǶȣ��õ��ǽǶ���
* ���������s��f��e��������͹��ȱ�ݵĵ������꣬s->��ʼ���꣬f->�ǵ����꣬e->��������
* ���������float ���͵ĽǶ�
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
* �������ƣ�eleminateDefects
* ����˵�������ȱ�ݣ�ʹ���˶������ȱ�ݵ�����
            1.ָ�⵽ָ��ľ��벻��С���ֲ���������Ӿ��θ߶ȵ�5��֮һ
			2.��ָ��ļнǲ���С��99��
* ���������m->�Զ���ͼ�����ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::eleminateDefects(MyImage *m)
{
	int tolerance =  bRect_height/5;
	float angleTol=99;             //͹��ȱ�ݵ㣬Ҳ����ָ��н���������Ϊ99��
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
* �������ƣ�removeRedundantEndPoints
* ����˵����ɾ���˵��͹��ȱ�ݣ����������ͬһָ��
* ���������newDefects->͹��ȱ������,m->�Զ���ͼ�����ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::removeRedundantEndPoints(vector<Vec4i> newDefects,MyImage *m)
{
	Vec4i temp;
	float avgX, avgY;
	float tolerance=bRect_width/6;    //���̵Ĺ��Ϊ�ֲ���������Ӿ��εĿ������֮һ
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
* �������ƣ�checkForOneFinger
* ����˵��������ָʱʹ�ô�ģʽʶ����ָ��͹��ȱ�ݲ��ʺ����ڵ�ָ��⣬����ʹ�����²�ͨ��͹��ȱ�ݷ�ʽ��ʶ��ָ
* ���������m->�Զ���ͼ�����ݽṹ��
* �����������
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
			highestP=v;                 //�������������y��С�ĵ㣬Ҳ�������ߵĵ�
			cout<<highestP.y<<endl;       
		}
		d++;	
	}
	int n=0;
	d=hullP[cIdx].begin();				//����ָ��͹���ϵĵ㼯
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
* �������ƣ�checkForOneFinger1
* ����˵��������ָʱʹ�ô�ģʽʶ����ָ���ֲ�����������ڽ�Բ��Բ�ĵ�ָ��ľ������ĳ��ֵ��ʱ���ж�Ϊָ��
* ���������m->�Զ���ͼ�����ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::checkForOneFinger1(MyImage *m)
{
	//cv::Mat drawing(m->src.size(), CV_8UC3);
	int yTol = bRect.height / 6;
	Point highestP;

	double dist, maxdist = -1;

	cv::Point center;
	for (int i = 0; i< m->src.cols; i++)   //�������������Բ
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
			highestP = v;                 //�������������y��С�ĵ㣬Ҳ�������ߵĵ�
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
* �������ƣ�drawFingerTips
* ����˵��������ָ������
* ���������m->�Զ���ͼ�����ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::drawFingerTips(MyImage *m)
{
	Point p;
	int k=0;
	for(int i=0;i<fingerTips.size();i++)
	{
		p=fingerTips[i];
		putText(m->src,intToString(i),p-Point(0,30),fontFace, 1.2f,Scalar(200,200,200),2);
		//����ָ������
   		circle( m->src,p,   5, Scalar(100,255,100), 1 );
		line(m->src, p, p-Point(0, 25), Scalar(0, 255, 0), 1);
		line(m->src, p, p+Point(0, 25), Scalar(0, 255, 0), 1);
		line(m->src, p, p-Point(25, 0), Scalar(0, 255, 0), 1);
		line(m->src, p, p+Point(25, 0), Scalar(0, 255, 0), 1);
   	 }
}
/*******************************************************************************************
* �������ƣ�getFingerTips
* ����˵������ȡָ��
* ���������m->�Զ���ͼ�����ݽṹ��
* �����������
********************************************************************************************/
void HandGesture::getFingerTips(MyImage *m)
{
	int i=0;
	fingerTips.clear();								//���ָ������	
	vector<Vec4i>::iterator d=defects[cIdx].begin();//ָ������
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
	if(fingerTips.size()==0)						//ͨ�����Ϲ���û���ҵ�ָ�������£���Ϊֻ������ָ���ʱ�����ָ�죩
	{
		checkForOneFinger(m);						//����ָ���ģʽ
		//checkForOneFinger1(m);
	}
}
/*
void GetContourCenter(InputArray contour, Point2f &pt)
{
	//���ķ�ץ���ĵ�
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
