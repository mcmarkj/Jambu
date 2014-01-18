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

@end

@implementation CONINVITEFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _overlaylabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    
    _overlaynexteventlabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
