//
//  CONINVITEListEventsViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 05/05/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONINVITEListEventsViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tweets;
    NSArray *friends;
    UISearchBar *searchBar;
    UITableView *tableV;
    NSMutableData *responseData;
    UIActivityIndicatorView *indicator;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchOption;
@property (retain) NSArray *tweets;
@property (retain) NSArray *friends;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UITableView *tableV;
@property (assign) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *yourimageview;

@end
