//
//  CONINVITEFirstViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONINVITEFirstViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserTwitterLabel;
@property (strong, nonatomic) IBOutlet UIImageView *UserImage;
@property (strong, nonatomic) IBOutlet UILabel *UserEventsLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserEventsAttendedLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserFacebookFriendsLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserRewardsLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserCardSplitLabels;
@property (strong, nonatomic) IBOutlet UILabel *UserCardSplitLabels1;
@property (strong, nonatomic) IBOutlet UILabel *UserCardSplitLabels2;
@property (strong, nonatomic) IBOutlet UILabel *UserCardSplitLabels3;

@property (strong, nonatomic) IBOutlet UILabel *UserIndicatorImage;
@property (strong, nonatomic) IBOutlet UIButton *UserIndicatorButton;

@end
