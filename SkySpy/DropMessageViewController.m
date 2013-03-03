//
//  DropMessageViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "DropMessageViewController.h"
#import "CaptureSessionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface DropMessageViewController ()
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *instructions;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMAttitude *attitude;
@property (nonatomic, strong) UIButton *dropButton;
@end

@implementation DropMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        [self setCaptureSession:[[AVCaptureSession alloc] init]];

        //self.cameraView = [[UIView alloc] initWithFrame:self.view.frame];
        //[self.view addSubview:self.cameraView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showCameraFeed];
    self.dropButton = [[UIButton alloc] initWithFrame: CGRectMake((self.view.frame.size.width - 128)/2.0, 50, 128, 128)];
    self.dropButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropbutton.png"]];
    [self.dropButton addTarget:self action:@selector(dropButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 1.0;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                                                                toQueue:[NSOperationQueue currentQueue]
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
        {
            self.attitude = motion.attitude;
                                                                
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
                                        [self.view addSubview:self.dropButton];
                                    }
                                }];
            }
            
            //NSLog(@"%f, %f", RADIANS_TO_DEGREES(self.attitude.pitch), RADIANS_TO_DEGREES(self.attitude.yaw));
        }];
    }
    else {
        NSLog(@"No gyroscope on device.");
    }
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
    
	[[self.captureManager captureSession] startRunning];
    
    
}

- (void) dropButtonPressed: (UIButton *) sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
