//
//  CONINVITEFirstViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEFirstViewController.h"

@interface CONINVITEFirstViewController ()
@property (strong, nonatomic) IBOutlet UILabel *overlaylabel;
@property (strong, nonatomic) IBOutlet UILabel *overlaynexteventlabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventdatelabel;
@property (strong, nonatomic) IBOutlet UILabel *overlayeventattendeeslabel;

@end

@implementation CONINVITEFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _overlaylabel.font = [UIFont fontWithName:@"Roboto-Light" size:28];
    
    _overlaynexteventlabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    _overlayeventdatelabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
       _overlayeventattendeeslabel.font = [UIFont fontWithName:@"Roboto-Light" size:9];
    
        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)updateCountdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *endingDate = [dateFormatter dateFromString:@"2014-01-19"];
    NSDate *startingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    NSInteger hours    = [dateComponents hour];
    
        NSString *countdownText = [NSString stringWithFormat:@"Your next event is in %d Hours", hours];
        _overlaynexteventlabel.text = countdownText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
