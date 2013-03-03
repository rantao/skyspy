//
//  AppDelegate.m
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import <Firebase/Firebase.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [SplashViewController new];
    [self.window makeKeyAndVisible];

    /*FirebaseComm *fbc = [[FirebaseComm alloc] init];
    [fbc initRecvFirebase:@"Ran"];
    
    fbCallback callback = ^(FDataSnapshot *snapshot) {
        NSDictionary *recv = [snapshot val];
        for (NSString *key in recv) {
            if (![fbc.drops containsObject:[recv objectForKey:key]]) {
                NSLog(@"Added %@\n", [recv objectForKey:key]);
                [fbc.drops addObject:[recv objectForKey:key]];
            }
        }
    };
    
    [fbc loadReceivedFromFirebase:@"Ran" withCallback:callback];
    
    CLLocationCoordinate2D loc;
    loc.latitude = 2.0;
    loc.longitude = 2.0;
    [fbc pushToFirebase:@"Jim" toUser:@"Ran" withMessage:@"Hi Ran" withLocation:loc withRoll:10.0];
    [fbc pushToFirebase:@"Katherine" toUser:@"Ran" withMessage:@"Hello Ran" withLocation:loc withRoll:10.0];
    [fbc pushToFirebase:@"Bob" toUser:@"Ran" withMessage:@"Where are you Ran" withLocation:loc withRoll:10.0];
    [fbc pushToFirebase:@"Steve" toUser:@"Ran" withMessage:@"Talk to me Ran" withLocation:loc withRoll:10.0];*/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
