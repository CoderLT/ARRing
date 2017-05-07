//
//  ATCommentLabel.h
//  AT
//
//  Created by xiao6 on 14-10-21.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLabel.h"

typedef void(^ATCommentLabelClickBlockType)(NSRange line);

@interface ATCommentLabel : PPLabel

@property (nonatomic, copy) ATCommentLabelClickBlockType clickBlock;

- (void)removeHighlight;
+ (ATCommentLabel *)lableWithAttrString:(NSAttributedString *)attrbuteString clickBlock:(ATCommentLabelClickBlockType)block;

@end
