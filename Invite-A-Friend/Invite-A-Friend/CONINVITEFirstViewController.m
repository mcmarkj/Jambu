//
//  CONINVITEFirstViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFirstViewController.h"
#import <Quartzcore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Reachability.h"

@interface CONINVITEFirstViewController () {
        UIView *setNeedsDisplay;
}
- (IBAction)showInvites:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageLoader;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *eventsLoader;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *eventsLoader2;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *eventsLoader3;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *eventsLoader4;
@property (strong, nonatomic) IBOutlet UILabel *overlaylabel;
@property (strong, nonatomic) IBOutlet UILabel *overlaynexteventlabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventdatelabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventattendeeslabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteindicator;
@property (strong, nonatomic) IBOutlet UIImageView *inviteindicatorback;
@property (strong, nonatomic) IBOutlet UILabel *UserTNameLabel;
//@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *_UserFacebookFriendsLabel;

@property NSString *steve;


@end

@implementation CONINVITEFirstViewController


- (void)didFinishLaunchingWithOptions

{
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)checkfornetwork
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [defaults setObject:@"False" forKey:@"NetConn"];
        [defaults synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Issue"
                                                        message:@"Unable to connect to the internet. Please ensure you're connected to either the internet over Wifi or have a 3G connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ];
        [alert performSelectorOnMainThread:@selector(show)
                                withObject:nil
                             waitUntilDone:NO];

        
    } else {
        
        NSLog(@"There IS internet connection");
        [defaults setObject:@"True" forKey:@"NetConn"];
        [defaults synchronize];
        
        
        
    }        

}

-(void)checktwitterupdate
{
    NSLog(@"Checking twitter for updates");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_img = [defaults objectForKey:@"Con96UIMG"];
    NSString *currenttwitter_username = [defaults objectForKey:@"Con96TUNAME"];

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];


    
    NSURL *twitterurl = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *params = @{@"screen_name" : twitterAccount.username
                             };
    SLRequest *request =
    [SLRequest requestForServiceType:SLServiceTypeTwitter
                       requestMethod:SLRequestMethodGET
                                 URL:twitterurl
                          parameters:params];
    
    //  Attach an account to the request
    [request setAccount:[accountsArray lastObject]];
    
    //  Step 3:  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        
        
        
        // Let's translate it so we can use it later mate
        
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData //1
                              options:NSJSONReadingAllowFragments
                              error:&error];


        NSString *prof_img = [json objectForKey:@"profile_image_url"];
        
        
        NSString *altprof_img = [prof_img stringByReplacingOccurrencesOfString:@"_normal"
                                                                    withString:@""];
        NSString *altprofthum_img = [prof_img stringByReplacingOccurrencesOfString:@"_normal"
                                                                    withString:@"_bigger"];
            if([currenttwitter_username isEqualToString:twitterAccount.username]) {
                NSLog(@"Twitter Username is up-to-date");
            } else {
                NSLog(@"Twitter Username is Out-Of-Date");
                                _UserTNameLabel.text = [NSString stringWithFormat:@"@%@",twitterAccount.username];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *MID = [defaults objectForKey:@"Con96AID"];
                
                NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
                
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: twitterAccount.username, @"username", nil];
                
                NSError *error;
                
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
                
                NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                
                NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                
                [request setURL:url];
                [request setHTTPMethod:@"PUT"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:finaldata];
                
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                // DISABLED WHILE WE CONFIGURE STUFF
                
                NSLog(@"We're now collecting to the API");
                
                [connection start];


                
                
                
            }
        
        if([user_img isEqualToString:altprof_img]) {
            //It's all good do nothing
            NSLog(@"User Image is up to date");
        } else {
            if(altprof_img == NULL) {
                NSLog(@"The image is Null... Don't update!");
            } else {
                        NSLog(@"User Image is outofdate");
                        _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:altprof_img]]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *MID = [defaults objectForKey:@"Con96AID"];
            
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
            
            NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: altprof_img, @"image_url", altprofthum_img, @"image_thumbnail", nil];
            
            NSError *error;
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
            
            NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
            
            NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:url];
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:finaldata];
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            // DISABLED WHILE WE CONFIGURE STUFF
            
            NSLog(@"We're now collecting to the API");
            
            [connection start];
            

            }
        }
        
    /*    if([currentName isEqualToString:name]) {
            //Do nothing
                        NSLog(@"User name is up to date");
        } else {
            if(name == NULL) {
                NSLog(@"The Name's Null... Don't update!");
                NSLog(@"Twitter Issue");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Issue"
                                                                message:@"There's been an issue... If you've recently changed your @twitter account username please update it in your settings... We're unable to get any information from twitter!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil
                                      ];
                [alert performSelectorOnMainThread:@selector(show)
                                        withObject:nil
                                     waitUntilDone:NO];

            } else {
                        NSLog(@"User name is out of date");
            _UserNameLabel.text = name;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *MID = [defaults objectForKey:@"Con96AID"];
            
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
            
            NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: name, @"full_name", nil];
            
            NSError *error;
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
            
            NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
            
            NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:url];
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:finaldata];
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            // DISABLED WHILE WE CONFIGURE STUFF
            
            NSLog(@"We're now collecting to the API");
            
            [connection start];
            
            }
            
            
        } */

        //NSString *nooffollwers = [json objectForKey:@"follower_count"];
        
    }
     
     ];}

