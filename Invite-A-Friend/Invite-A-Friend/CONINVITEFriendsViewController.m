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
@property (strong, nonatomic) IBOutlet UIPageControl *pageDot;

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

   /*
    //Start Swipe Viewer Setup
    
    // Create the data model
    _pageTitles = @[@"   ", @"Create Events Invite Friends..."];
    _pageImages = @[@"red-profile.png", @"red-bio.png"];
    
    

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 290);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [_pageImages retain];
    [_pageTitles retain];
// End swipeviewer setup*/
    
    
    //setfonts
    _UserEventsAttended.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserFriendCount.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserEventInvites.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserName.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserTwitterName.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    _profilelabel1.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        _profilelabel2.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        _profilelabel3.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _toptitle.font = [UIFont fontWithName:@"Roboto-Light" size:20];
}
/*
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    if (index == 1){
        NSLog(@"Bla Bla Bla 2nd view");
        pageContentViewController.nameText = @"";
        pageContentViewController.twitterText = @"";
        
    } else {
    
            pageContentViewController.nameText = @"Mark McWhirter";
            pageContentViewController.twitterText = @"@officialmarkm";
            
        
    }
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.user_image = _UserImage.self;

    


    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
    [_pageImages retain];
    [_pageTitles retain];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    

    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    
    
    index--;
    return [self viewControllerAtIndex:index];
    [_pageImages retain];
    [_pageTitles retain];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    NSLog(@"Index: %lu", (unsigned long)index);

    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    [_pageImages retain];
    [_pageTitles retain];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
    [_pageImages retain];
    [_pageTitles retain];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
    [_pageImages retain];
    [_pageTitles retain];
}*/

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
        _profilecolourimage.image = [UIImage imageNamed:@"red-profile@2x.png"];
    } else if ([profilecolour  isEqual: @"green"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"green-profile@2x.png"];
    } else if ([profilecolour  isEqual: @"purple"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"purple@2x.png"];
    } else if ([profilecolour  isEqual: @"pink"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"pink@2x.png"];
    } else if ([profilecolour  isEqual: @"blue"]) {
        _profilecolourimage.image = [UIImage imageNamed:@"blue-profile@2x.png"];
    }
    
    
    
    

    
    _UserName.text = [userInfo valueForKey:@"full_name"];
    _UserTwitterName.text = [NSString stringWithFormat:@"@%@",twitterusername];
    NSString *eventinvites = [countInfo valueForKey:@"events_created"];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//Configuring cell design upon request from table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendFeedCell";

    
    FriendFeedCell *cell = (FriendFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSString *action = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"action"];
        NSString *actionname = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"name"];
    NSString *outputAction = @"";
   // NSString *atribute = [[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"];
    if([action isEqualToString:@"friend added"]) {
        outputAction = [NSString stringWithFormat:@"%@ added %@ as a friend", _UserName.text, actionname];
    } else if([action isEqualToString:@"user updated"]) {
         outputAction = [NSString stringWithFormat:@"%@ Updated their profile", _UserName.text];
    } else if([action isEqualToString:@"event created"]) {
        outputAction = [NSString stringWithFormat:@"%@ created an event \"%@\"", _UserName.text, actionname];
    } else if([action isEqualToString:@"event created"]) {
        outputAction = [NSString stringWithFormat:@"%@ updated their event \"%@\"", _UserName.text, actionname];
    } else if([action isEqualToString:@"user created"]) {
        outputAction = [NSString stringWithFormat:@"%@ created his account", _UserName.text];
    } else if([action isEqualToString:@"joined event"]) {
        outputAction = [NSString stringWithFormat:@"%@ is attending an event", _UserName.text];
    } else if([action isEqualToString:@"attendee updated"]) {
        outputAction = [NSString stringWithFormat:@"%@ is attending an event", _UserName.text];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", _UserName.text, @""];
	cell.nameLabel.adjustsFontSizeToFitWidth = YES;
	cell.nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    cell.twitterUserName.text = _UserTwitterName.text;
    cell.twitterUserName.adjustsFontSizeToFitWidth = YES;
	cell.twitterUserName.font = [UIFont fontWithName:@"Roboto-Light" size:10];
	cell.nameLabel.numberOfLines = 2;
    cell.twitternameLabel.text = outputAction;
	cell.twitternameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:8];
    cell.thumbnailImageView.image = _UserImage.image;
    
    
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
	return 61;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 /*// Override to support editing the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *action = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"action"];
    
    
    // Pass the selected object to the new view controller.

    
    //Navigation logic may go here. Create and push another view controller.
    
    if([action isEqualToString:@"friend added"]) {
        NSString *UID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"]];
        NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UID forKey:@"Con96FID"];
        [defaults setObject:AID forKey:@"Con96FAID"];
        [defaults synchronize];
        [self  performSegueWithIdentifier:@"feedFriend" sender:self];
    } else if([action isEqualToString:@"joined event"]) {
        NSString *eventID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"]];
        //NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:eventID forKey:@"CON96EventID"];
        // [defaults setObject:AID forKey:@"Con96FAID"];
        [defaults synchronize];
        
        //Navigation logic may go here. Create and push another view controller.
        
        [self  performSegueWithIdentifier:@"showEvent" sender:self];

    } else if([action isEqualToString:@"event created"]) {
        NSString *eventID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"]];
        //NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:eventID forKey:@"CON96EventID"];
        // [defaults setObject:AID forKey:@"Con96FAID"];
        [defaults synchronize];
        
        //Navigation logic may go here. Create and push another view controller.
        
        [self  performSegueWithIdentifier:@"showEvent" sender:self];
    }
    
    
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
