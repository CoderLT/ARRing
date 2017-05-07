//
//  ATRefreshWebController.h
//  Yami
//
//  Created by CoderLT on 16/8/2.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATBaseWebController.h"

@interface ATRefreshWebController : ATBaseWebController
@property (nonatomic, copy) NSString *navTitle2;

+ (instancetype)vcWithURLString:(NSString *)urlString title:(NSString *)title;
@end
