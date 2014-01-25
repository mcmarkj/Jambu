//
//  LoginViewTwoViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 25/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "LoginViewTwoViewController.h"

@interface LoginViewTwoViewController ()

@end

@implementation LoginViewTwoViewController

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
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation( 1.0 / 180.0 * 3.14 );
    [_SpinnerImage setTransform:rotate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload {
    self.view.hidden = NO;
}


@end
