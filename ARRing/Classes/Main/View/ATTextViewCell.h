//
//  ATTextViewCell.h
//  AT
//
//  Created by CoderLT on 15/10/7.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTextCell.h"
#import "ATTextView.h"

@interface ATTextViewCell : ATTextCell

@property (weak, nonatomic) IBOutlet ATTextView *textView;
@end