- (void)viewDidAppear:(BOOL)animated{
    [self checkfornetwork];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *UID = [defaults objectForKey:@"Con96TUID"];
    if ([[defaults objectForKey:@"NetConn"]  isEqual: @"True"]) {
    if ([[defaults objectForKey:@"Con96TUID"]boolValue]) {
        
        NSLog(@"user is logged in - do nothing");
        
        
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
        NSArray *next_event = [json valueForKey:@"next_event"];
        //Check if the response is valid or not - stops the app from crashing
        if (userInfo == nil) {
            NSLog(@"Response is Null, user's been deleted");
            [self showLogin:Nil];
        } else {
            NSLog(@"Response is not Null, User is active - let's request data");

        
        //Checking if the user has any pending events, let's enable / disable the indicator in response to this.
            NSString *eventInvitesPrend = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"event_invites_pending"]];
            
               //   int level = [eventInvitesPrend intValue];
            
        if([eventInvitesPrend isEqual:@"0"]){
            //Since they have no events we'll hide the indicator and the button.
            _inviteindicatorback.hidden = true;
            _inviteindicator.hidden = true;
        } else {
            _inviteindicatorback.hidden = false;
            _inviteindicator.hidden = false;
            //Change the button's value to match the number of pending events pulled from the JSON.
            [_inviteindicator setTitle:eventInvitesPrend forState:UIControlStateNormal];
        }
            
            
        NSString *twitterusername = [userInfo valueForKey:@"username"];
        NSString *AID = [userInfo valueForKey:@"id"];
            NSString *imgurl = [userInfo valueForKey:@"image_url"];
            
            NSString *eventTitle = [next_event valueForKey:@"title"];
            //Not using this yet for some reason?
            //NSString *endTime = [next_event valueForKey:@"time_of_event_end"];
            NSString *lat = [next_event valueForKey:@"lat"];
            NSString *lng = [next_event valueForKey:@"long"];
            NSString *desc = [next_event valueForKey:@"description"];
            NSString *event_userID = [next_event valueForKey:@"user_id"];
            NSString *event_ID = [next_event valueForKey:@"id"];
            
            
            
            
            
            
            //Let's convert the unix timestamp
            double timestampval = [[next_event valueForKey:@"time_of_event"] doubleValue];
            NSTimeInterval timestamp = (NSTimeInterval)timestampval;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setLocale:[NSLocale currentLocale]];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *dateString=[dateformatter stringFromDate:date];
            // end of conversion
            
            
            {
            //Let's convert the unix timestamp
            double timestampval = [[next_event valueForKey:@"time_of_event_end"] doubleValue];
            NSTimeInterval timestamp = (NSTimeInterval)timestampval;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setLocale:[NSLocale currentLocale]];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *enddateString=[dateformatter stringFromDate:date];
            // end of conversion
            
            
            
            
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:AID forKey:@"Con96AID"];
        [defaults setObject:twitterusername forKey:@"Con96TUNAME"];
        [defaults setObject:imgurl forKey:@"Con96UIMG"];
            [defaults setObject:dateString forKey:@"ConNextEDate"];
            [defaults setObject:eventTitle forKey:@"ConNextTitle"];
            [defaults setObject:enddateString forKey:@"ConNextEnd"];
            [defaults setObject:lat forKey:@"ConNextLat"];
            [defaults setObject:lng forKey:@"ConNextLong"];
            [defaults setObject:desc forKey:@"ConNextDesc"];
            [defaults setObject:event_userID forKey:@"ConNextUID"];
            [defaults setObject:event_ID forKey:@"ConNextEID"];
            

        [defaults synchronize];
            }
            

            
            
        //_UserTwitterLabel.text = [json valueForKey:@"username"];
        //Set Full Name of User
        _UserNameLabel.text = [userInfo valueForKey:@"full_name"];
        //Set twitter name
        _UserTNameLabel.text = [NSString stringWithFormat:@"@%@",twitterusername];
        
        //SET IMAGE
        _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo valueForKey:@"image_url"]]]];
        
            NSString *userUID = UID;
            //Get number of friends info

            
            NSURL *friendurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/count/%@", userUID]];
            
            NSMutableURLRequest *frequest = [NSMutableURLRequest requestWithURL:friendurl];
            
            [frequest setURL:friendurl];
            [frequest setHTTPMethod:@"GET"];
            [frequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            

           
            
            
            
            NSString *friendscount = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"friends"]];;
        _overlaylabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
        
        _overlaynexteventlabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
        _overlayeventdatelabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
        _overlayeventattendeeslabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
        
        _UserNameLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserTNameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
        _UserEventsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserEventsLabel.text = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"events_created"]];
        _UserEventsAttendedLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserEventsAttendedLabel.text = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"events_attended"]];;
        [_UserFacebookFriendsLabel setTitle:friendscount forState:(UIControlStateNormal)];
        _UserFacebookFriendsLabel.titleLabel.font = [UIFont fontWithName:@"Roboto" size:20];
       // [_UserFacebookFriendsLabel setValue:[UIFont fontWithName:@"Roboto" size:20] forKeyPath:@"_UserFacebookFriendsLabel.font"];
            NSString *followercount = [NSString stringWithFormat:@"%@",[countInfo valueForKey:@"added_as_friend"]];;
        [_UserFollowersButton setTitle:followercount forState:(UIControlStateNormal)];
        _UserFollowersButton.titleLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserCardSplitLabels.font = [UIFont fontWithName:@"Roboto-Light" size:10];
        _UserCardSplitLabels1.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        _UserCardSplitLabels2.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        
        _UserCardSplitLabels3.font = [UIFont fontWithName:@"Roboto-Light" size:10];
        
        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];
        

        
                    [self checktwitterupdate];
        
        //[self.view setNeedsDisplay];

        } }
    
    else {
        
        NSLog(@"User is not logged in");
        
        [self  performSegueWithIdentifier:@"LoginPage" sender:self];
        
        
    }
    } else {
        NSLog(@"Not Connected to the network");
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
                [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];

                [self  performSegueWithIdentifier:@"noConnection" sender:self];
        
    }
}


