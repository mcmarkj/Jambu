//
//  CONINVITEViewEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/04/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEViewEventViewController.h"
#include <math.h>

@interface CONINVITEViewEventViewController ()
@property (strong, nonatomic) IBOutlet UIButton *viewEventButton;
- (IBAction)editEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *eventNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *EventName;
@property (strong, nonatomic) IBOutlet UILabel *eventDetails;
@property (strong, nonatomic) IBOutlet UIImageView *invitee_image;
@property (strong, nonatomic) IBOutlet UILabel *minsLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UILabel *eventStartslabel;
@property (strong, nonatomic) IBOutlet UILabel *eventEndslabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDaylabel;
@property (strong, nonatomic) IBOutlet UILabel *eventEnddaylabel;
@property (strong, nonatomic) IBOutlet UILabel *eventStartTimelabel;
@property (strong, nonatomic) IBOutlet UILabel *eventEndTimelabel;
@property (strong, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) IBOutlet GMSCameraPosition *camera;
@property (strong, nonatomic) IBOutlet UIView *RSVPWindow;
- (IBAction)closeWindow:(id)sender;
- (IBAction)user_attending:(id)sender;
- (IBAction)user_notattending:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *RSVPButton;
- (IBAction)RSVPClick:(id)sender;


@end

@implementation CONINVITEViewEventViewController


-(void)viewDidAppear:(BOOL)animated
{
    //[self viewDidAppear];
    [self checkifattending];
}


- (void)viewDidLoad
{
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

    
    
    //NSString *imageurl = [userdefaults objectForKey:@"Con96UIMG"];
    
    NSString *lat = [json valueForKey:@"lat"];
    NSString *lng = [json valueForKey:@"long"];
    
    //Let's determine if we're the event owners
    
    
        NSString *myAID = [userdefaults valueForKey:@"Con96AID"];
        NSString *eventAID = [json valueForKey:@"user_id"];
        
        if(myAID == eventAID){
            _viewEventButton.hidden = NO;
                [_RSVPButton setTitle:@"Cancel Event" forState:UIControlStateNormal];
        } else {
            _viewEventButton.hidden = YES;
        }
        
    
    
    
    // long long latat = [lat longLongValue];
    //long long longa = [lng longLongValue];
    
    
    
    self.camera = [GMSCameraPosition cameraWithLatitude:[lat floatValue]
                                              longitude:[lng floatValue] zoom:14
                                                bearing:0
                                           viewingAngle:0
                   ];
    
    self.mapView = [GMSMapView mapWithFrame:_viewForMap.bounds camera:_camera];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
    marker.title = [json valueForKey:@"title"];
    marker.snippet = _eventLocationLabel.text;
    marker.map = _mapView;
    
    
    self.mapView.delegate = self;
    
    
    [self.viewForMap addSubview:_mapView];
    
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    
    
    _hoursLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _minsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _EventName.font = [UIFont fontWithName:@"Roboto-Light" size:22];
    
    _EventName.text = [json valueForKey:@"title"];
    _eventLocationLabel.text = [json valueForKey:@"location_name"];
    
    _eventLocationLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:18];
    _eventDaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
    
    
    _eventDetails.font = [UIFont fontWithName:@"Roboto-Light" size:11];
    _eventDetails.text = [NSString stringWithFormat:@"\"%@\"", [json valueForKey:@"description"]];
    
    
    
    _eventEnddaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:3];
    _eventEnddaylabel.enabled = TRUE;
    _eventEndslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventEndTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    
    {
        
        //Calculate Starting Time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        double timestampval =  [[json valueForKey:@"time_of_event"] doubleValue];
        NSTimeInterval timestamp = (NSTimeInterval)timestampval;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSInteger daydate = [components day];
        //  NSInteger AMPM = [components]
        
        
        {
            //Calculate Day of the Week
            NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
            [weekDay setDateFormat:@"EEEE"];
            
            _eventDaylabel.text = [weekDay stringFromDate:date];
        }
        
        
        
        
        NSString *altminute = @"00";
        
        if(minute == 0){
            altminute = @"00";
        } else {
            altminute = [NSString stringWithFormat:@"%ld", (long)minute];
        }
        
        if(hour < 12) {
            NSString *ampmtime = @"AM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%@ %@", (long)hour, altminute, ampmtime];
            _eventStartTimelabel.text = completedhour;
        } else if (hour <=23) {
            NSString *ampmtime = @"PM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%@ %@", (long)hour, altminute, ampmtime];
            _eventStartTimelabel.text = completedhour;
        }
        NSString *sthour = [NSString stringWithFormat:@"%ld", (long)daydate];
        [userdefaults setObject:sthour forKey:@"constart"];
        [userdefaults synchronize];
        
        
        //NSInteger minute = [components minute];
    }
    
    
    
    
    
    {
        
        //Calculate Ending Time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        double timestampval =  [[json valueForKey:@"time_of_event_end"] doubleValue];
        NSTimeInterval timestamp = (NSTimeInterval)timestampval;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
    //    NSInteger daydate = [components day];
      //  NSInteger weekday = [components weekday];
        //  NSInteger AMPM = [components]
        
        NSString *altminute = @"00";
        
        {
            //Calculate Day of the Week
            NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
            [weekDay setDateFormat:@"EEEE"];
            
           _eventEnddaylabel.text = [weekDay stringFromDate:date];
        }
        
        
        
        
        if(minute == 0){
            altminute = @"00";
        } else {
            altminute = [NSString stringWithFormat:@"%ld", (long)minute];
        }
        
        if(hour < 12) {
            NSString *ampmtime = @"AM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%@ %@", (long)hour, altminute, ampmtime];
            _eventEndTimelabel.text = completedhour;
        } else if (hour <=23) {
            NSString *ampmtime = @"PM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%@ %@", (long)hour, altminute, ampmtime];
            _eventEndTimelabel.text = completedhour;
        }

        
        
        //NSInteger minute = [components minute];
    }
    
    
    
        
        //NSInteger minute = [components minute];
    
    
    { //Get user's image
        
        NSString *ID = [json valueForKey:@"user_id"];
        
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/image_from_id/%@", ID]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
        
        
        _invitee_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"url"]]]];
        
    }
    
    {
        //Calculate Minutes / Hours
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    
    double timestampend =  [[json valueForKey:@"time_of_event"] doubleValue];
    NSTimeInterval timestampending = (NSTimeInterval)timestampend;
    NSDate *endingDate = [NSDate dateWithTimeIntervalSince1970:timestampending];

    
    
  //  NSDate *endingDate = [dateFormatter dateFromString:eventdate];
    NSDate *startingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    NSInteger hours = [dateComponents hour];
    NSInteger mins    = [dateComponents minute];
    NSInteger days = [dateComponents day];
    
    
    if(days<=0 & hours<=0 & mins<=0){
        
        //THERE"S NO EVENT!
        
    } else if(days>=1)
    {    NSString *eventHour = [NSString stringWithFormat:@"%ld", (long)hours];
        NSString *eventday = [NSString stringWithFormat:@"%ld", (long)days];
        
        
        _hoursLabel.text = @"Days";
        _minsLabel.text = @"Hours";
        _eventHour.text = eventday;
        _eventMinute.text = eventHour;
        _eventMinute.textColor = [UIColor whiteColor];
        _eventHour.textColor = [UIColor whiteColor];
    }
else {
        
        
        NSString *eventHour = [NSString stringWithFormat:@"%ld", (long)hours];
        NSString *eventMin = [NSString stringWithFormat:@"%ld", (long)mins];
        
        if([eventHour isEqual:@"0"]) {
            //we're not doing anything as we want it to stay as 0
            _hoursLabel.text = @"Hours";
        } else {
            if([eventHour isEqual:@"1"]){
                _hoursLabel.text = @"Hour";
            }
            _eventHour.text = eventHour;
            _eventHour.textColor = [UIColor whiteColor];
        }
        
        if([eventMin isEqual:@"0"]) {
            _minsLabel.text = @"Minutes";
            //we're not doing aything as we want it to stay as 0
        } else {
            if([eventMin isEqual:@"1"]){
                _minsLabel.text = @"Minute";
            }
            
            _eventMinute.textColor = [UIColor whiteColor];
            _eventMinute.text = eventMin;
        }
        
    }}
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (IBAction)closeWindow:(id)sender {
    _RSVPWindow.hidden= YES;
}

