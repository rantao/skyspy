//
//  FirebaseComm.m
//  SkySpy
//
//  Created by Jim Liu on 3/2/13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "FirebaseComm.h"

@interface FirebaseComm ()

@property (strong) Firebase *recvfb;

@end

@implementation FirebaseComm

@synthesize drops;
@synthesize recvfb;

- (void)initRecvFirebase:(NSString *)user
{
    NSMutableString *recvPath = [[NSMutableString alloc] initWithString:FIREBASE_ADDR];
    [recvPath appendString:user];
    [recvPath appendString:@"/recv"];
    recvfb = [[Firebase alloc] initWithUrl:recvPath];
}

- (void)pushToFirebase:(NSString *)fromUser
                toUser:(NSString *)user
           withMessage:(NSString *)message
          withLocation:(CLLocationCoordinate2D)location
              withRoll:(double)roll
{
    // Build the path for sender/receiver
    NSMutableString *sentPath = [[NSMutableString alloc] initWithString:FIREBASE_ADDR];
    [sentPath appendString:fromUser];
    [sentPath appendString:@"/sent"];
    Firebase *sentfb = [[Firebase alloc] initWithUrl:sentPath];
    
    // Populate dictionaries
    NSArray *sentkeys = [NSArray arrayWithObjects:@"to", @"message", @"latitude", @"longitude", @"roll", @"read", nil];
    NSArray *recvkeys = [NSArray arrayWithObjects:@"from", @"message", @"latitude", @"longitude", @"roll", @"read", nil];
    NSArray *sentobjs = [NSArray arrayWithObjects:user, message, [NSNumber numberWithDouble:location.latitude], [NSNumber numberWithDouble:location.longitude], [NSNumber numberWithDouble:roll], [NSNumber numberWithBool:false], nil];
    NSArray *recvobjs = [NSArray arrayWithObjects:fromUser, message, [NSNumber numberWithDouble:location.latitude], [NSNumber numberWithDouble:location.longitude], [NSNumber numberWithDouble:roll], [NSNumber numberWithBool:false], nil];
    NSDictionary *sentdict = [NSDictionary dictionaryWithObjects:sentobjs forKeys:sentkeys];
    NSDictionary *recvdict = [NSDictionary dictionaryWithObjects:recvobjs forKeys:recvkeys];
    
    // Push to Firebase
    [sentfb push:sentdict];
    [recvfb push:recvdict];
}

- (void)loadReceivedFromFirebase:(NSString *)user
                    withCallback:(fbCallback)callback
{
    [recvfb on:FEventTypeValue doCallback:callback];
}

@end
