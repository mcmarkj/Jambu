//
//  CONINVITECreateEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 07/03/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITECreateEventViewController.h"

@interface CONINVITECreateEventViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *thedatePicker;
- (IBAction)dateDone:(id)sender;
- (IBAction)inviteFriends:(id)sender;
- (IBAction)privacyMe:(id)sender;
- (IBAction)privacyInvite:(id)sender;
- (IBAction)privacyAnyone:(id)sender;
- (IBAction)closePrivicy:(id)sender;
- (IBAction)choosePrivicy:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *privicyMenu;
@property (strong, nonatomic) IBOutlet UIButton *attendButton;
@property (strong, nonatomic) IBOutlet UIButton *privButton;
@property (strong, nonatomic) IBOutlet UIButton *dtButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventPicker;
- (IBAction)closeView:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;
- (IBAction)showPicker:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *eventOwner;
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
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    [super viewDidLoad];
    _eventOwner.font = [UIFont fontWithName:@"Roboto-Light" size:8];
    _eventDescription.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"event_description.png"]];
    _eventTitle.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventTitle.leftView = paddingView;
    _eventTitle.leftViewMode = UITextFieldViewModeAlways;
    _eventLocation.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventLocation.leftView = paddingsView;
    _eventLocation.leftViewMode = UITextFieldViewModeAlways;
    _eventDescription.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    [_dtButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _dtButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _dtButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_privButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _privButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _privButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_attendButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _attendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _attendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	// Do any additional setup after loading the view.
    [paddingView release];
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
    _thedatePicker.hidden = NO;
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
- (IBAction)dateDone:(id)sender {
        _thedatePicker.hidden = YES;
    UIDatePicker *datePicker = _datePicker;
    NSDate *pickerdate = [datePicker date];
    
    NSString *pickeraltdate = [NSString stringWithFormat:@"%@", pickerdate];
    
    NSTimeInterval timestamp = [pickerdate timeIntervalSince1970];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *eventdate = pickeraltdate;
    NSDate *date = [dateFormatter dateFromString:eventdate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger day = [components day];
    NSInteger daymonth = [components month];
   // NSInteger DayYear = [components year];
    NSInteger minute = [components minute];

    
    
    
    {
        NSString *suffix;
        int ones = day % 10;
        int temp = floor(day/10.0);
        int tens = temp%10;
        
        if (tens ==1) {
            suffix = @"th";
        } else if (ones ==1){
            suffix = @"st";
        } else if (ones ==2){
            suffix = @"nd";
        } else if (ones ==3){
            suffix = @"rd";
        } else {
            suffix = @"th";
        }

 //   NSString *completeAsString = [NSString stringWithFormat:@"%d%@",day,suffix];
    
    
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(daymonth-1)];
        
        //we need to format it if it's 05 past or 00 minutes past
        
        NSString *altmin = [NSString stringWithFormat:@"%d",minute];
        
            if ([altmin isEqualToString:@"5"]) {
                altmin = @"05";
            } else if ([altmin isEqualToString:@"0"]) {
                altmin = @"00";
            }
        
        NSString *newDate = [NSString stringWithFormat:@"event on: %d%@ %@ at %d:%@",day,suffix,monthName,hour,altmin];
    
    [_dtButton setTitle:newDate forState:UIControlStateNormal];
    }
}

- (IBAction)inviteFriends:(id)sender {
}

- (IBAction)privacyMe:(id)sender {
 [_privButton setTitle:@"privacy: Only Me" forState:UIControlStateNormal];
        _privicyMenu.hidden = YES;
}

- (IBAction)privacyInvite:(id)sender {
    [_privButton setTitle:@"privacy: Only People I Invite" forState:UIControlStateNormal];
        _privicyMenu.hidden = YES;
}

- (IBAction)privacyAnyone:(id)sender {
    [_privButton setTitle:@"privacy: Anyone Can Attend" forState:UIControlStateNormal];
        _privicyMenu.hidden = YES;
}

- (IBAction)closePrivicy:(id)sender {
    _privicyMenu.hidden = YES;
}

- (IBAction)choosePrivicy:(id)sender {
    _privicyMenu.hidden = NO;
}
@end
