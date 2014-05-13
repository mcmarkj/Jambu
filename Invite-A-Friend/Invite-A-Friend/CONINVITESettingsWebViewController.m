//
//  CONINVITESettingsWebViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 05/05/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITESettingsWebViewController.h"

@interface CONINVITESettingsWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webViewer;
@property (strong, nonatomic) IBOutlet UIView *teamView;
- (IBAction)closeView:(id)sender;
- (IBAction)viewMarksProfile:(id)sender;
- (IBAction)viewBradsProfile:(id)sender;
- (IBAction)viewSamsProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation CONINVITESettingsWebViewController

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
    NSString *action = [defaults objectForKey:@"ConSettingWeb"];

    if([action isEqualToString:@"Rate"]){
        _titleLabel.text = @"Rate Jambu";
        //go to rate page
        //1
        NSString *urlString = @"https://docs.google.com/forms/d/1R0-UL0UWe9Fmqo2MiHdHM2BpG8JhdapsQkOL877rjbQ/viewform";
        //2
        NSURL *url = [NSURL URLWithString:urlString];
        //3
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //4
        [_webViewer loadRequest:request];
        
    } else if ([action isEqualToString:@"Team"]){
        _titleLabel.text = @"Team 96";
        _teamView.hidden = NO;
    } else if ([action isEqualToString:@"TCS"]){
        _titleLabel.text = @"Jambu T&C's";
    // go to T&C's page
        //1
        NSString *urlString = @"http://jambu.concept96.co.uk/app_resources/TCS.html";
        //2
        NSURL *url = [NSURL URLWithString:urlString];
        //3
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //4
        [_webViewer loadRequest:request];
    }
    
    
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

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewMarksProfile:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *MID = [defaults objectForKey:@"Con96AID"];
    [defaults setObject:@"22154408" forKey:@"Con96FID"];
    [defaults synchronize];

    [self  performSegueWithIdentifier:@"viewProfile" sender:self];
}

- (IBAction)viewBradsProfile:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  NSString *MID = [defaults objectForKey:@"Con96AID"];
    [defaults setObject:@"389746184" forKey:@"Con96FID"];
    [defaults synchronize];

    [self  performSegueWithIdentifier:@"viewProfile" sender:self];
}

- (IBAction)viewSamsProfile:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  NSString *MID = [defaults objectForKey:@"Con96AID"];
    [defaults setObject:@"2168339949" forKey:@"Con96FID"];
    [defaults synchronize];

    [self  performSegueWithIdentifier:@"viewProfile" sender:self];
}
@end
