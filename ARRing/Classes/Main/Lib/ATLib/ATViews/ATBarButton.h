//
//  ATBarButton.h
//  AT
//
//  Created by xiao6 on 15/10/2.
//  Copyright © 2015年 AT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATBarButton : UIButton

+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
@end
