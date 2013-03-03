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

- (id)init
{
    self = [super init];
    if (self) {
        self.drops = [[NSMutableArray alloc] init];
    }
    
    return self;
}

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
              withDate:(NSDate *)date
          withLocation:(CLLocationCoordinate2D)location
              withRoll:(double)roll
{
    // Build the path for sender/receiver
    NSMutableString *sentPath = [[NSMutableString alloc] initWithString:FIREBASE_ADDR];
    [sentPath appendString:fromUser];
    [sentPath appendString:@"/sent"];
    Firebase *sentfb = [[Firebase alloc] initWithUrl:sentPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *formattedTimeString = [dateFormatter stringFromDate:date];
    
    // Populate dictionaries
    NSArray *sentkeys = [NSArray arrayWithObjects:@"to", @"date", @"time", @"message", @"latitude", @"longitude", @"roll", @"read", nil];
    NSArray *recvkeys = [NSArray arrayWithObjects:@"from", @"date", @"time", @"message", @"latitude", @"longitude", @"roll", @"read", nil];
    NSArray *sentobjs = [NSArray arrayWithObjects:user, formattedDateString, formattedTimeString, message, [NSNumber numberWithDouble:location.latitude], [NSNumber numberWithDouble:location.longitude], [NSNumber numberWithDouble:roll], [NSNumber numberWithBool:false], nil];
    NSArray *recvobjs = [NSArray arrayWithObjects:fromUser, formattedDateString, formattedTimeString, message, [NSNumber numberWithDouble:location.latitude], [NSNumber numberWithDouble:location.longitude], [NSNumber numberWithDouble:roll], [NSNumber numberWithBool:false], nil];
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
