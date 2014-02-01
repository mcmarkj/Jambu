//
//  LoginViewController.h
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 21/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
@interface LoginViewController : UIViewController
{
        NSString *username;
    BOOL *login;
    NSInteger intTmp;
    IBOutlet UIButton *twitterlogin;
}
- (IBAction)fakelogin:(UIButton *)sender;
@property (nonatomic, retain) NSString *username;
@end
