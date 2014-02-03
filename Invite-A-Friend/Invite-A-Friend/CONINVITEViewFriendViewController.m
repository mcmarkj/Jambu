//
//  CONINVITEViewFriendViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 02/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEViewFriendViewController.h"

@interface CONINVITEViewFriendViewController ()
- (IBAction)addFriend:(id)sender;
@end

@implementation CONINVITEViewFriendViewController
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
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    [connection start];
    NSLog(@"Completed API Request");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friend Added"
                                                    message:@"You're now friends!"
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

- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *AID = [defaults objectForKey:@"Con96FAID"];
    //Get number of friends info
    NSURL *friendsurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/friendships/%@", AID]];
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
    
    
    // 6.1 - Load JSON into internal variable
    // 6.2 - Get the number of shows (post)
    int shows = results.count;
    
    NSLog(@"count : %d",shows);
    NSString *friendscount = [NSString stringWithFormat:@"%d",shows];
    _UserFriendCount.text = friendscount;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [defaults objectForKey:@"Con96FID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", UID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
    NSString *twitterusername = [json valueForKey:@"username"];
    
    NSString *profilecolour = [json valueForKey:@"colour"];
    
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
    
    
    _UserName.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserTwitterName.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    
    _UserName.text = [json valueForKey:@"full_name"];
    _UserTwitterName.text = [NSString stringWithFormat:@"@%@",twitterusername];
    
    _UserEventInvites.text = @"121";
    _UserEventInvites.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserFriendCount.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    _UserEventsAttended.text = @"76";
    _UserEventsAttended.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    
    _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_url"]]]];
    
    
    
    
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
@end