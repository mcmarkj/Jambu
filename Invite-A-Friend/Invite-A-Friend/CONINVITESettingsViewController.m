//
//  CONINVITESettingsViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 05/05/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITESettingsViewController.h"

@interface CONINVITESettingsViewController ()
- (IBAction)viewTCS:(id)sender;
- (IBAction)viewConceptTeam:(id)sender;
- (IBAction)DisableNotifications:(id)sender;
- (IBAction)Logout:(id)sender;
- (IBAction)RateJambu:(id)sender;
- (IBAction)closeView:(id)sender;

@end

@implementation CONINVITESettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewTCS:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"TCS" forKey:@"ConSettingWeb"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"webViewer" sender:self];
}

- (IBAction)viewConceptTeam:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Team" forKey:@"ConSettingWeb"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"webViewer" sender:self];
}

- (IBAction)DisableNotifications:(id)sender {
    NSLog(@"Contacting API to remove their device (and stop push notifications)");
}

- (IBAction)Logout:(id)sender {
    NSLog(@"Need to log out");
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signing Out"
     message:@"I've been told to delete all locally stored info. I'm going to close down, please reopen me to login again."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil
     ];
     [alert performSelectorOnMainThread:@selector(show)
     withObject:nil
     waitUntilDone:NO];
     
     
     
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:NO] forKey:@"InviteLog"];
    [defaults setObject:@"NULL" forKey:@"Con96TUID"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"LoginPage" sender:self];
}

- (IBAction)RateJambu:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Rate" forKey:@"ConSettingWeb"];
    [defaults synchronize];
    [self  performSegueWithIdentifier:@"webViewer" sender:self];
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
