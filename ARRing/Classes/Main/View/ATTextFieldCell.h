//
//  ATTextFieldCell.h
//  AT
//
//  Created by CoderLT on 15/10/7.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTextCell.h"
#import "ATTextField.h"

@interface ATTextFieldCell : ATTextCell
@property (weak, nonatomic) IBOutlet ATTextField *textField;

+ (instancetype)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
