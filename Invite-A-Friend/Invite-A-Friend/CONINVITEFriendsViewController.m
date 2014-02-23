//
//  CONINVITEFriendsViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 19/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFriendsViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#include "FriendFeedCell.h"

@interface CONINVITEFriendsViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoadingIndicator;

@end

@implementation CONINVITEFriendsViewController
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
	
	NSArray *allTweets = [results objectForKey:@"feed"];
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

    
    
    //setfonts
    _UserEventsAttended.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserFriendCount.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserEventInvites.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserName.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserTwitterName.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    
    
    
}

- (void)getProfileColourImage{

    
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [defaults objectForKey:@"Con96TUID"];
    
    
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", UID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *userInfo = [json valueForKey:@"user"];
    
    
    NSArray *countInfo = [json valueForKey:@"counts"];
    
    NSString *twitterusername = [userInfo valueForKey:@"username"];
    
    NSString *profilecolour = [userInfo valueForKey:@"colour"];
    
    if ([profilecolour  isEqual: @"red"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"red-profile@2.png"];
    } else if ([profilecolour  isEqual: @"green"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"green-profile@2.png"];
    } else if ([profilecolour  isEqual: @"purple"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"purple@2.png"];
    } else if ([profilecolour  isEqual: @"pink"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"pink@2.png"];
    } else if ([profilecolour  isEqual: @"blue"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"blue-profile@2.png"];
    }
    
    
    
    

    
    _UserName.text = [userInfo valueForKey:@"full_name"];
    _UserTwitterName.text = [NSString stringWithFormat:@"@%@",twitterusername];
    NSString *eventinvites = [countInfo valueForKey:@"event_invites_pending"];
    _UserEventInvites.text = [NSString stringWithFormat:@"%@",eventinvites];;

    

    NSString *eventsattended = [countInfo valueForKey:@"events_attended"];
    _UserEventsAttended.text = [NSString stringWithFormat:@"%@",eventsattended];;

    
    _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo valueForKey:@"image_url"]]]];
    

}

- (void)loadFeed {
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

    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/feed/%@",UID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder];

}

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
    static NSString *simpleTableIdentifier = @"FriendFeedCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSString *action = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"action"];
    NSString *outputAction = @"";
    NSString *atribute = [[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"];
    if([action isEqualToString:@"friend added"]) {
        outputAction = [NSString stringWithFormat:@"%@ added %@ as a Friend", _UserName.text, atribute];
    }
    
    cell.nameLabel.text = _UserName.text;
	cell.nameLabel.adjustsFontSizeToFitWidth = YES;
	cell.nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
	cell.nameLabel.numberOfLines = 2;
    cell.twitternameLabel.text = outputAction;
	cell.twitternameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    
    /*NSString *urlString = [[tweets objectAtIndex:indexPath.row] objectForKey:@"image_thumbnail"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLResponse *response;
    NSError *error;
    NSData *rawImage = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // cell.imageView.image = [UIImage imageNamed:@"friendback.png"];
    cell.imageView.image = [UIImage imageWithData:rawImage];*/
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0f;
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
    // Pass the selected object to the new view controller.
    NSString *UID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UID forKey:@"Con96FID"];
    [defaults setObject:AID forKey:@"Con96FAID"];
    [defaults synchronize];
    
    //Navigation logic may go here. Create and push another view controller.
    
    [self  performSegueWithIdentifier:@"showFriend" sender:self];
    
}


- (void)viewDidAppear:(BOOL)animated{

    
    
    [self viewDidLoad];
    [self loadFeed];
    [self getProfileColourImage];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *UID = [defaults objectForKey:@"Con96TUID"];
    //Get number of friends info
    
    NSURL *friendurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", UID]];
    
    NSMutableURLRequest *frequest = [NSMutableURLRequest requestWithURL:friendurl];
    
    [frequest setURL:friendurl];
    [frequest setHTTPMethod:@"GET"];
    [frequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *fresponse;
    NSData *fjsondata = [NSURLConnection sendSynchronousRequest:frequest returningResponse:&fresponse error:&error];
    NSArray *friendsjson = [NSJSONSerialization JSONObjectWithData:fjsondata options:NSJSONReadingAllowFragments error:nil];
    
            NSArray *countInfo = [friendsjson valueForKey:@"counts"];
    
    NSString *friendscount = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"friends"]];;
    [_UserFriendCount setTitle:friendscount forState:UIControlStateNormal];
}

- (IBAction)searchPress:(UIButton*)sender {
        [self  performSegueWithIdentifier:@"searchFriends" sender:self];
}

- (IBAction)editpress:(id)sender {
        [self  performSegueWithIdentifier:@"editprofile" sender:self];
}

- (IBAction)listfriends:(id)sender {
            [self  performSegueWithIdentifier:@"showFriends" sender:self];
}
@end
