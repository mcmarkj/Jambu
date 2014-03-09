//
//  CONINVITEViewFriendViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 02/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEViewFriendViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#include "FriendFeedCell.h"


@interface CONINVITEViewFriendViewController ()
@property (strong, nonatomic) IBOutlet UIButton *addedButton;
- (IBAction)addFriend:(id)sender;
@end

@implementation CONINVITEViewFriendViewController
@synthesize tweets;
@synthesize searchBar;
@synthesize tableV;
@synthesize responseData;
- (IBAction)deleteFriend:(id)sender {
    [self showConfirmAlert];
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



- (IBAction)addFriend:(id)sender {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships%@", @""]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    NSString *AID = [defaults objectForKey:@"Con96FAID"];

    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: MID, @"user_id", AID, @"friend_id",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"{\"friendship\":%@}",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
                            NSLog(@"JSON Output : %@", finaldata);
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    [connection start];
    NSLog(@"Completed API Request");
    NSString *addedmessage = [NSString stringWithFormat:@"You're now following %@", _UserName.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follower Added"
                                                    message:addedmessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert performSelectorOnMainThread:@selector(show)
                            withObject:nil
                         waitUntilDone:NO];
    
    addFriend.hidden=YES;
    _addedButton.hidden=NO;
    
};


- (IBAction)deleteFriendReq{
    

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *FriendID = [defaults objectForKey:@"ConFriendshipID"];
    NSString *AlterID = [NSString stringWithFormat:@"%@", FriendID];
    
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships/%@", AlterID]];
        NSLog(@"URL : %@", url);
    //NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    //NSError *error;
    
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@", @""];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSLog(@"JSON Output : %@", editeddata);
    
    [request setURL:url];
    [request setHTTPMethod:@"DELETE"];
   // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    [connection start];
    NSLog(@"Completed API Request");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted"
                                                    message:@"Deleted Follower"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert performSelectorOnMainThread:@selector(show)
                            withObject:nil
                         waitUntilDone:NO];
    
    addFriend.hidden=YES;
    
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showConfirmAlert
{
    NSString *deletemessage = [NSString stringWithFormat:@"Do you want to stop following %@?", _UserName.text];
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Stop Following?"];
    [alert setMessage:deletemessage];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Yes, do something
        NSLog(@"I've been told to delete them as a friend");
        [self deleteFriendReq];
        addFriend.hidden=NO;
        _addedButton.hidden=YES;
    }
    else if (buttonIndex == 1)
    {
        //Do nothing...
    }
}



