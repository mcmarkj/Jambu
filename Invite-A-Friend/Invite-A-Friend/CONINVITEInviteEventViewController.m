//
//  CONINVITEInviteEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 12/04/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEInviteEventViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#include "CustomFriendCells.h"

@interface CONINVITEInviteEventViewController ()


- (IBAction)inviteFollowers:(id)sender;
- (IBAction)closeView:(id)sender;

@end
    NSMutableArray *InviteArray;
    NSMutableArray *EditArray;
@implementation CONINVITEInviteEventViewController
- (IBAction)inviteFriends:(id)sender {
}

@synthesize tweets;
@synthesize friends;
@synthesize searchBar;
@synthesize tableV;
@synthesize responseData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships/%@",@""];
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
    EditArray = [[NSMutableArray alloc] init];
    _inviteUsers = [[NSMutableArray alloc] init];
    _inviteUsersNames = [[NSMutableArray alloc] init];
        // Search bar
    searchBar.delegate = self;
    [searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSArray *editArrays = [userdefaults valueForKey:@"CONInviteEdit"];
    
    if(editArrays == Nil)
    {
    } else {
    [EditArray addObjectsFromArray:editArrays];
    }
 
    
    NSLog(@"Edit Array: %@", EditArray);
    
  //  NSString *UID = [userdefaults objectForKey:@"Con96TUID"];
    
    /*
    if([_inviteUsers containsObject:UID]){
        NSLog(@"Contains UID");
    } else {
        
        [_inviteUsers addObject:[NSString stringWithFormat:@"%@",[userdefaults objectForKey:@"Con96TUID"]]];
        [_inviteUsersNames addObject:[userdefaults objectForKey:@"CON96users_name"]];
        
    }

    */
    
       [_inviteUsers addObjectsFromArray:[userdefaults objectForKey:@"CONInviteAlready"]];
           [_inviteUsersNames addObjectsFromArray:[userdefaults objectForKey:@"CONInviteAlreadyNames"]];
    
    NSLog(@"Current Invite Names: %@",_inviteUsersNames);
        NSLog(@"Current Invite UID: %@",_inviteUsers);
    
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
    NSString *AID = [userdefaults objectForKey:@"Con96AID"];
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships/%@",AID];
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
    
    static NSString *simpleTableIdentifier = @"CustomFriendCells";
    
    CustomFriendCells *cell = (CustomFriendCells *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomFriendCells" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.friends_button.hidden = YES;
    cell.not_friends.hidden = NO;
    
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
    
    
    //int rownum = indexPath.row;
    //int totnum = [tweets count] - 1;
    
    /*if(rownum == totnum){
        
        static NSString *simpleTableIdentifier = @"friendfeedcell";
        
        CustomFriendCells *cell = (CustomFriendCells *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendFeedCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        // Reset previous content of the cell, I have these defined in a UITableCell subclass, change them where needed
        // Here we create the ‘Load more’ cell
        
        
    }*/
    
    NSString *UID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    if([EditArray containsObject:UID]){
        
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.friends_button.hidden = NO;
        cell.not_friends.hidden=YES;
    } else {
        

    if([_inviteUsers containsObject:UID])
    {
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.friends_button.hidden = NO;
        cell.not_friends.hidden=YES;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    }
    
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
   NSString *UID = [NSString stringWithFormat:@"%@",[[tweets objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    NSString *AID = [[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString *name = [[tweets objectAtIndex:indexPath.row] objectForKey:@"full_name"];

    NSLog(@"Twitter UID: %@", UID);
    NSLog(@"API UserID: %@", AID);
    /*
   //NSMutableArray * InvitesArray = [NSMutableArray arrayWithArray:InviteArray];
    NSMutableArray *InviteArray = [[NSMutableArray alloc] init];


    [InviteArray addObject:UID];
    
    for (id obj in InviteArray) {
        NSLog(@"%@", obj);
    }
    NSLog(@"Object Added to Array");*/
    
    
    
    //UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([EditArray containsObject:UID]){
        NSLog(@"User has already been invited before");
    } else {
    
    if([_inviteUsers containsObject:UID]){
        [_inviteUsers removeObject:UID];
        [_inviteUsersNames removeObject:name];
        NSLog(@"IVC selectedIndexes RemoveObject @ %@:", UID);
        
        [self.tableV beginUpdates];
        
        
        
        [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableV endUpdates];

    } else {
        [_inviteUsers addObject:UID];
        [_inviteUsersNames addObject:name];
        NSLog(@"IVC selectedIndexes AddObject @ %@:", UID);
        NSLog(@"IVC selectedIndexes: %@", _inviteUsers);
        NSLog(@"IVC selectedNames: %@", _inviteUsersNames);
        
        [self.tableV beginUpdates];
        
        
        
        [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableV endUpdates];
        

    }
    }
    /*
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone) {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [_inviteUsers addObject:UID];
        [_inviteUsersNames addObject:name];
        NSLog(@"IVC selectedIndexes AddObject @ %@:", UID);
        NSLog(@"IVC selectedIndexes: %@", _inviteUsers);
        NSLog(@"IVC selectedNames: %@", _inviteUsersNames);
        
        [self.tableV beginUpdates];
        
        
        
        [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableV endUpdates];
        
        


    } else {

        [_inviteUsers removeObject:UID];
        [_inviteUsersNames removeObject:name];
        NSLog(@"IVC selectedIndexes RemoveObject @ %@:", UID);
        
        [self.tableV beginUpdates];
        
        
        
        [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableV endUpdates];
        
    }*/
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    
}
-(void)dealloc{
    [tweets release];
    [responseData release];
    [indicator release];
   // [InviteArray release];
    [super dealloc];
}

- (IBAction)inviteFollowers:(id)sender {
    //Save Array to NSUserDefaults
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(EditArray.count == 0){
        [defaults setObject:_inviteUsers forKey:@"CONInvitees"];
        [defaults setObject:_inviteUsers forKey:@"CONInviteAlready"];
        [defaults setObject:_inviteUsersNames forKey:@"ConInviteesNames"];
        [defaults setObject:_inviteUsersNames forKey:@"CONInviteAlreadyNames"];
        [defaults synchronize];
        
        NSLog(@"The following AID's were invited: %@", _inviteUsers);
        
        //Close View
        [self dismissViewControllerAnimated:YES completion:nil];

    } else {
        NSURL *attendurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/batch_attendees/%@", @""]];
        
        
        
    //    NSArray *inviteArrNames = [defaults objectForKey:@"CONInvitees"];
        
        
        
            NSString *event_id = [defaults objectForKey:@"CON96EventID"];
        
        
        //NSString *attendeesReg = [NSString stringWithFormat:@"[%@]", @""];
        
        NSDictionary *attendeesjson = [NSDictionary dictionaryWithObjectsAndKeys:  _inviteUsers, @"attendees" ,event_id, @"event_id", nil];
        NSError *error;
        
        
        NSData* attendeesjsonData = [NSJSONSerialization dataWithJSONObject:attendeesjson options:kNilOptions error:&error];
        
        NSString *attendeesjsonedit = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:attendeesjsonData encoding:NSUTF8StringEncoding]];
        
        NSData* finalattendees = [attendeesjsonedit dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *attendRequest = [[NSMutableURLRequest alloc] init];
        
        [attendRequest setURL:attendurl];
        [attendRequest setHTTPMethod:@"POST"];
        [attendRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [attendRequest setHTTPBody:finalattendees];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:attendRequest delegate:self];
        
        [connection start];
             [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    }

- (IBAction)closeView:(id)sender {
            NSLog(@"Array Contents - cleared: %@", _inviteUsers);
    [_inviteUsers removeAllObjects];
     NSLog(@"New contents: %@", _inviteUsers);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end