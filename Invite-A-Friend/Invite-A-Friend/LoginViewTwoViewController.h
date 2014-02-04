//
//  LoginViewTwoViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 25/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewTwoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *UserImage1;
@property (strong, nonatomic) IBOutlet UIImageView *UserImage3;
@property (strong, nonatomic) IBOutlet UIImageView *UserImage2;
@property (strong, nonatomic) IBOutlet UIImageView *UserImage4;
@property (strong, nonatomic) IBOutlet UIImageView *UserImage5;

- (IBAction)setRed:(id)sender;
- (IBAction)setBlue:(id)sender;
- (IBAction)setPink:(id)sender;
- (IBAction)setGreen:(id)sender;
- (IBAction)setPurple:(id)sender;


@end
