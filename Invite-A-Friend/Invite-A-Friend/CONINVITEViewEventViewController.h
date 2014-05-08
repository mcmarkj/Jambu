//
//  CONINVITEViewEventViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/04/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CONINVITEViewEventViewController : UIViewController <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *eventHour;
@property (strong, nonatomic) IBOutlet UILabel *eventMinute;
@property (strong, nonatomic) IBOutlet UIView *viewForMap;

@end
