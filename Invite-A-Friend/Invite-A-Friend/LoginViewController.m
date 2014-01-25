//
//  LoginViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 21/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "LoginViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface LoginViewController ()
- (IBAction)twitterlogin:(id)sender;
@property (nonatomic) ACAccountStore *accountStore;

@end


@implementation LoginViewController

@synthesize username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    // Check if user is already logged in
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"InviteLog"] intValue] == 1) {
        self.view.hidden = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check if user is already logged in
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"InviteLog"] intValue] == 1) {
        [self performSegueWithIdentifier:@"loginscreen" sender:self];
    }

	// Do any additional setup after loading the view.
}

-(void)viewDidUnload {
    self.view.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)fakelogin:(UIButton *)sender {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"loggedIn"]; //in
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)twitterlogin:(id)sender
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSLog(@"The username is %@",twitterAccount.username);
                NSLog(@"It is a %@ account",twitterAccount.accountType);
                
                NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://invite-a-friend-development.herokuapp.com/api/v1/users%@", @""]];
                
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http123123", @"image_url", @"twitter", @"provider",@123,@"uid",twitterAccount.username,@"username", @"Mark McWhirter", @"full_name", nil];
                
                // Sorry dude, im a bit of a moron
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
                
                NSString *editeddata = [NSString stringWithFormat:@"{\"user\":%@}",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
                NSLog(editeddata);
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:finaldata];
                
                // print json:
                
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [connection start];
                
                
            }
        }
    }];
}

- (void)getTwitterAccount:(ACAccount *)account {
    }

- (void)fetchData
{
    
	     }

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}


@end
