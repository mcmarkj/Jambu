//
//  FriendFeed.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "FriendFeedCell.h"

@implementation FriendFeedCell
@synthesize nameLabel = _nameLabel;
@synthesize twitternameLabel = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize twitterUserName = _twitterUserName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
