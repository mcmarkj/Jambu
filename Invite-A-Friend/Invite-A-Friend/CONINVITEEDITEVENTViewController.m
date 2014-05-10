//
//  CONINVITEEDITEVENTViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 09/05/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEEDITEVENTViewController.h"

@interface CONINVITEEDITEVENTViewController ()
- (IBAction)createEvent:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *endDateView;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
- (IBAction)chooseLocation:(id)sender;

- (IBAction)eventDescEdit:(id)sender;
- (IBAction)EventDisBegin:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) IBOutlet UIImageView *eventButIcon;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *thedatePicker;
- (IBAction)dateDone:(id)sender;
- (IBAction)chooseEndButton:(id)sender;
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
@property (strong, nonatomic) IBOutlet UITextField *eventDescription;
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
NSString *timestampStart;

@implementation CONINVITEEDITEVENTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    NSString *event_ID = [userdefaults objectForKey:@"CON96EventID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];

    
    _eventTitle.text = [json valueForKey:@"title"];
    _eventDescription.text = [json valueForKey:@"description"];
   // [_locationButton setTitle:[json valueForKey:@"location_name"] forState:UIControlStateNormal];
    //[_dtButton setTitle:@"date/time" forState:UIControlStateNormal];
    /*NSString *privacyOption = [json valueForKey:@"privacy"];
    
    
    if([privacyOption isEqualToString:@"public"]){
        [self privacyAnyone:self];
    } else if([privacyOption isEqualToString:@"private"]){
        [self privacyInvite:self];
    } else if([privacyOption isEqualToString:@"me"]){
        [self privacyMe:self];
    }*/
    [_attendButton setTitle:@"Invite more friends" forState:UIControlStateNormal];
    [_privButton setTitle:@"Change Privacy Settings" forState:UIControlStateNormal];
    NSArray *inviteArrNames = [defaults objectForKey:@"ConInviteesNames"];
    NSString *locationName = [defaults objectForKey:@"CON96LName"];
    
    if(inviteArrNames == nil){
        NSLog(@"No Invitees");
    }
    else
    {
        NSLog(@"DAMMMMN GIRL WE HAVE INVITEES");
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NSObject * obj in inviteArrNames)
            
        {
            
            [result appendString:[NSString stringWithFormat:@"%@, ",[obj description]]];
            
        }
        NSLog(@"The concatenated string is %@", result);
        
        NSString *finalStr = [NSString stringWithFormat:@"Invited: %@",[inviteArrNames componentsJoinedByString:@" & "]];
        
        
        [result autorelease];
        
        
        
        int arraycount = [inviteArrNames count];
        if(arraycount == 0){
            
        }
        else if(arraycount == 1){
            //NSString *finalString = [NSString stringWithFormat:@"%@",inviteArrNames];
            [_attendButton setTitle:finalStr forState:UIControlStateNormal];
        }else{
            NSString *finalString = [NSString stringWithFormat:@"Invited: %@ and %d others",[inviteArrNames objectAtIndex:1], arraycount-1];
            [_attendButton setTitle:finalString forState:UIControlStateNormal];
        }
        
    }
    
    if(locationName == nil){
        
    } else {
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *event_id = [defaults objectForKey:@"CON96EventID"];
        //NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
        
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
        NSString *lat1 = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"CON96LAT"]];
        
        NSString *long1 = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"CON96LNG"]];
        
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: lat1, @"lat", long1, @"long",locationName , @"location_name" ,nil];
        
        NSLog(@"JSON: %@", newDatasetInfo);
        
        
        NSError *error;
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
        
        NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        NSLog(@"Altered Json: %@", editeddata);
        
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

        
        
        
        
        [_locationButton setTitle:locationName forState:UIControlStateNormal];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"CONInvitees"];
    [defaults setObject:nil forKey:@"ConInviteesNames"];
    [defaults setObject:nil forKey:@"CON96LNG"];
    [defaults setObject:nil forKey:@"CON96LNG"];
    [defaults setObject:nil forKey:@"CON96LName"];
    [defaults setObject:nil forKey:@"CONInviteAlready"];
    [defaults setObject:nil forKey:@"CONInviteAlreadyNames"];
    [defaults setObject:@"public" forKey:@"CONPrivicy"];
    [defaults synchronize];
    
    _eventOwner.text = [NSString stringWithFormat:@"Event Owner: %@", [defaults objectForKey:@"CON96users_name"]];
    /* NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:@"" forKey:@"CONInvitees"];
     [defaults setObject:@"" forKey:@"ConInviteesNames"];
     [defaults synchronize];*/
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    
    _eventOwner.font = [UIFont fontWithName:@"Roboto-Light" size:8];
    _eventTitle.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventTitle.leftView = paddingView;
    _eventTitle.leftViewMode = UITextFieldViewModeAlways;
    _eventLocation.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventDescription.leftView = paddingsView;
    _eventDescription.leftViewMode = UITextFieldViewModeAlways;
    [paddingsView release];
    [paddingView release];
    _eventDescription.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    // _eventDescription.leftView = paddingView;
    // _eventDescription.leftViewMode = UITextFieldViewModeAlways;
    [_dtButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _dtButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _dtButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_locationButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _locationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_privButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _privButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _privButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_attendButton.titleLabel setFont: [UIFont fontWithName:@"Roboto-Light" size:12]];
    _attendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _attendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	// Do any additional setup after loading the view.
    // [paddingView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"CONInvitees"];
    [defaults setObject:nil forKey:@"ConInviteesNames"];
    [defaults synchronize];
    
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
    _endDateView.hidden = YES;
    UIDatePicker *datePicker = _datePicker;
    UIDatePicker *enddatePicker = _endDatePicker;
    NSDate *pickerdate = [datePicker date];
    NSDate *pickerendingdate = [enddatePicker date];
    
    NSString *pickeraltdate = [NSString stringWithFormat:@"%@", pickerdate];
    
    NSString *pickerenddate = [NSString stringWithFormat:@"%@", pickerendingdate];
    
    NSTimeInterval timestamp = [pickerdate timeIntervalSince1970];
    timestampStart = [NSString stringWithFormat:@"%f", timestamp];
    
    // Calculate Start Date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
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
    
    // Calculate End Date
    
    NSString *enddate = pickerenddate;
    NSDate *endingdate = [dateFormatter dateFromString:enddate];
    NSDateComponents *endcomponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:endingdate];
    NSInteger endhour = [endcomponents hour];
    NSInteger endday = [endcomponents day];
    NSInteger enddaymonth = [endcomponents month];
    // NSInteger DayYear = [components year];
    NSInteger endminute = [endcomponents minute];
    [dateFormatter release];
    {
        //calculate start suffix
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
        
        
        {
            //caulcate end suffix
            NSString *endsuffix;
            int ones = endday % 10;
            int temp = floor(endday/10.0);
            int tens = temp%10;
            
            if (tens ==1) {
                endsuffix = @"th";
            } else if (ones ==1){
                endsuffix = @"st";
            } else if (ones ==2){
                endsuffix = @"nd";
            } else if (ones ==3){
                endsuffix = @"rd";
            } else {
                endsuffix = @"th";
            }
            
            //   NSString *completeAsString = [NSString stringWithFormat:@"%d%@",day,suffix];
            
            
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            NSString *monthName = [[df monthSymbols] objectAtIndex:(daymonth-1)];
            NSString *endmonthName = [[df monthSymbols] objectAtIndex:(enddaymonth-1)];
            
            //we need to format it if it's 05 past or 00 minutes past
            
            NSString *altmin = [NSString stringWithFormat:@"%ld",(long)minute];
            
            if ([altmin isEqualToString:@"5"]) {
                altmin = @"05";
            } else if ([altmin isEqualToString:@"0"]) {
                altmin = @"00";
            }
            
            NSString *endaltmin = [NSString stringWithFormat:@"%ld",(long)endminute];
            
            if ([endaltmin isEqualToString:@"5"]) {
                endaltmin = @"05";
            } else if ([endaltmin isEqualToString:@"0"]) {
                endaltmin = @"00";
            }
            
            _eventButIcon.hidden = YES;
            NSString *newDate = [NSString stringWithFormat:@"event on: %ld%@ %@ at %ld:%@ until %ld%@ %@ at %ld:%@",(long)day,suffix,monthName,(long)hour,altmin, (long)endday, endsuffix, endmonthName, (long)endhour, endaltmin];
            
            [_dtButton setTitle:newDate forState:UIControlStateNormal];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *event_id = [defaults objectForKey:@"CON96EventID"];
            //NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
            
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
            
            UIDatePicker *datePicker = _datePicker;
            NSDate *pickerdate = [datePicker date];
            UIDatePicker *enddatePicker = _endDatePicker;
            NSDate *endpickerdate = [enddatePicker date];
            
            //  NSString *pickeraltdate = [NSString stringWithFormat:@"%@", pickerdate];
            
            NSTimeInterval timestamp = [pickerdate timeIntervalSince1970];
            NSString *timestampStarts = [NSString stringWithFormat:@"%f", timestamp];
            
            NSTimeInterval endtimestamp = [endpickerdate timeIntervalSince1970];
            NSString *timestampEnds = [NSString stringWithFormat:@"%f", endtimestamp];
            
            NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: timestampEnds ,@"time_of_event_end", timestampStarts , @"time_of_event" ,nil];
            
            NSLog(@"JSON: %@", newDatasetInfo);
            
            
            NSError *error;
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
            
            NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
            NSLog(@"Altered Json: %@", editeddata);
            
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
            
            
        }
    }
}