- (IBAction)user_attending:(id)sender {
    NSLog(@"User is attending");
    NSLog(@"Let's connect to API");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/rsvp/%@", @""]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:  @"true" , @"going?" , user_id , @"uid" , event_id , @"event_id" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];    _RSVPWindow.hidden= YES;
    [_RSVPButton setTitle:@"Going" forState:UIControlStateNormal];
}

- (IBAction)user_notattending:(id)sender {
    NSLog(@"User isn't attending");    NSLog(@"Let's connect to API");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *event_id = [defaults objectForKey:@"CON96EventID"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Con96TUID"]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/rsvp/%@", @""]];
    
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:  @"false" , @"going?" , user_id , @"uid" , event_id , @"event_id" ,nil];
    
    NSLog(@"JSON: %@", newDatasetInfo);
    
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSString *editeddata = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSLog(@"Altered Json: %@", editeddata);
    
    NSData* finaldata = [editeddata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:finaldata];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // DISABLED WHILE WE CONFIGURE STUFF
    
    NSLog(@"We're now collecting to the API");
    
    [connection start];
    _RSVPWindow.hidden= YES;
        [_RSVPButton setTitle:@"Not Going" forState:UIControlStateNormal];
}


-(void)checkifattending{
    // http://amber.concept96.co.uk/api/v1/attendees/
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *event_ID = [userdefaults objectForKey:@"CON96EventID"];
        NSString *UID = [userdefaults objectForKey:@"Con96TUID"];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/attendees/%@", event_ID]];
    
    NSLog(@"URL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *atendees = [json valueForKey:@"attendees"];
    NSArray *atendeeIDs = [atendees valueForKey:@"uid"];

    NSString *altUID = [NSString stringWithFormat:@"%@", UID];
    
    if([atendeeIDs containsObject:altUID]){
                [_RSVPButton setTitle:@"Going" forState:UIControlStateNormal];
    } else {
                [_RSVPButton setTitle:@"Not Going" forState:UIControlStateNormal];
    }
    
    
    
    
}



- (IBAction)RSVPClick:(id)sender {
    NSString *RSVPTitle = _RSVPButton.titleLabel.text;
    
    if([RSVPTitle isEqual:@"Cancel Event"]){
        NSLog(@"Cancel Clicked");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *event_id = [defaults objectForKey:@"CON96EventID"];

        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://amber.concept96.co.uk/api/v1/events/%@", event_id]];
        NSLog(@"URL: %@", url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:url];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:NULL];

        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        // DISABLED WHILE WE CONFIGURE STUFF
        
        NSLog(@"We're now collecting to the API");
        
        [connection start];
        [self closeView:self];
    } else {
    
        _RSVPWindow.hidden = NO;
    }
}

- (IBAction)editEvent:(id)sender {
    [self  performSegueWithIdentifier:@"editEvent" sender:self];
    
}
@end
