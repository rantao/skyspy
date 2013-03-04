//
//  AskForNumberView.m
//  SkySpy
//
//  Created by Ran Tao on 3.4.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "AskForNumberView.h"

@implementation AskForNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (self.numberTextField) {
        [self savePhoneNumberToUserDefaults:self.numberTextField.text];
        [self removeFromSuperview];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.numberTextField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField setUserInteractionEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}


-(void) savePhoneNumberToUserDefaults:(NSString*) number {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:number forKey:@"number"];
}

@end
