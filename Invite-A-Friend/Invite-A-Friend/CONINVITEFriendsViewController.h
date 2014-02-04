//
//  CONINVITEFriendsViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 19/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONINVITEFriendsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilecolourimage;

@property (strong, nonatomic) IBOutlet UIImageView *UserImage;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *UserTwitterName;
@property (strong, nonatomic) IBOutlet UILabel *UserEventInvites;
@property (strong, nonatomic) IBOutlet UILabel *UserFriendCount;
@property (strong, nonatomic) IBOutlet UILabel *UserEventsAttended;
- (IBAction)searchPress:(id)sender;
- (IBAction)editpress:(id)sender;

@end
