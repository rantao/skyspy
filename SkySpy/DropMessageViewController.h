//
//  DropMessageViewController.h
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropMessageViewController : UIViewController

@property (nonatomic, strong) NSString *fromUser;
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSString *message;

@end
