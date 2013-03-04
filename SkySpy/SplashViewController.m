//
//  SplashViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "SplashViewController.h"
#import "DropMessageViewController.h"
#import "PickupMessageViewController.h"
#import "AskForNumberView.h"

@interface SplashViewController ()
@property (nonatomic, strong) DropMessageViewController *dropMessageViewController;
@property (nonatomic, strong) PickupMessageViewController *pickupMessageViewController;
@property (nonatomic, strong) NSString *userPhoneNumber;
@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Add title label
    self.skySpyTitleLabel.font = [UIFont fontWithName:@"Renegade Master" size:52];
    self.skySpyTitleLabel.backgroundColor = [UIColor clearColor];
    self.skySpyTitleLabel.textColor = UIColorFromRGB(0xffffff);
    self.skySpyTitleLabel.text = @"sky spy";
    self.skySpyTitleLabel.numberOfLines = 2;
    self.skySpyTitleLabel.textAlignment = NSTextAlignmentRight;
    
    //GET USER PHONE NUMBER IF THEY HAVENT SAVED IT YET
    self.userPhoneNumber = [self getPhoneNumberFromUserDefaults];
    
    if (self.userPhoneNumber.length == 0) {
        AskForNumberView *askForNumberView = [[AskForNumberView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:askForNumberView];
    }
    

}


-(NSString *) getPhoneNumberFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [userDefaults stringForKey:@"number"];
    return number;
}


- (IBAction)pickupButtonPressed:(UIButton *)sender {
    self.pickupMessageViewController = [PickupMessageViewController new];
    [self presentViewController:self.pickupMessageViewController animated:YES completion:nil];
}

- (IBAction)dropButtonPressed:(UIButton *)sender {
    
    self.dropMessageViewController = [DropMessageViewController new];
    [self presentViewController:self.dropMessageViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