- (void)viewDidLoad
{

        [self checkfornetwork];
    [super viewDidLoad];

  [self.eventsLoader startAnimating];
      [self.eventsLoader2 startAnimating];
      [self.eventsLoader3 startAnimating];
      [self.eventsLoader4 startAnimating];
      [self.imageLoader startAnimating];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
        if ([[userdefaults objectForKey:@"NetConn"]  isEqual: @"True"]) {
            [self performSelector:@selector(fadein) withObject:nil afterDelay:-10];

    
    NSString *UID = [userdefaults objectForKey:@"Con96TUID"];
    
    if(UID == NULL){
        NSLog(@"I'm not going to run anything until we log the user in");
    
    }else {
        
        NSLog(@"User is logged in, let's pull some info from the api");
    


        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];

    }
    } else {
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    }


- (void)updateCountdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventdate = [defaults objectForKey:@"ConNextEDate"];
    NSDate *endingDate = [dateFormatter dateFromString:eventdate];
    NSDate *startingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    NSInteger hours = [dateComponents hour];
    NSInteger mins    = [dateComponents minute];
    NSInteger days = [dateComponents day];

    if(days>=1){
        NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %ld Days, %ld Hours, and %ld Mins", (long)days, (long)hours, (long)mins];
        _overlaynexteventlabel.text = countdownText;
    } else {
    
    
    if(hours <= 0){
        if(mins <=0){
        NSString *countdownText = [NSString stringWithFormat:@"No upcoming events :[ %@", @""];
        _overlaynexteventlabel.text = countdownText;
        } else if (mins >=1) {
            NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %ld Mins", (long)mins];
            _overlaynexteventlabel.text = countdownText;
            
            NSString *shours = [NSString stringWithFormat:@"%ld", (long)hours];
            NSString *smins = [NSString stringWithFormat:@"%ld", (long)mins];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:shours forKey:@"CONEHours"];
            [defaults setObject:smins forKey:@"CONEMins"];
            [defaults synchronize];
            
        }
    } else {
    
        NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %ld Hours, and %ld Mins", (long)hours, (long)mins];
        _overlaynexteventlabel.text = countdownText;
        
        NSString *shours = [NSString stringWithFormat:@"%ld", (long)hours];
        NSString *smins = [NSString stringWithFormat:@"%ld", (long)mins];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:shours forKey:@"CONEHours"];
        [defaults setObject:smins forKey:@"CONEMins"];
        [defaults synchronize];
        
    }
}
}


