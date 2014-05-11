//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *user_image;
@property (strong, nonatomic) IBOutlet UILabel *name_Label;
@property (strong, nonatomic) IBOutlet UILabel *twitter_Label;
@property (strong, retain) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property  NSUInteger pageIndex;
@property (strong, retain) NSString *titleText;
@property (strong, retain) NSString *imageFile;
@property (strong, retain) NSString *nameText;
@property (strong, retain) NSString *twitterText;
@end
