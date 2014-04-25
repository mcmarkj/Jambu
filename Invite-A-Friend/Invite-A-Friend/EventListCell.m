//
//  EventListCell.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 25/04/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "EventListCell.h"

@implementation EventListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
