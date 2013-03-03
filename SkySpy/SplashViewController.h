//
//  SplashViewController.h
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *skySpyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropButton;
@property (weak, nonatomic) IBOutlet UIButton *pickupButton;
- (IBAction)dropButtonPressed:(UIButton *)sender;
- (IBAction)pickupButtonPressed:(UIButton *)sender;

@end
