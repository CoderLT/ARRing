//
//  ATTitleTextFieldCell.h
//  AT
//
//  Created by xiao6 on 15/10/24.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTextCell.h"
#import "ATTextField.h"

@interface ATTitleTextFieldCell : ATTextCell
@property (weak, nonatomic) IBOutlet ATTextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
