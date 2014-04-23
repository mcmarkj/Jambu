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
#include "CustomFriendCells.h"

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
	
	NSArray *allTweets = [results objectForKey:@"friendships"];
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
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *UID = [defaults objectForKey:@"Con96FAID"];
   // NSString *FUID = UID;
    
    NSURL *searchString = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/nearby_events%@", @""]];
    
    
    NSString *longa = [NSString stringWithFormat:@"%f", longitude];
    
    NSString *lata = [NSString stringWithFormat:@"%f", latitude];
    
    NSString *sliderV = [NSString stringWithFormat:@"%d", sliderValue];
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: lata,  @"lat", longa, @"long", sliderV, @"distance",  nil];
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    
   // NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
   // NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Here's the output for the JSON:");
    NSLog(@"%@", newDatasetInfo);

    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:searchString];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // DISABLED WHILE WE CONFIGURE STUFF
    NSLog(@"We're now collecting to the API");
    [connection start];
    
    
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
    
    
    static NSString *simpleTableIdentifier = @"CustomFriendCells";
    
    CustomFriendCells *cell = (CustomFriendCells *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomFriendCells" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"full_name"];
	cell.nameLabel.adjustsFontSizeToFitWidth = YES;
	cell.nameLabel.font = [UIFont fontWithName:@"Roboto-Black" size:20];
    
	cell.nameLabel.numberOfLines = 2;
    //cell.nameLabel.textColor = [UIColor colorWithRed:17.0f/255.0f green:85.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    cell.twitternameLabel.text = [NSString stringWithFormat:@"@%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"username"]];
	cell.twitternameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    
    NSString *urlString = [[tweets objectAtIndex:indexPath.row] objectForKey:@"image_thumbnail"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLResponse *response;
    NSError *error;
    NSData *rawImage = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //_UserImage.image = [UIImage imageWithData:rawImage];
    
    cell.thumbnailImageView.image = [UIImage imageWithData:rawImage];
    //cell.imageView.image = [UIImage imageNamed:@"searchcircle.png"];
    
    
    int rownum = indexPath.row;
    int totnum = [tweets count] - 1;
    
    if(rownum == totnum){
        
        static NSString *simpleTableIdentifier = @"friendfeedcell";
        
        CustomFriendCells *cell = (CustomFriendCells *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendFeedCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        // Reset previous content of the cell, I have these defined in a UITableCell subclass, change them where needed
        // Here we create the ‘Load more’ cell
        
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
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
