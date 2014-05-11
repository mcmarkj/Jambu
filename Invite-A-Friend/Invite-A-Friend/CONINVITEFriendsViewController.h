//
//  CONINVITEFriendsViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 19/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface CONINVITEFriendsViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tweets;
    UISearchBar *searchBar;
    UITableView *tableV;
    NSMutableData *responseData;
    UIActivityIndicatorView *indicator;
}

@property (strong, nonatomic) IBOutlet UIImageView *profilecolourimage;
@property (strong, nonatomic) IBOutlet UILabel *toptitle;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, retain) NSArray *pageTitles;
@property (strong, retain) NSArray *pageImages;
@property (strong, nonatomic) IBOutlet UILabel *profilelabel1;
@property (strong, nonatomic) IBOutlet UILabel *profilelabel2;
@property (strong, nonatomic) IBOutlet UILabel *profilelabel3;
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
- (IBAction)editpress:(id)sender;
- (IBAction)listfriends:(id)sender;

@end
