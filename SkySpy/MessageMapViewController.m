//
//  MessageMapViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.3.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "MessageMapViewController.h"
#import "MapAnnotation.h"

@interface MessageMapViewController () <MKMapViewDelegate>

@end

@implementation MessageMapViewController

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
    self.dateLabel.text = self.date;
    self.timeLabel.text = self.time;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapCenter, 500, 500);
    MapAnnotation *messageAnnotation = [MapAnnotation new];
    messageAnnotation.coordinate = self.mapCenter;
    [self.messageMapView addAnnotation:messageAnnotation];
    [self.messageMapView setRegion:region animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
