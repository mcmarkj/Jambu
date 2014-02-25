//
//  CONINVITEViewFriendViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 02/02/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONINVITEViewFriendViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tweets;
    UISearchBar *searchBar;
    UITableView *tableV;
    NSMutableData *responseData;
    UIActivityIndicatorView *indicator;

        IBOutlet UIButton *addFriend;
}
@property (strong, nonatomic) IBOutlet UIImageView *profilecolourimage;

@property (strong, nonatomic) IBOutlet UIImageView *UserImage;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *UserTwitterName;
@property (strong, nonatomic) IBOutlet UILabel *UserEventInvites;
@property (strong, nonatomic) IBOutlet UIButton *UserFriendCount;
@property (strong, nonatomic) IBOutlet UILabel *UserEventsAttended;
@property (retain) NSArray *tweets;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UITableView *tableV;
@property (assign) NSMutableData *responseData;

- (IBAction)searchPress:(id)sender;
- (IBAction)closeView:(id)sender;

- (IBAction)showFriends:(id)sender;

@end
