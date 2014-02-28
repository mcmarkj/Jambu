//
//  SearchTableViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 02/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SearchTableViewController.h"
#import "JSON.h"
#include "CustomFriendCells.h"
@implementation SearchTableViewController
@synthesize tweets;
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    searchText = self.searchBar.text;
    
    if (searchText.length >= 4) {
       int resultscount = 0;
    
    [tableV setUserInteractionEnabled:YES];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    NSLog(@"Search button pressed");
    NSString *search = self.searchBar.text;
        NSString *resultsstring = [NSString stringWithFormat:@"%d", resultscount];
        

        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (standardUserDefaults) {
            [standardUserDefaults setObject:[NSNumber numberWithInt:resultscount] forKey:@"resultscount"];
            [standardUserDefaults synchronize];
        }
        
        
        NSLog(@"results is now %@", resultsstring);
        
        NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/search/%@?results=%@", search, resultsstring];
    [searchString replaceOccurrencesOfString:@"@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
    /*[searchString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
     [searchString replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])]; */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //[self.searchBar resignFirstResponder];

    } else {
        
    }
    
    
    
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
    NSLog(@"Search button pressed");
    NSString *search = self.searchBar.text;

    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/search/%@", search];
        [searchString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
        [searchString replaceOccurrencesOfString:@"@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
    /*
     //Uncomment this line to make it so that it searches a different API for twitter usernames
    [searchString replaceOccurrencesOfString:@"@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];

    [searchString replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])]; */
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
	
	NSArray *allTweets = [results objectForKey:@"users"];
    
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


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    for (UIView *v in searchBar.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            ((UIControl *)v).enabled = YES;
        }
    }
    
    // Search bar
    searchBar.delegate = self;
    [searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    // Title
    self.title = @"Twitter search";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
   /* [tableV setUserInteractionEnabled:NO];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@",@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.searchBar resignFirstResponder]; */

    
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
    
    
    return [tweets count] + 1;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)nextsearch{
    [tableV setUserInteractionEnabled:YES];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(tableV.frame.size.width/2-50, tableV.frame.size.height/2-50, 100, 100)];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator setAlpha:0.7f];
    indicator.layer.cornerRadius = 10.0f;
    [self.tableV addSubview:indicator];
    [indicator startAnimating];
    NSLog(@"Search button pressed");
    NSString *search = self.searchBar.text;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

        NSString *resultscount = [standardUserDefaults objectForKey:@"resultscount"];
    
    

    


    
    int actualresult = [resultscount intValue];
    
    int nextresult = actualresult + 10;


    
    NSString *resultsstring = [NSString stringWithFormat:@"%d", nextresult];
        NSLog(@"results is now %d", nextresult);
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[NSNumber numberWithInt:nextresult] forKey:@"resultscount"];
        [standardUserDefaults synchronize];
    }
    
    NSMutableString *searchString = [NSMutableString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/search/%@?results=%@", search, resultsstring];
    [searchString replaceOccurrencesOfString:@"@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
    /*[searchString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
     [searchString replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])]; */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //[self.searchBar resignFirstResponder];
[self.tableV setContentOffset:CGPointZero animated:NO];

}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        NSLog(@"we're at the top mate");
        // then we are at the top
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        NSLog(@"we're at the bottom mate");
        int count = [tweets count];
        NSLog(@"@%", count);
        if(count >= 10) {
                    [self nextsearch];
        }
        
        
    }
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
    if([[[tweets objectAtIndex:[indexPath row]] objectForKey:@"colour"]  isEqual: @"blue"]) {
    [cell.backgroundColour setBackgroundColor:[self colorWithHexString:@"2fa6cd"]];
    } else if([[[tweets objectAtIndex:[indexPath row]] objectForKey:@"colour"]  isEqual: @"red"]) {
            [cell.backgroundColour setBackgroundColor:[self colorWithHexString:@"cb3635"]];
    } else if([[[tweets objectAtIndex:[indexPath row]] objectForKey:@"colour"]  isEqual: @"pink"]) {
            [cell.backgroundColour setBackgroundColor:[self colorWithHexString:@"e06091"]];
    } else if ([[[tweets objectAtIndex:[indexPath row]] objectForKey:@"colour"]  isEqual: @"purple"]) {
            [cell.backgroundColour setBackgroundColor:[self colorWithHexString:@"5a4077"]];
    } else if ([[[tweets objectAtIndex:[indexPath row]] objectForKey:@"colour"]  isEqual: @"green"]) {
            [cell.backgroundColour setBackgroundColor:[self colorWithHexString:@"9ad2c2"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [[tweets objectAtIndex:[indexPath row]] objectForKey:@"full_name"];
	cell.nameLabel.adjustsFontSizeToFitWidth = YES;
	cell.nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 100, cell.frame.origin.y + 20, 100, 30);
    [button setTitle:@"World" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tableView:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor= [UIColor clearColor];
  //  [cell.contentView addSubview:button];
    
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
- (IBAction)cancelview:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

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
        NSString *MID = [defaults objectForKey:@"Con96AID"];
    [defaults setObject:UID forKey:@"Con96FID"];
    [defaults setObject:AID forKey:@"Con96FAID"];
    [defaults synchronize];
    
    //Navigation logic may go here. Create and push another view controller.
    NSString *FinalAID = [NSString stringWithFormat:@"%@", AID];
    NSString *FinalMId = [NSString stringWithFormat:@"%@", MID];
    
    if ([FinalAID isEqualToString:FinalMId]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
    [self  performSegueWithIdentifier:@"showFriend" sender:self];
    }
    
}

- (void)tableView:(UITableView *)tableView{
    static NSString *simpleTableIdentifier = @"CustomFriendCells";
    
    CustomFriendCells *cell = (CustomFriendCells *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSIndexPath *indexPath = [self.tableV indexPathForCell:cell];

    NSLog(@"IndexPathRow %d",indexPath.row);
}

-(void)dealloc{
    [tweets release];
    [responseData release];
    [indicator release];
    [super dealloc];
}


@end
