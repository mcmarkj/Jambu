//
//  CONINVITESecondViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITESecondViewController.h"
#include <math.h>

@interface CONINVITESecondViewController (
    
)
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)createEvent:(id)sender;
- (IBAction)nearbyevents:(id)sender;
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
- (IBAction)openMap:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *eventHider;
@property (strong, nonatomic) IBOutlet UIImageView *nope_image;

@end

@implementation CONINVITESecondViewController
-(void)viewDidLoad{
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    //NSString *imageurl = [userdefaults objectForKey:@"Con96UIMG"];
    
    NSString *lat = [userdefaults objectForKey:@"ConNextLat"];
        NSString *lng = [userdefaults objectForKey:@"ConNextLong"];
    
 

    
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
    marker.title = [userdefaults objectForKey:@"ConNextTitle"];
    marker.snippet = _eventLocationLabel.text;
    marker.map = _mapView;
    
    
    self.mapView.delegate = self;

    
    [self.viewForMap addSubview:_mapView];
    
    
    

    
	// Do any additional setup after loading the view, typically from a nib.
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    
    
    _hoursLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _minsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _EventName.font = [UIFont fontWithName:@"Roboto-Light" size:22];
   
    _EventName.text = [userdefaults objectForKey:@"ConNextTitle"];
    _eventLocationLabel.text = [userdefaults objectForKey:@"ConNextLocation"];
    
    _eventLocationLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:18];
    _eventDaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
    
    
    _eventDetails.font = [UIFont fontWithName:@"Roboto-Light" size:11];
    _eventDetails.text = [NSString stringWithFormat:@"\"%@\"", [userdefaults objectForKey:@"ConNextDesc"]];
    
    
    
    _eventEnddaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:3];
    _eventEnddaylabel.enabled = TRUE;
    _eventEndslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventEndTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];

    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *eventdate = [defaults objectForKey:@"ConNextEDate"];
        NSDate *date = [dateFormatter dateFromString:eventdate];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
            NSInteger minute = [components minute];
        NSInteger daydate = [components day];
      //  NSInteger AMPM = [components]
        if(hour < 12) {
            NSString *ampmtime = @"AM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%ld %@", (long)hour, (long)minute, ampmtime];
                    _eventStartTimelabel.text = completedhour;
        } else if (hour <=23) {
            NSString *ampmtime = @"PM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%ld %@", (long)hour, (long)minute, ampmtime];
                    _eventStartTimelabel.text = completedhour;
        }
        NSString *sthour = [NSString stringWithFormat:@"%ld", (long)daydate];
        [userdefaults setObject:sthour forKey:@"constart"];
        [userdefaults synchronize];
        
        {
            //Calculate Day of the Week
            NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
            [weekDay setDateFormat:@"EEEE"];
            
            _eventDaylabel.text = [weekDay stringFromDate:date];
        }
        
        //NSInteger minute = [components minute];
    }
    
    
    
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *eventdate = [defaults objectForKey:@"ConNextEnd"];
                NSString *sthour = [defaults objectForKey:@"constart"];
        int starthour = [sthour intValue];
        NSDate *date = [dateFormatter dateFromString:eventdate];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger daydate = [components day];
        NSInteger daymonth = [components month];
        NSInteger DayYear = [components year];
        NSInteger minute = [components minute];
        
    
        if(hour < 12) {
            NSString *ampmtime = @"AM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%ld %@", (long)hour, (long)minute, ampmtime];
            _eventEndTimelabel.text = completedhour;
        } else if (hour <=23) {
            NSString *ampmtime = @"PM";
            NSString *completedhour = [NSString stringWithFormat:@"%ld:%ld %@", (long)hour, (long)minute, ampmtime];
            _eventEndTimelabel.text = completedhour;
        }
        
        int datediff = (daydate - starthour);
        
        {
            //Calculate Day of the Week
            NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
            [weekDay setDateFormat:@"EEEE"];
            
            _eventEnddaylabel.text = [weekDay stringFromDate:date];
        }
        
        //NSInteger minute = [components minute];
    }
    
    {if(_eventHider.hidden == YES){
        
        NSLog(@"No event");
    } else {
         NSLog(@"There is an event");
    
        
        NSString *ID = [userdefaults objectForKey:@"ConNextUID"];
        
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
    }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *eventdate = [defaults objectForKey:@"ConNextEDate"];
        NSDate *endingDate = [dateFormatter dateFromString:eventdate];
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
    
    }

    NSString *theTitle = [defaults objectForKey:@"ConNextUID"];
    if(theTitle == Nil){
        _eventHider.hidden = NO;
    } else {
    _eventHider.hidden = YES;
    _nope_image.hidden = YES;
    }

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

- (IBAction)createEvent:(id)sender {
        [self  performSegueWithIdentifier:@"newEvent" sender:self];
}

- (IBAction)nearbyevents:(id)sender {
        [self  performSegueWithIdentifier:@"showNearby" sender:self];
}
- (IBAction)openMap:(id)sender {
    NSLog(@"Button pressed");
    exit(0);
}
@end
