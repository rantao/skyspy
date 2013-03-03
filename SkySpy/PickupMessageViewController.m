//
//  PickupMessageViewController.m
//  SkySpy
//
//  Created by Ran Tao on 3.2.13.
//  Copyright (c) 2013 Ran Tao. All rights reserved.
//

#import "PickupMessageViewController.h"
#import "FirebaseComm.h"
#import "MessageTableCell.h"
#import "MessageMapViewController.h"
#import "DropMessageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PickupMessageViewController () <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *messageMaps;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
//@property (nonatomic, strong) MKMapView *map;
@end

@implementation PickupMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.messages = [NSMutableArray new];
        [self getAllMessages];
        

        
    }
    return self;
}

- (void) getUUId {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    self.userId =  uuidString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageTable_bg.png"]];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.hidden = YES;
    [self getUUId];
    self.semaphore = dispatch_semaphore_create(0);

    self.messageMaps = [NSMutableArray new];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    [hud showAnimated:YES
  whileExecutingBlock:^(void)
    {
        [self getAllMessages];
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }
      completionBlock:^(void)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateMapViews];
            [self.messageTableView reloadData];
            self.messageTableView.hidden = NO;
        });
    }];
}

- (void)populateMapViews
{
    for (int i = 0; i < self.messages.count; i++) {
        CLLocationCoordinate2D messageLocation = CLLocationCoordinate2DMake([[[self.messages objectAtIndex:i] objectForKey:@"latitude"] doubleValue], [[[self.messages objectAtIndex:i] objectForKey:@"longitude"] doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(messageLocation, 1000, 1000);
        MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        [map setRegion:region animated:NO];
        map.scrollEnabled = NO;
        map.zoomEnabled = NO;
        [self.messageMaps addObject:map];
    }
}

- (void) getAllMessages {
    FirebaseComm *fbc = [[FirebaseComm alloc] init]; 
     [fbc initRecvFirebase:@"Ran"];
    fbc.drops = [NSMutableArray new];
     
     fbCallback callback = ^(FDataSnapshot *snapshot) {
         NSDictionary *recv = [snapshot val];
         for (NSString *key in recv) {
             if (![fbc.drops containsObject:[recv objectForKey:key]]) {
                 NSLog(@"Added %@\n", [recv objectForKey:key]);
                 //[fbc.drops addObject:[recv objectForKey:key]];
                 [fbc.drops addObject:[recv objectForKey:key]];

             }
         }
         
         
         self.messages = fbc.drops;
         //[self populateMapViews];
         //[self.messageTableView reloadData];
         //self.messageTableView.hidden = NO;
         dispatch_semaphore_signal(self.semaphore);
     };
     
     [fbc loadReceivedFromFirebase:@"Ran" withCallback:callback];
     
    //return fbc.drops;
}

-(void) renderMapView {
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    // Return the number of sections.
    //self.messages = [self getAllMessages];
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    NSInteger row = [indexPath row];
//    UITableViewCell *cell = nil;
//    if( row != kMapCellRow ) { // defined value to whatever value it may be
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    }
//    else {
//        // use an ivar to track the map cell, should be set to nil in class init
//        cell = _mapCell;
//    }
//    if (cell == nil) {
//        if( row != kMapCellRow ) { // defined value to whatever value it may be
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        }
//        else {
//            // create your map cell here
//            cell = [[[MyTableViewMapCell alloc] init];
//        }
    
    
    
    static NSString *CellIdentifier = @"Cell";
    MessageTableCell *cell = (MessageTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
        
    //use custom cell layout
    cell.dateLabel.text = (NSString*)[[self.messages objectAtIndex:[indexPath row]] objectForKey:@"date"];
    cell.timeLabel.text = (NSString*)[[self.messages objectAtIndex:[indexPath row]] objectForKey:@"time"];
    MKMapView *currentMap = [self.messageMaps objectAtIndex:indexPath.row];
    cell.messageMapView.region = currentMap.region;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    MessageMapViewController *messageMapViewController = [MessageMapViewController new];
    
    MKMapView *currentMap = [self.messageMaps objectAtIndex:indexPath.row];
    NSString *messageDate = (NSString*)[[self.messages objectAtIndex:[indexPath row]] objectForKey:@"date"];
    NSString *messageTime = (NSString*)[[self.messages objectAtIndex:[indexPath row]] objectForKey:@"time"];
    NSLog(@"indexpath row is: %ld\nmessageDate is: %@\nmessageTime is: %@",(long)indexPath.row, messageDate, messageTime);

    messageMapViewController.date = messageDate;
    messageMapViewController.time = messageTime;
    messageMapViewController.mapCenter = currentMap.centerCoordinate;
    [self presentViewController:messageMapViewController animated:YES completion:nil];
    
}


- (IBAction)dropButtonPressed:(UIButton *)sender {
    DropMessageViewController *dropMessageViewController = [DropMessageViewController new];
    [self presentViewController:dropMessageViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
