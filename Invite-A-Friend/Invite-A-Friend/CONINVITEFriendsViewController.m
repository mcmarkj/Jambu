//
//  CONINVITEFriendsViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 19/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFriendsViewController.h"

@interface CONINVITEFriendsViewController ()

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
    [super viewDidLoad];
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
    }
    
    
    _UserName.font = [UIFont fontWithName:@"Helvetica" size:18];
    _UserTwitterName.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    _UserName.text = [json valueForKey:@"full_name"];
    _UserTwitterName.text = [NSString stringWithFormat:@"@%@",twitterusername];
    
    _UserEventInvites.text = @"121";
    _UserFriendCount.text = @"17";
    _UserEventsAttended.text = @"76";
    
    _UserImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_url"]]]];
    
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
