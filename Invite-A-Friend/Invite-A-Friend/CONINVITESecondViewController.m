//
//  CONINVITESecondViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITESecondViewController.h"
#import <GoogleMaps/GoogleMaps.h>

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

@end

@implementation CONINVITESecondViewController

- (void)viewDidLoad
{
    self.camera = [GMSCameraPosition cameraWithLatitude:53.792336
                                              longitude:-1.534171 zoom:18
                                                bearing:0
                                           viewingAngle:0
                   ];
    
    self.mapView = [GMSMapView mapWithFrame:_viewForMap.bounds camera:_camera];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(53.792336, -1.534171);
    marker.title = @"Mark's Flat";
    marker.snippet = @"Leeds";
    marker.map = _mapView;
    
    
    self.mapView.delegate = self;

    
    [self.viewForMap addSubview:_mapView];
    
        [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    _hoursLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _minsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _EventName.font = [UIFont fontWithName:@"Roboto-Light" size:22];
    _eventLocationLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:18];
    _eventDaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
    _eventDetails.font = [UIFont fontWithName:@"Roboto-Light" size:11];
    _eventEnddaylabel.font = [UIFont fontWithName:@"Roboto-Medium" size:3];
    _eventEnddaylabel.enabled = TRUE;
    _eventEndslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventEndTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartslabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    _eventStartTimelabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    
     NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *imageurl = [userdefaults objectForKey:@"Con96UIMG"];
    _invitee_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]];
    NSString *eventHour = @"11";
    NSString *eventMin = @"0";
    
    if([eventHour isEqual:@"0"]) {
      //we're not doing anything as we want it to stay as 0
                    _hoursLabel.text = @"Hour";
    } else {
        if([eventHour isEqual:@"1"]){
            _hoursLabel.text = @"Hour";
        }
        _eventHour.text = eventHour;
        _eventHour.textColor = [UIColor whiteColor];
    }
    
    if([eventMin isEqual:@"0"]) {
                    _minsLabel.text = @"Minute";
     //we're not doing aything as we want it to stay as 0
    } else {
        if([eventMin isEqual:@"1"]){
            _minsLabel.text = @"Minute";
        }

        _eventMinute.textColor = [UIColor whiteColor];
        _eventMinute.text = eventMin;
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
@end
