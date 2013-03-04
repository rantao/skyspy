//
//  NumberViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.4.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "NumberViewController.h"

@interface NumberViewController ()

@end

@implementation NumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (self.numberTextField) {
        [self savePhoneNumberToUserDefaults:self.numberTextField.text];
        [self dismissViewControllerAnimated:YES completion:nil];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
