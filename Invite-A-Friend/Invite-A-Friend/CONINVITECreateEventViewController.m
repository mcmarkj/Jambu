//
//  CONINVITECreateEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 07/03/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITECreateEventViewController.h"

@interface CONINVITECreateEventViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventPicker;
- (IBAction)closeView:(id)sender;
- (IBAction)showPicker:(id)sender;
- (IBAction)eventNameChanged:(id)sender;
- (IBAction)eventPointChanged:(id)sender;
- (IBAction)eventLocationChanged:(id)sender;
- (IBAction)eventLocationfinished:(id)sender;
- (IBAction)eventPointfinished:(id)sender;
- (IBAction)eventNamefinished:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *eventTitle;
@property (strong, nonatomic) IBOutlet UITextField *eventMPoint;
@property (strong, nonatomic) IBOutlet UITextField *eventLocation;
@property (strong, nonatomic) IBOutlet UIButton *pickerLabel;

@end

@implementation CONINVITECreateEventViewController

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
        _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPicker:(id)sender {
    _eventPicker.hidden = NO;
}

- (IBAction)eventNameChanged:(id)sender {
    if([_eventTitle.text isEqualToString:@"event name"]){
    _eventTitle.text = @"";
    } else {
        
    }
}

- (IBAction)eventPointChanged:(id)sender {
    if([_eventMPoint.text isEqualToString:@"meeting point"]){
        _eventMPoint.text = @"";
    } else {
        
    }
}

- (IBAction)eventLocationChanged:(id)sender {
    if([_eventLocation.text isEqualToString:@"location"]){
        _eventLocation.text = @"";
    } else {
        
    }
}

- (IBAction)eventLocationfinished:(id)sender {
    if([_eventLocation.text isEqualToString:@""]){
        _eventLocation.text = @"location";
    } else {
        
    }
}

- (IBAction)eventPointfinished:(id)sender {
    if([_eventMPoint.text isEqualToString:@""]){
        _eventMPoint.text = @"meeting point";
    } else {
        
    }
}

- (IBAction)eventNamefinished:(id)sender {
    if([_eventTitle.text isEqualToString:@""]){
        _eventTitle.text = @"event name";
    } else {
        
    }
}
@end
