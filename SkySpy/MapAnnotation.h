//
//  MapAnnotation.h
//  SkySpy
//
//  Created by Ran Tao on 3.3.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString* title;

@end
