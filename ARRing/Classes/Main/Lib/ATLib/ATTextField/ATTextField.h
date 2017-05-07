//
//  TurnTable
//
//  Created by Summer on 14-3-18.
//  Copyright (c) 2014年 xiao6 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ATTextFieldDelegate <NSObject>

@optional
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end

@interface ATTextField : UITextField
@property (nonatomic, weak) id <ATTextFieldDelegate> ATDelegate;
@property (nonatomic, assign) UIEdgeInsets inset;
@end

@interface ATTextFieldDelegeteImp : NSObject<UITextFieldDelegate>
@property(nonatomic, weak)id <ATTextFieldDelegate> delegate;
@end