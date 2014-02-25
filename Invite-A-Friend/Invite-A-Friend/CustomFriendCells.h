//
//  CustomFriendCells.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomFriendCells : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backgroundColour;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *twitternameLabel;
- (IBAction)buttonPressed:(id)sender;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
