//
//  LoginViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 21/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
@end
