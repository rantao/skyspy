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

@interface DropMessageViewController ()
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *instructions;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
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
}


-(void) showCameraFeed {
	[self setCaptureManager:[CaptureSessionManager new]];
    
	[[self captureManager] addVideoInput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    self.instructions = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
	[self.instructions setBackgroundColor:[UIColor clearColor]];
	[self.instructions setFont:[UIFont fontWithName:@"Helevtica Neue Light" size: 18.0]];
	[self.instructions setTextColor:[UIColor redColor]];
	[self.instructions setText:@"Look up to the sky..."];
    [self.instructions setHidden:YES];
	[[self view] addSubview:self.instructions];
    
	[[self.captureManager captureSession] startRunning];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