-(void) fadein
{
    [self.eventsLoader stopAnimating];
    [self.eventsLoader2 stopAnimating];
    [self.eventsLoader3 stopAnimating];
    [self.eventsLoader4 stopAnimating];
        [self.imageLoader stopAnimating];
    
    _eventsLoader.hidden = YES;
    _eventsLoader2.hidden = YES;
    _eventsLoader3.hidden = YES;
    _eventsLoader4.hidden = YES;
    _imageLoader.hidden = YES;
    
    _overlaynexteventlabel.alpha = 0;
    _overlaylabel.alpha = 0;
    _UserIndicatorButton.alpha=0;
    _UserIndicatorImage.alpha=0;
    _UserFollowersButton.alpha=0;
    _UserEventsLabel.alpha=0;
    _UserNameLabel.alpha=1;
    _UserTwitterLabel.alpha=1;
    _UserFacebookFriendsLabel.alpha=0;
    _UserEventsAttendedLabel.alpha=0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:3];
    _overlaynexteventlabel.alpha = 1;
    _overlaylabel.alpha = 1;
    _UserIndicatorButton.alpha=1;
    _UserIndicatorImage.alpha=1;
    _UserFollowersButton.alpha=1;
    _UserEventsLabel.alpha=1;
    _UserNameLabel.alpha=1;
    _UserTwitterLabel.alpha=1;
    _UserFacebookFriendsLabel.alpha=1;
    _UserEventsAttendedLabel.alpha=1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}



-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context {
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:10];
        _overlaynexteventlabel.alpha = 1;
        _overlaylabel.alpha = 1;
        _UserIndicatorButton.alpha=1;
        _UserIndicatorImage.alpha=1;
        _UserFollowersButton.alpha=1;
        _UserEventsLabel.alpha=1;
        _UserNameLabel.alpha=1;
        _UserTwitterLabel.alpha=1;
        _UserFacebookFriendsLabel.alpha=1;
        _UserEventsAttendedLabel.alpha=1;
        
        [UIView commitAnimations];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showLogin:(UIButton *)sender {
    NSLog(@"Need to log out");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:NO] forKey:@"InviteLog"];
    [defaults setObject:@"NULL" forKey:@"Con96TUID"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"LoginPage" sender:self];
    
}

- (IBAction)logout:(UIButton *)sender {
    NSLog(@"Need to log out");
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signing Out"
                                                    message:@"I've been told to delete all locally stored info. I'm going to close down, please reopen me to login again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert performSelectorOnMainThread:@selector(show)
                            withObject:nil
                         waitUntilDone:NO];
    
    
    
*/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:NO] forKey:@"InviteLog"];
    [defaults setObject:@"NULL" forKey:@"Con96TUID"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"LoginPage" sender:self];
}

- (IBAction)viewFollowers:(id)sender {
    NSString *title = [_UserFollowersButton currentTitle];
    
    if ([title isEqualToString:@"0"]) {
        NSLog(@"User has no followers");
    } else {
        [self  performSegueWithIdentifier:@"listFollowers" sender:self];
    }

}
- (IBAction)showFriends:(id)sender {
        NSString *title = [_UserFacebookFriendsLabel currentTitle];
    
    if ([title isEqualToString:@"0"]) {
        NSLog(@"User has no friends");
    } else {
        [self  performSegueWithIdentifier:@"showFriends" sender:self];
    }
    
}
- (IBAction)showInvites:(id)sender {
       [self  performSegueWithIdentifier:@"pendingInvites" sender:self];
}
@end
