//
//  CONINVITEFriendsViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 19/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFriendsViewController.h"

@interface CONINVITEFriendsViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoadingIndicator;

@end

@implementation CONINVITEFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
        [self.LoadingIndicator startAnimating];
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
 [self.LoadingIndicator stopAnimating];
    _LoadingIndicator.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated{
    [self viewDidLoad];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
