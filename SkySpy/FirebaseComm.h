//
//  FirebaseComm.h
//  SkySpy
//
//  Created by Jim Liu on 3/2/13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>

#define FIREBASE_ADDR   @"https://skyspytest.firebaseio.com/"

typedef void (^fbCallback)(FDataSnapshot *snapshot);

@interface FirebaseComm : NSObject

@property (strong) NSMutableArray *drops;

- (void)initRecvFirebase:(NSString *)user;
- (void)pushToFirebase:(NSString *)fromUser
                toUser:(NSString *)user
            withMessage:(NSString *)message
        withLocation:(CLLocationCoordinate2D)location
            withRoll:(double)roll;
- (void)loadReceivedFromFirebase:(NSString *)user
                    withCallback:(void (^) (FDataSnapshot *snapshot))callback;

@end
