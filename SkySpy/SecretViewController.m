//
//  SecretViewController.m
//  SkySpy
//
//  Created by Jim Liu on 3/4/13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "SecretViewController.h"
#import "CaptureSessionManager.h"

@interface SecretViewController ()
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UILabel *secret;
@end

@implementation SecretViewController

@synthesize msg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [UIView transitionWithView:self.secret
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.secret.alpha = 1.0;
                    }
                    completion:nil];
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
    
    self.secret = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-240)/2.0, 50, 240, 30)];
    self.secret.backgroundColor = [UIColor clearColor];
    self.secret.font =[UIFont fontWithName:@"Renegade Master" size: 20];
    self.secret.textColor = [UIColor whiteColor];
	self.secret.text = self.msg;
    self.secret.textAlignment = NSTextAlignmentCenter;
    self.secret.hidden = NO;
    self.secret.alpha = 0.0;
	[self.view addSubview:self.secret];
    
    // TODO possibly add button to trigger message reveal
    
	[[self.captureManager captureSession] startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
