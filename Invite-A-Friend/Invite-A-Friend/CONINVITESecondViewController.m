//
//  CONINVITESecondViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITESecondViewController.h"

@interface CONINVITESecondViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)createEvent:(id)sender;
- (IBAction)nearbyevents:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *minsLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;

@end

@implementation CONINVITESecondViewController

- (void)viewDidLoad
{

    

    self.Scroller.contentSize =CGSizeMake(324, 464);
        [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    _hoursLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _minsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
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
