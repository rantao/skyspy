//
//  DropMessageViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "DropMessageViewController.h"
#import "CaptureSessionManager.h"
#import "FirebaseComm.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface DropMessageViewController () <CLLocationManagerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *instructions;
@property (nonatomic, retain) UILabel *msg;
@property (nonatomic, strong) UITextField *skyMessage;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMAttitude *attitude;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIButton *dropButton;
@property (nonatomic) CLLocationCoordinate2D coords;
@end

@implementation DropMessageViewController

@synthesize fromUser;
@synthesize toUser;
@synthesize message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.message = @"Hi Ran";
        self.view.backgroundColor = [UIColor blackColor];
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showCameraFeed];
    self.dropButton = [[UIButton alloc] initWithFrame: CGRectMake((self.view.frame.size.width - 128)/2.0, 320, 128, 128)];
    self.dropButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropbutton.png"]];
    [self.dropButton addTarget:self action:@selector(dropButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.dropButton.alpha = 0.0;
    self.dropButton.userInteractionEnabled = NO;
    [self.view addSubview:self.dropButton];
    
    // Textfield for sky writing message
    self.skyMessage = [[UITextField alloc] initWithFrame: CGRectMake(40, self.view.frame.size.height/4.0, self.view.frame.size.width-80, self.view.frame.size.height/2.0)];
    self.skyMessage.placeholder = @"enter secret...";
    self.skyMessage.textAlignment = NSTextAlignmentCenter;
    self.skyMessage.returnKeyType = UIReturnKeyDone;
    self.skyMessage.textColor = [UIColor whiteColor];
    self.skyMessage.font = [UIFont fontWithName:@"Renegade Master" size:20];
    self.skyMessage.hidden = YES;
    self.skyMessage.delegate = self;
    [self.view addSubview:self.skyMessage];

    
    // Start tracking pitch
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 1.0;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                                                                toQueue:[NSOperationQueue currentQueue]
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
        {
            self.attitude = motion.attitude;

            // TODO: change
            if (5 <= RADIANS_TO_DEGREES(self.attitude.pitch) &&
                60 >= RADIANS_TO_DEGREES(self.attitude.pitch) &&
                100 <= RADIANS_TO_DEGREES(self.attitude.yaw))
            {
                [UIView transitionWithView:self.instructions
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.instructions.alpha = 0.0;
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        self.dropButton.userInteractionEnabled = YES;
                                        [UIView animateWithDuration:1.0
                                                         animations:^{
                                                             self.msg.alpha = 1.0;
                                                             self.dropButton.alpha = 1.0;
                                                             self.skyMessage.hidden = NO;
                                                         }];
                                    }
                                }];
            }
            
            //NSLog(@"%f, %f", RADIANS_TO_DEGREES(self.attitude.pitch), RADIANS_TO_DEGREES(self.attitude.yaw));
        }];
    }
    else {
        NSLog(@"No gyroscope on device.");
    }
    
    // Start location services
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}


-(void) showCameraFeed {
	[self setCaptureManager:[CaptureSessionManager new]];
    
	[self.captureManager addVideoInput];
    
	[self.captureManager addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[self.captureManager previewLayer] setBounds:layerRect];
	[[self.captureManager previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
	[self.view.layer addSublayer:[[self captureManager] previewLayer]];
    
    self.instructions = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-240)/2.0, 50, 240, 30)];
    self.instructions.backgroundColor = [UIColor clearColor];
    self.instructions.font =[UIFont fontWithName:@"Helevtica Neue Light" size: 18.0];
    self.instructions.textColor = [UIColor whiteColor];
	self.instructions.text = @"^^ LOOK UP IN THE SKY ^^";
    self.instructions.textAlignment = NSTextAlignmentCenter;
    self.instructions.hidden = NO;
	[self.view addSubview:self.instructions];
    
    self.msg = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-240)/2.0, 50, 240, 30)];
    self.msg.backgroundColor = [UIColor clearColor];
    self.msg.font =[UIFont fontWithName:@"Helevtica Neue Light" size: 18.0];
    self.msg.textColor = [UIColor whiteColor];
	self.msg.text = self.message;
    self.msg.textAlignment = NSTextAlignmentCenter;
    self.msg.hidden = NO;
    self.msg.alpha = 0.0;
    [self.view addSubview:self.msg];
    
	[[self.captureManager captureSession] startRunning];
}

- (void) dropButtonPressed: (UIButton *) sender {
    self.fromUser = @"Jim";
    self.toUser = @"Ran";
    if (self.skyMessage.text) {
        self.message = self.skyMessage.text;
    }
    
    FirebaseComm *fbc = [[FirebaseComm alloc] init];
    [fbc initRecvFirebase:self.toUser];
    [fbc pushToFirebase:self.fromUser
                 toUser:self.toUser
            withMessage:self.message
               withDate:[NSDate date]
           withLocation:self.coords
               withRoll:RADIANS_TO_DEGREES(self.attitude.pitch)];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    self.coords = [loc coordinate];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.skyMessage resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField setUserInteractionEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
