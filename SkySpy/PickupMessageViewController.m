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
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PickupMessageViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSArray *messageMaps;
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
    [self getUUId];


    self.messageMaps = [NSArray new];
    for (int i=0; i < self.messages.count; i++) {
//        CLLocationCoordinate2D messageLocation = CLLocationCoordinate2DMake([[[self.messages objectAtIndex:i] objectForKey:@"latitude"] doubleValue], [[[self.messages objectAtIndex:i] objectForKey:@"longitude"] doubleValue]);
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(messageLocation, 100, 100);
//        MKMapView *map = [MKMapView new];
//        [map setRegion:region animated:NO];
        

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
         [self.messageTableView reloadData];
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
    
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MessageTableCell *cell = (MessageTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //instead use custom cell
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell...
    //NSMutableArray *messages = [self getAllMessages];
    //    cell.textLabel.text = [[secrets objectAtIndex:[indexPath row]] entry];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"EEEE MM.dd.yyyy 'at' hh:mm a"];
    //    NSString *stringFromDate = [formatter stringFromDate:[[secrets objectAtIndex:[indexPath row]] date]];
    //    cell.detailTextLabel.text = stringFromDate;
    //    cell.imageView.image = [UIImage imageWithData:[[secrets objectAtIndex:[indexPath row]] imageData]];
    
    //use custom cell layout
    cell.dateLabel.text = [[self.messages objectAtIndex:[indexPath section]] objectForKey:@"date"];
    cell.timeLabel.text = [[self.messages objectAtIndex:[indexPath section]] objectForKey:@"time"];
    //[self performSelectorOnMainThread:@selector(renderMapView)withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];

    CLLocationCoordinate2D messageLocation = CLLocationCoordinate2DMake([[[self.messages objectAtIndex:[indexPath section]] objectForKey:@"latitude"] doubleValue], [[[self.messages objectAtIndex:[indexPath section]] objectForKey:@"longitude"] doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(messageLocation, 100, 100);
    [cell.messageMapView setRegion:region animated:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
