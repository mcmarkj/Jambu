//
//  CONINVITEListCreatedEventsViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 05/05/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEListCreatedEventsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#include "CustomFriendCells.h"
#include "EventListCell.h"

@interface CONINVITEListCreatedEventsViewController ()
- (IBAction)closeView:(id)sender;
@end
CLLocationManager *locationManager;
@implementation CONINVITEListCreatedEventsViewController
@synthesize tweets;
@synthesize friends;
@synthesize searchBar;
@synthesize tableV;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Called when user presses Search, sends query to server
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [tableV setUserInteractionEnabled:NO];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/owned_events/%@",@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] initWithLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

//Called when connection fails
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [tableV setUserInteractionEnabled:YES];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicator release];
    indicator = nil;
    
    [responseData release];
    responseData = nil;
    
}

//Called upon getting all requested data from server
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [tableV setUserInteractionEnabled:YES];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicator release];
    indicator = nil;
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    responseData = nil;
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *results = [json objectWithString:responseString error:&error];
    
    [responseString release];
	
	NSArray *allTweets = [results objectForKey:@"events"];
	[self setTweets:allTweets];
	[self.tableV reloadData];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    // Search bar
    searchBar.delegate = self;
    [searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    // Title
    self.title = @"Twitter search";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [tableV setUserInteractionEnabled:NO];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [defaults objectForKey:@"Con96TUID"];
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/owned_events/%@",UID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tweets count];
}


//Configuring cell design upon request from table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"EventListCell";
    
    EventListCell *cell = (EventListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventListCells" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.eventName.text = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"title"];
	cell.eventName.adjustsFontSizeToFitWidth = YES;
	cell.eventName.font = [UIFont fontWithName:@"Roboto-Light" size:20];
	cell.eventName.numberOfLines = 2;
    //cell.nameLabel.textColor = [UIColor colorWithRed:17.0f/255.0f green:85.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    NSString * timeStampString = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"time_of_event"]];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"HH:mm - dd/MM/yyyy"];
    NSString *finaldate=[_formatter stringFromDate:date];
    
    [_formatter release];
    cell.eventTime.text = finaldate;
	cell.eventTime.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    
    
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    float latitude1 = [[[tweets objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue];
    float long1 = [[[tweets objectAtIndex:indexPath.row] objectForKey:@"long"] floatValue];
    
    
    
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:latitude1 longitude:long1];
    
    float KMdistance = [location1 distanceFromLocation:location2]*0.000621371192;
    float metdistance = [location1 distanceFromLocation:location2];
    int meterdistance = (int)metdistance;
    
    int finaldistance = (int)KMdistance;
    if(finaldistance == 0) {
        //   NSString *finaldistance = @">5";
        cell.distanceLabel.text = [NSString stringWithFormat:@"%d meters away", meterdistance];
    } else {
        
        // float newDistance = ((KMdistance + 5)/10)*10;
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%d miles away", finaldistance];
    }
    
    cell.distanceLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    
    [location1 release];
    [location2 release];
    
    
    // NSString *urlString = [[tweets objectAtIndex:indexPath.row] objectForKey:@"image_thumbnail"];
    //   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //   NSURLResponse *response;
    //    NSError *error;
    //   NSData *rawImage = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //_UserImage.image = [UIImage imageWithData:rawImage];
    
    //cell.thumbnailImageView.image = [UIImage imageWithData:rawImage];
    //cell.imageView.image = [UIImage imageNamed:@"searchcircle.png"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *eventID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"id"]];
    //NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:eventID forKey:@"CON96EventID"];
    // [defaults setObject:AID forKey:@"Con96FAID"];
    [defaults synchronize];
    
    //Navigation logic may go here. Create and push another view controller.
    
    [self  performSegueWithIdentifier:@"showEvent" sender:self];
    
}

-(void)dealloc{
    [tweets release];
    [responseData release];
    [indicator release];
    [locationManager release];
    [super dealloc];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end