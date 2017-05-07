//
//  ATListItem.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListItem.h"

@implementation ATListItem

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithIcon:nil title:title];
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title {
    ATListItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

- (NSAttributedString *)requiredTitle:(NSString *)title {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" *"
                                                                      attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    return attrTitle;
}
- (void)setRequired {
    self.attrTitle = [self requiredTitle:self.title];
}
@end
