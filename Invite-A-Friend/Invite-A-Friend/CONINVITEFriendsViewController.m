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
    
    _FriendNameLabel.font = [UIFont fontWithName:@"Roboto" size:18];
    _FriendTwitterLabel.font = [UIFont fontWithName:@"Roboto" size:14];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
