//
//  ContactsViewController.h
//  SkySpy
//
//  Created by Ran Tao on 3.3.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ContactsViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *contactPickerButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) CLLocationCoordinate2D location;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak,nonatomic) IBOutlet MKMapView *userMapView;
- (IBAction)contactPickerButtonPressed:(UIButton *)sender;
- (IBAction)sendButtonPressed:(UIButton *)sender;
@end
