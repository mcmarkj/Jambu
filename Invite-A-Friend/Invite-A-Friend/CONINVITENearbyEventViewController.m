//
//  CONINVITENearbyEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 07/03/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITENearbyEventViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#include "EventListCell.h"

@interface CONINVITENearbyEventViewController ()
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *searchDistanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;

@end
CLLocationManager *locationManager;
@implementation CONINVITENearbyEventViewController
@synthesize tweets;
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

/*- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [tableV setUserInteractionEnabled:NO];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/nearby_events %@",@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];
}
*/
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
   // [indicator release];
    indicator = nil;
    
    //[responseData release];
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
    
    
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _searchLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _distanceLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:14];
    
    int sliderValue = _searchDistanceSlider.value;
    
    if(sliderValue == 25){
        
            _distanceLabel.text = [NSString stringWithFormat:@"%d+ Miles", sliderValue];
        
    }else{
    
    
    _distanceLabel.text = [NSString stringWithFormat:@"%d Miles", sliderValue];
    }
    
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
	// Do any additional setup after loading the view.

    
    NSString *longa = [NSString stringWithFormat:@"%f", longitude];
    
    NSString *lata = [NSString stringWithFormat:@"%f", latitude];
    
    NSString *sliderV = [NSString stringWithFormat:@"%d", sliderValue];
    
    
    NSString *submit = [NSString stringWithFormat:@"lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    
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
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/nearby_events?lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];
    
}



- (IBAction)sliderChanged:(id)sender {
    int sliderValue = _searchDistanceSlider.value;
    if(sliderValue == 25){
        
        _distanceLabel.text = [NSString stringWithFormat:@"%d+ Miles", sliderValue];
        
    }else{
        
        
        _distanceLabel.text = [NSString stringWithFormat:@"%d Miles", sliderValue];
    }

    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
	// Do any additional setup after loading the view.
    
    
    NSString *longa = [NSString stringWithFormat:@"%f", longitude];
    
    NSString *lata = [NSString stringWithFormat:@"%f", latitude];
    
    NSString *sliderV = [NSString stringWithFormat:@"%d", sliderValue];
    
    
   /* NSString *submit = [NSString stringWithFormat:@"lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    
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
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/nearby_events?lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];*/
    
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
    cell.eventTime.text = [NSString stringWithFormat:@"@%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"time_of_event"]];
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

- (IBAction)updateDistance:(id)sender {
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
	// Do any additional setup after loading the view.
    
    
    NSString *longa = [NSString stringWithFormat:@"%f", longitude];
    
    NSString *lata = [NSString stringWithFormat:@"%f", latitude];
    int sliderValue = _searchDistanceSlider.value;
    
    NSString *sliderV = [NSString stringWithFormat:@"%d",sliderValue];
    
    
    NSString *submit = [NSString stringWithFormat:@"lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    
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
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/nearby_events?lat=%@&long=%@&distance=%@",lata, longa, sliderV];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(void)dealloc{
    [tweets release];
    [responseData release];
    [indicator release];
    [super dealloc];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
