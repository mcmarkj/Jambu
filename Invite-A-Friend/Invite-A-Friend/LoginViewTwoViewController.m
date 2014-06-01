//
//  LoginViewTwoViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 25/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "LoginViewTwoViewController.h"
#import "TestFlight.h"

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
    [TestFlight passCheckpoint:@"Edit Profile"];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [defaults objectForKey:@"Con96ID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", UID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
    _UserImage1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_thumbnail"]]]];
        _UserImage2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_thumbnail"]]]];
        _UserImage3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_thumbnail"]]]];
        _UserImage4.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_thumbnail"]]]];
        _UserImage5.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"image_thumbnail"]]]];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload {
    self.view.hidden = NO;
}


- (IBAction)setRed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];

        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"red", @"colour",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setBlue:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"blue", @"colour",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"Changing colour to blue.");
    
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPink:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"pink", @"colour",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setGreen:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"green", @"colour",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPurple:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *MID = [defaults objectForKey:@"Con96AID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/users/%@", MID]];
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"purple", @"colour",  nil];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
