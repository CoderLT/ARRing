//
//  ATAlertView.m
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATAlertView.h"

@implementation ATAlertView

#if defined(APP_TitleButtonColor)
+ (void)load {
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    config.itemHighlightColor = APP_TitleButtonColor;
}
#endif

+ (instancetype)showTitle:(NSString *)title message:(NSString *)message normalButtons:(NSArray *)normalButtons highlightButtons:(NSArray *)highlightButtons completion:(ATAlertViewCompletion)completion
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *btnTitle in normalButtons) {
        [items addObject:MMItemMake(btnTitle, MMItemTypeNormal, ^(NSInteger index){
            if (completion) {
                completion(index, btnTitle);
            }
        })];
    }
    for (NSString *btnTitle in highlightButtons) {
        [items addObject:MMItemMake(btnTitle, MMItemTypeHighlight, ^(NSInteger index){
            if (completion) {
                completion(index, btnTitle);
            }
        })];
    }
    
    ATAlertView *alertView = [[self alloc] initWithTitle:title detail:message items:items];
    [alertView show];
    return alertView;
}

@end
