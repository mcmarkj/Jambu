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
#include "UICountingLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
- (IBAction)twitterlogin:(id)sender;
@property (strong, nonatomic) IBOutlet UICountingLabel *currentpercentage;
@property (nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) IBOutlet UIImageView *spinningimage;

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
    
    _spinningimage.hidden = true;
}

-(void)viewDidDisappear:(BOOL)animated{
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
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"InviteLog"]; //in
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)spinimage
{
    _spinningimage.hidden = false;
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 6;
    fullRotation.repeatCount = 3.4028235;
    [_spinningimage.layer addAnimation:fullRotation forKey:@"360"];
}

- (IBAction)twitterlogin:(id)sender
{
                    [self performSelector:@selector(closeview) withObject:nil afterDelay:11.0];
    [self performSelector:@selector(spinimage) withObject:nil afterDelay:.01];


    _currentpercentage.format = @"%d%%";
[_currentpercentage countFrom:0 to:100 withDuration:9.0f];
       ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                // Let's pull some info from twitter bro
                {
                
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
                    
                    NSString *name = [json objectForKey:@"name"];
                    NSString *twitterid = [json objectForKey:@"id"];
                    NSString *prof_img = [json objectForKey:@"profile_image_url"];
                    //NSString *nooffollwers = [json objectForKey:@"follower_count"];
                    
                    
                    NSString *altprof_img = [prof_img stringByReplacingOccurrencesOfString:@"_normal"
                                                         withString:@""];
                    //NSLog(nooffollwers);
                
                //
                
                
                NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://invite-a-friend-development.herokuapp.com/api/v1/users%@", @""]];
                
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:altprof_img, @"image_url", @"twitter", @"provider",twitterid,@"uid",twitterAccount.username,@"username", name, @"full_name", nil];
                    
                    
                
                // Sorry dude, im a bit of a moron
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
                
                NSString *editeddata = [NSString stringWithFormat:@"{\"user\":%@}",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(editeddata);
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:finaldata];
                
                // print json:
                
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                // DISABLED WHILE WE CONFIGURE STUFF
                [connection start];



                // If there are no accounts, we need to pop up an alert
                
                }];
                    
                    
                    
                    
                }
                } else {

                    NSLog(@"There's no accounts active");
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
message:@"There are no Twitter accounts added to your device. You can add or make a new Twitter account by going back to the homescreen and into your Settings."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil
                      ];
                    [alert performSelectorOnMainThread:@selector(show)
                                              withObject:nil
                                           waitUntilDone:NO];
                    
                   
                
            }
            
            
        }
    }];
    
    if(login){
        NSLog(@"Account was created");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"InviteLog"]; //in
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    } else {
        //In the meantime we'll say it failed to create due to testing reasons
        NSLog(@"Account Failed to create");
    }
    
    
}

- (void)getTwitterAccount:(ACAccount *)account {
    }

-(void)closeview{
    NSLog(@"Account must have been made, I've been told to close the login view");
    [self dismissViewControllerAnimated:YES completion:^{}];
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
