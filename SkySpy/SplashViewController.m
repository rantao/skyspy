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

@interface SplashViewController ()
@property (nonatomic, strong) DropMessageViewController *dropMessageViewController;
@property (nonatomic, strong) PickupMessageViewController *pickupMessageViewController;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = UIColorFromRGB(0x12bdf5);
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_bg.png"]];
//        } else {
//            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_bg.png"]];
//
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Add title label
    UILabel *skySpyTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, self.view.frame.size.height/16.0, self.view.frame.size.width - 80, self.view.frame.size.height/2.0)];
    skySpyTitleLabel.font = [UIFont fontWithName:@"Renegade Master" size:72];
    skySpyTitleLabel.backgroundColor = [UIColor clearColor];
    skySpyTitleLabel.textColor = UIColorFromRGB(0xdef7ff);
    skySpyTitleLabel.text = @"sky spy";
    skySpyTitleLabel.numberOfLines = 2;
    skySpyTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Add drop button
    UIButton *dropButton = [[UIButton alloc] initWithFrame: CGRectMake((self.view.frame.size.width - 128)/2.0, self.view.frame.size.height/2.0, 128, 128)];
    dropButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropbutton.png"]];
    [dropButton addTarget:self action:@selector(dropButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add pickup button
    UIButton *pickupButton = [[UIButton alloc] initWithFrame: CGRectMake((self.view.frame.size.width - 128)/2.0, self.view.frame.size.height/4.0*3.0, 128, 128)];
    pickupButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pickupbutton.png"]];
    [pickupButton addTarget:self action:@selector(pickupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self.view addSubview:skySpyTitleLabel];
    [self.view addSubview:dropButton];
    [self.view addSubview:pickupButton];

}

-(void) pickupButtonPressed: (UIButton *) sender {
    self.pickupMessageViewController = [PickupMessageViewController new];
    [self presentViewController:self.pickupMessageViewController animated:YES completion:nil];
}

-(void) dropButtonPressed: (UIButton *) sender {
    self.dropMessageViewController = [DropMessageViewController new];
    [self presentViewController:self.dropMessageViewController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