-(void)checkIfFriends{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *AID = [defaults objectForKey:@"Con96FAID"];
    NSString *MIS = [defaults objectForKey:@"Con96AID"];
    
    NSURL *friendsurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships/%@", MIS]];
    NSMutableURLRequest *friendsrequest = [NSMutableURLRequest requestWithURL:friendsurl];
    
    [friendsrequest setURL:friendsurl];
    [friendsrequest setHTTPMethod:@"GET"];
    [friendsrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *friendsresponse;
    NSData *friendsdata = [NSURLConnection sendSynchronousRequest:friendsrequest returningResponse:&friendsresponse error:&error];
    NSArray *friendsjson = [NSJSONSerialization JSONObjectWithData:friendsdata options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"JSON Output : %@", friendsjson);
    NSLog(@"From URL : %@", friendsurl);
    
    
    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:friendsdata options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *results = [responseJSON valueForKey:@"friendships"];
    NSArray *friends = [results valueForKey:@"id"];
//    NSDictionary *idresults = [responseJSON valueForKey:@"friendshipids"];
  //  NSArray *friendsids = [idresults valueForKey:@"id"];
    
    
    
    BOOL isTheObjectThere = [friends containsObject:AID];
    
    NSString *altID1 = [NSString stringWithFormat:@"%@", AID];
    NSString *altID2 = [NSString stringWithFormat:@"%@", MIS];
    
    if (isTheObjectThere) {
        NSLog(@"Friend Exists");
        addFriend.hidden = YES;
        _addedButton.hidden = NO;
        
    } else {
            if ([altID1 isEqualToString:altID2]) {
                addFriend.hidden = YES;
                _addedButton.hidden = YES;
                } else {
            NSLog(@"Friend Doesn't Exist");
            _addedButton.hidden = YES;
            addFriend.hidden = NO;
                        }
            }
    
    
    /* if ([[results objectForKey:@"id"] isEqualToString:AID]) {
     
     NSLog(@"Friend Exists");
     } else {
     NSLog(@"Friend Doesn't Exist");
     } */



    
}

- (void)viewDidAppear:(BOOL)animated{
    [self checkIfFriends];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  NSString *AID = [defaults objectForKey:@"Con96FAID"];
    //    NSString *MIS = [defaults objectForKey:@"Con96AID"];
        NSString *UID = [defaults objectForKey:@"Con96FID"];
    NSString *MID = [defaults objectForKey:@"Con96TUID"];
    //Get number of friends info
    
    NSURL *friendurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@?requestor=%@", UID, MID]];
                        

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



- (void)viewDidLoad
{
    [super viewDidLoad];
     //   [self checkIfFriends];
    [self loadFeed];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [defaults objectForKey:@"Con96FID"];
       NSString *MIS = [defaults objectForKey:@"Con96AID"];
        NSString *FID = [defaults objectForKey:@"Con96FAID"];
        NSString *MID = [defaults objectForKey:@"Con96TUID"];
    
    NSString *altID1 = [NSString stringWithFormat:@"%@", FID];
    NSString *altID2 = [NSString stringWithFormat:@"%@", MIS];
    
       NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@?requestor=%@", UID, MID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"The url we're requesting from is: %@", url);
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *userInfo = [json valueForKey:@"user"];
    
    
    NSArray *countInfo = [json valueForKey:@"counts"];
    NSArray *friendidinfo = [json valueForKey:@"friend_id"];

    NSString *twitterusername = [userInfo valueForKey:@"username"];
    
    NSString *profilecolour = [userInfo valueForKey:@"colour"];
    
    NSString *friendID = [userInfo valueForKey:@"id"];
    [defaults setObject:friendID forKey:@"Con96FAID"];
    [defaults synchronize];

    NSString *friendshipID = [NSString stringWithFormat:@"%@", [json valueForKey:@"friend_id"]];
    
    if([friendshipID isEqual: @"NULL"]){
        //not friends
        NSLog(@"Not friends");
        if ([altID1 isEqualToString:altID2]) {
            addFriend.hidden = YES;
            _addedButton.hidden = YES;
        } else {
            NSLog(@"Friend Doesn't Exist");
            _addedButton.hidden = YES;
            addFriend.hidden = NO;
        }
    } else {
        //friends
        NSLog(@"Friends!!");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:friendshipID forKey:@"ConFriendshipID"];
        [defaults synchronize];
        NSLog(@"Friend Exists");
        addFriend.hidden = YES;
        _addedButton.hidden = NO;
    }
    
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
    
    
    
    _UserName.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserTwitterName.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    NSString *usersName = [userInfo valueForKey:@"full_name"];
    
    if ([altID2 isEqualToString:altID1]) {
    _UserName.text = [NSString stringWithFormat:@"%@ (you)",usersName];
    } else {
        _UserName.text = [userInfo valueForKey:@"full_name"];
    }
        _UserTwitterName.text = [NSString stringWithFormat:@"@%@",twitterusername];
        NSString *eventinvites = [countInfo valueForKey:@"event_invites_pending"];
        _UserEventInvites.text = [NSString stringWithFormat:@"%@",eventinvites];;
    _UserEventInvites.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserFriendCount.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
        NSString *eventsattended = [countInfo valueForKey:@"events_attended"];
    _UserEventsAttended.text = [NSString stringWithFormat:@"%@",eventsattended];;
    _UserEventsAttended.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    
    _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo valueForKey:@"image_url"]]]];

    _friendlabel1.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _friendlabel2.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _friendlabel3.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];

    
    
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
    NSString *UID = [defaults objectForKey:@"Con96FID"];
    
    
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
    
    
    FriendFeedCell *cell = (FriendFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *action = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"action"];
    NSString *actionname = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"name"];
    NSString *outputAction = @"";
    NSString *atribute = [[tweets objectAtIndex:indexPath.row] objectForKey:@"argument"];
    if([action isEqualToString:@"friend added"]) {
        outputAction = [NSString stringWithFormat:@"%@ added %@ as a friend", _UserName.text, actionname];
    } else if([action isEqualToString:@"user updated"]) {
        outputAction = [NSString stringWithFormat:@"%@ Updated their profile", _UserName.text];
    } else if([action isEqualToString:@"event created"]) {
        outputAction = [NSString stringWithFormat:@"%@ created an event \"%@\"", _UserName.text, actionname];
    } else if([action isEqualToString:@"event created"]) {
        outputAction = [NSString stringWithFormat:@"%@ updated their event \"%@\"", _UserName.text, actionname];
    } else if([action isEqualToString:@"user created"]) {
        outputAction = [NSString stringWithFormat:@"%@ signed up to project invite", _UserName.text];
    }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", _UserName.text, @""];
	cell.nameLabel.adjustsFontSizeToFitWidth = YES;
	cell.nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    cell.twitterUserName.text = _UserTwitterName.text;
    cell.twitterUserName.adjustsFontSizeToFitWidth = YES;
	cell.twitterUserName.font = [UIFont fontWithName:@"Roboto-Light" size:10];
	cell.nameLabel.numberOfLines = 2;
    cell.twitternameLabel.text = outputAction;
	cell.twitternameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
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
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchPress:(UIButton*)sender {
    [self  performSegueWithIdentifier:@"searchFriends" sender:self];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showFriends:(id)sender {
    
    [self  performSegueWithIdentifier:@"showFriendsFriends" sender:self];
}
@end