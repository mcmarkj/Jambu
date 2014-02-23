//
//  FriendFeed.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *twitternameLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterUserName;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
