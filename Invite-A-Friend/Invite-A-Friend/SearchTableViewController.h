//
//  SearchTableViewController.h
//  twitter search
//
//  Created by Planet1107 on 10/28/11.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tweets;
    UISearchBar *searchBar;
    UITableView *tableV;
    NSMutableData *responseData;
    UIActivityIndicatorView *indicator;
}

@property (retain) NSArray *tweets;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UITableView *tableV;
@property (assign) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
