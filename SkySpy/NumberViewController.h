//
//  NumberViewController.h
//  SkySpy
//
//  Created by Ran Tao on 3.4.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
- (IBAction)saveButtonPressed:(UIButton *)sender;

@end