- (IBAction)inviteFriends:(id)sender {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    NSString *event_ID = [userdefaults objectForKey:@"CON96EventID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/attendees/%@", event_ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    

    NSArray *alreadyInvited = [json valueForKey:@"attendees"];
    NSArray *invitedUID = [alreadyInvited valueForKey:@"uid"];
    [userdefaults setObject:invitedUID forKey:@"CONInviteEdit"];
    [userdefaults synchronize];
    [self  performSegueWithIdentifier:@"inviteFriends" sender:self];
}

- (IBAction)privacyMe:(id)sender {
    [_privButton setTitle:@"privacy: Only Me" forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
   // NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"me" , @"privacy" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
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
    [defaults setObject:@"me" forKey:@"CONPrivicy"];
    [defaults synchronize];
    
    _privicyMenu.hidden = YES;
    _attendButton.enabled = false;
}

- (IBAction)privacyInvite:(id)sender {
    [_privButton setTitle:@"privacy: Only People I Invite" forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"private" , @"privacy" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
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
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"private" forKey:@"CONPrivicy"];
    [defaults synchronize];
    _privicyMenu.hidden = YES;
    _attendButton.enabled = YES;
}

- (IBAction)privacyAnyone:(id)sender {
    [_privButton setTitle:@"privacy: Anyone Can Attend" forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
    //NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"public" , @"privacy" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
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
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"public" forKey:@"CONPrivicy"];
    [defaults synchronize];
    _privicyMenu.hidden = YES;
    _attendButton.enabled = YES;
}

- (IBAction)closePrivicy:(id)sender {
    _privicyMenu.hidden = YES;
}

- (IBAction)choosePrivicy:(id)sender {
    _privicyMenu.hidden = NO;
}
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    
    
}
- (IBAction)createEvent:(id)sender {
    NSLog(@"Time to create the event");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
    //NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys: _eventDescription.text ,@"description" , _eventTitle.text ,@"title" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
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
    
    
    //  [jsonData release];
    [self closeView:self];
    
}
- (IBAction)chooseEndButton:(id)sender {
    _thedatePicker.hidden = YES;
    _endDateView.hidden = NO;
}

- (IBAction)chooseLocation:(id)sender {
    NSLog(@"Opening Location Search Viewer");
    [self performSegueWithIdentifier:@"searchLocation" sender:self];
}

- (IBAction)eventDescEdit:(id)sender {
    if([_eventDescription.text isEqualToString:@""]){
        _eventDescription.text = @"event description";
    } else {
        
    }
    
}

- (IBAction)EventDisBegin:(id)sender {
    if([_eventDescription.text isEqualToString:@"event description"]){
        _eventDescription.text = @"";
    } else {
        
    }
    
}
@end