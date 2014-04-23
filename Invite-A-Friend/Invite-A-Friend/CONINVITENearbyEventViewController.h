//
//  CONINVITENearbyEventViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 07/03/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CONINVITENearbyEventViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tweets;
    UISearchBar *searchBar;
    UITableView *tableV;
   // NSMutableData *responseData;
    UIActivityIndicatorView *indicator;
}

@property (retain) NSArray *tweets;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UITableView *tableV;
@property (assign) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *yourimageview;
- (IBAction)closeView:(id)sender;


@end
