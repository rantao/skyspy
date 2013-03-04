//
//  ContactsViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.3.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "ContactsViewController.h"
#import "MapAnnotation.h"
#import <MessageUI/MFMessageComposeViewController.h>


@interface ContactsViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.messageLabel.text = self.message;
    self.messageLabel.font = [UIFont fontWithName:@"Renegade Master" size:20];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 1000, 1000);
    MapAnnotation *messageAnnotation = [MapAnnotation new];
    messageAnnotation.coordinate = self.location;
    [self.userMapView addAnnotation:messageAnnotation];
    [self.userMapView setRegion:region animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactPickerButtonPressed:(UIButton *)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
    // open SMS/Message interface
    // ideally we would skip this and send automatically via Twilio or some other messaging API
    [self sendSMS:[NSString stringWithFormat:@"Pick up a secret message I dropped for you at this location: http://ephexi.com/skyspy/%@",self.phoneNumber] recipientList:[NSArray arrayWithObjects:self.phoneNumber, nil]];

}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller =[MFMessageComposeViewController new];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }else {
        NSLog(@"Message failed");
    }
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self displayPerson:person];
//    self.sendButton.enabled = YES;
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"person is %@, property is %d, identifier is %d", person, property, identifier);
    ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
	NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
    self.contactPickerButton.titleLabel.text = [NSString stringWithFormat:@"TO: %@ %@",firstName, lastName];
	self.phoneNumber = phone;
	self.sendButton.enabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
	return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);

    self.contactPickerButton.titleLabel.text = [NSString stringWithFormat:@"TO: %@ %@",firstName, lastName];
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
   

    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        NSLog(@"# of phone numbers: %ld", ABMultiValueGetCount(phoneNumbers));
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.phoneNumber = phone;
    CFRelease(phoneNumbers);
}

@end
