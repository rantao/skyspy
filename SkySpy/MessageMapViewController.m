//
//  MessageMapViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.3.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "MessageMapViewController.h"
#import "MapAnnotation.h"

@interface MessageMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D dropPoint;
@property (nonatomic) CLLocationDistance radius;
@property (nonatomic, strong) NSString *dropPointName;
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
    
    // Start region monitoring
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager regionMonitoringAvailable] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            CLLocationDistance radius = self.radius; // 10 meter radius
            CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:self.dropPoint
                                                                       radius:radius
                                                                   identifier:self.dropPointName];
            [self.locationManager startMonitoringForRegion:region];
        }
    
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:self.dropPointName])
    {
        // Present camera view controller
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:self.dropPointName])
    {
        // Remove camera view controller
    }
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
