//
//  CONINVITEFirstViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFirstViewController.h"

@interface CONINVITEFirstViewController ()
@property (strong, nonatomic) IBOutlet UILabel *overlaylabel;
@property (strong, nonatomic) IBOutlet UILabel *overlaynexteventlabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventdatelabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventattendeeslabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteindicator;
@property (strong, nonatomic) IBOutlet UIImageView *inviteindicatorback;

@end

@implementation CONINVITEFirstViewController


- (void)didFinishLaunchingWithOptions
{
    
}
- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"InviteLog"]boolValue]) {
        NSLog(@"user is logged in - do nothing");
        
        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"Con96ID"] != nil) {
        } else {
        
        
        
            [self performSelector:@selector(updateinfo) withObject:nil afterDelay:.1]; }
    }
    else {
        
        NSLog(@"User is not logged in");
        [self  performSegueWithIdentifier:@"LoginPage" sender:self];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UID = [userdefaults objectForKey:@"Con96ID"];
    
    if(UID == NULL){
        NSLog(@"User is not logged in");
        [self  performSegueWithIdentifier:@"LoginPage" sender:self];
    }else {
        
    
    
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://invite-a-friend-development.herokuapp.com/api/v1/users/%@", UID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
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
    
    //_UserTwitterLabel.text = [json valueForKey:@"username"];
    //Set Full Name of User
    _UserNameLabel.text = [json valueForKey:@"full_name"];
    //Set twitter name
    _UserTwitterLabel.text = [NSString stringWithFormat:@"@%@", [json valueForKey:@"username"]];
    
    //SET IMAGE
    _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_url"]]]];
    
    
    [self performSelector:@selector(fadein) withObject:nil afterDelay:-10];
    
    _overlaylabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    
    _overlaynexteventlabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    _overlayeventdatelabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
       _overlayeventattendeeslabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
    
    _UserNameLabel.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserTwitterLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
    _UserEventsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserEventsLabel.text =@"3";
    _UserEventsAttendedLabel.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserEventsAttendedLabel.text =@"27";
    _UserFacebookFriendsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserFacebookFriendsLabel.text =@"1,272";
        _UserRewardsLabel.font = [UIFont fontWithName:@"Roboto" size:20];
    _UserRewardsLabel.text =@"6";
    _UserCardSplitLabels.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    _UserCardSplitLabels1.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _UserCardSplitLabels2.font = [UIFont fontWithName:@"Roboto-Light" size:12];

        _UserCardSplitLabels3.font = [UIFont fontWithName:@"Roboto-Light" size:12];

        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];

    
	// Do any additional setup after loading the view, typically from a nib.
    }}


-(void)updateinfo
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UID = [userdefaults objectForKey:@"Con96ID"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Con96ID"] != nil) {
        NSLog(@"User is not logged in");
        [self  performSegueWithIdentifier:@"LoginPage" sender:self];
    }else {
        
        
        
        
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://invite-a-friend-development.herokuapp.com/api/v1/users/%@", UID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
        
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
        
        //_UserTwitterLabel.text = [json valueForKey:@"username"];
        //Set Full Name of User
        _UserNameLabel.text = [json valueForKey:@"full_name"];
        //Set twitter name
        _UserTwitterLabel.text = [NSString stringWithFormat:@"@%@", [json valueForKey:@"username"]];
        
        //SET IMAGE
        _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_url"]]]];
        
    }
    }
- (void)updateCountdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *endingDate = [dateFormatter dateFromString:@"2014-01-31"];
    NSDate *startingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    NSInteger hours    = [dateComponents hour];
    
        NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %d Hours", hours];
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

@end
