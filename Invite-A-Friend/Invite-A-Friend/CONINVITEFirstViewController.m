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

@interface CONINVITEFirstViewController () {
        UIView *setNeedsDisplay;
}
@property (strong, nonatomic) IBOutlet UILabel *overlaylabel;
@property (strong, nonatomic) IBOutlet UILabel *overlaynexteventlabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventdatelabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventattendeeslabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteindicator;
@property (strong, nonatomic) IBOutlet UIImageView *inviteindicatorback;
@property (strong, nonatomic) IBOutlet UILabel *UserTNameLabel;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *_UserFacebookFriendsLabel;

@end

@implementation CONINVITEFirstViewController


- (void)didFinishLaunchingWithOptions

{
    
}

-(void)checktwitterupdate
{
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

        NSString *currentName = _UserNameLabel.text;
        NSString *name = [json objectForKey:@"name"];
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
        
        if([currentName isEqualToString:name]) {
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
            
            
        }

        //NSString *nooffollwers = [json objectForKey:@"follower_count"];
        
    }
     
     ];}

- (void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *UID = [defaults objectForKey:@"Con96TUID"];
    
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
        
        
        //Check if the response is valid or not - stops the app from crashing
        if (json == [NSNull null]) {
            NSLog(@"Response is Null, user's been deleted");
            [self showLogin:Nil];
        } else {
            NSLog(@"Response is not Null, User is active - let's request data");

        
        //Checking if the user has any pending events, let's enable / disable the indicator in response to this.
        if([json valueForKey:@"pendingevents"] > 0){
            _inviteindicatorback.hidden = false;
            _inviteindicator.hidden = false;
            //Change the button's value to match the number of pending events pulled from the JSON.
            [_inviteindicator setTitle:[json valueForKey:@"pendingevents"] forState:UIControlStateNormal];
        } else {
            //Since they have no events we'll hide the indicator and the button.
            _inviteindicatorback.hidden = true;
            _inviteindicator.hidden = true;
        }
        
        NSString *twitterusername = [json valueForKey:@"username"];
        NSString *AID = [json valueForKey:@"id"];
            NSString *imgurl = [json valueForKey:@"image_url"];
            
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:AID forKey:@"Con96AID"];
        [defaults setObject:twitterusername forKey:@"Con96TUNAME"];
        [defaults setObject:imgurl forKey:@"Con96UIMG"];
        [defaults synchronize];
        
            

            
            
        //_UserTwitterLabel.text = [json valueForKey:@"username"];
        //Set Full Name of User
        _UserNameLabel.text = [json valueForKey:@"full_name"];
        //Set twitter name
        _UserTNameLabel.text = [NSString stringWithFormat:@"@%@",twitterusername];
        
        //SET IMAGE
        _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_url"]]]];
        
            NSString *userUID = UID;
            //Get number of friends info

            
            NSURL *friendurl = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/count/%@", userUID]];
            
            NSMutableURLRequest *frequest = [NSMutableURLRequest requestWithURL:friendurl];
            
            [frequest setURL:friendurl];
            [frequest setHTTPMethod:@"GET"];
            [frequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSError *error;
            NSURLResponse *fresponse;
            NSData *fjsondata = [NSURLConnection sendSynchronousRequest:frequest returningResponse:&fresponse error:&error];
            NSArray *friendsjson = [NSJSONSerialization JSONObjectWithData:fjsondata options:NSJSONReadingAllowFragments error:nil];
            
            
            NSString *friendscount = [NSString stringWithFormat:@"%@",[friendsjson valueForKey:@"friends"]];;
        _overlaylabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
        
        _overlaynexteventlabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
        _overlayeventdatelabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
        _overlayeventattendeeslabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
        
        _UserNameLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserTNameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
        _UserEventsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserEventsLabel.text =@"3";
        _UserEventsAttendedLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserEventsAttendedLabel.text =@"27";
        [_UserFacebookFriendsLabel setTitle:friendscount forState:(UIControlStateNormal)];
        _UserFacebookFriendsLabel.titleLabel.font = [UIFont fontWithName:@"Roboto" size:20];
       // [_UserFacebookFriendsLabel setValue:[UIFont fontWithName:@"Roboto" size:20] forKeyPath:@"_UserFacebookFriendsLabel.font"];
        _UserRewardsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        _UserRewardsLabel.text =@"6";
        _UserCardSplitLabels.font = [UIFont fontWithName:@"Roboto-Light" size:10];
        _UserCardSplitLabels1.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        _UserCardSplitLabels2.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        
        _UserCardSplitLabels3.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        
        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];
        

        
        
        
        
        
        //[self.view setNeedsDisplay];
            [self checktwitterupdate];
        } }
    
    else {
        
        NSLog(@"User is not logged in");
        
        [self  performSegueWithIdentifier:@"LoginPage" sender:self];
        
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
            [self performSelector:@selector(fadein) withObject:nil afterDelay:-10];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UID = [userdefaults objectForKey:@"Con96TUID"];
    
    if(UID == NULL){
        NSLog(@"I'm not going to run anything until we log the user in");
    
    }else {
        
        NSLog(@"User is logged in, let's pull some info from the api");
    


        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];

    
	// Do any additional setup after loading the view, typically from a nib.
    }}


- (void)updateCountdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *endingDate = [dateFormatter dateFromString:@"2014-12-31"];
    NSDate *startingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    NSInteger hours    = [dateComponents hour];
    
        NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %ld Hours", (long)hours];
        _overlaynexteventlabel.text = countdownText;
    
}



-(void) fadein
{
    _overlaynexteventlabel.alpha = 0;
    _overlaylabel.alpha = 0;
    _UserIndicatorButton.alpha=0;
    _UserIndicatorImage.alpha=0;
    _UserRewardsLabel.alpha=0;
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
    _UserRewardsLabel.alpha=1;
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
        _UserRewardsLabel.alpha=1;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signing Out"
                                                    message:@"I've been told to delete all locally stored info. I'm going to close down, please reopen me to login again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert performSelectorOnMainThread:@selector(show)
                            withObject:nil
                         waitUntilDone:NO];
    
    
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:NO] forKey:@"InviteLog"];
    [defaults setObject:@"NULL" forKey:@"Con96TUID"];
    [defaults synchronize];
    exit(0);

}
- (IBAction)showFriends:(id)sender {
        NSString *title = [_UserFacebookFriendsLabel currentTitle];
    
    if ([title isEqualToString:@"0"]) {
        NSLog(@"User has no friends");
    } else {
        [self  performSegueWithIdentifier:@"showFriends" sender:self];
    }
    
}
@end
