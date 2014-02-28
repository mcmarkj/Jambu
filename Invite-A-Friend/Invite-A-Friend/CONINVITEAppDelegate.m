//
//  CONINVITEAppDelegate.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 18/01/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEAppDelegate.h"
#import "CONINVITEFirstViewController.h"
#import "TestFlight.h"
#import <Crashlytics/Crashlytics.h>

@implementation CONINVITEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"55c3ecc37a3b972e490db29a097513baf77b6aea"];
                // Register with apple that this app will use push notification
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
          UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];

     [TestFlight takeOff:@"dae0430e-bac8-49e4-9857-14f024fb9b28"];
    
    // Assign tab bar item with titles
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];

    
    
    tabBarItem1.title = @"";
    tabBarItem2.title = @"";
    tabBarItem3.title = @"";
    
    
    
    tabBarItem1.image = [UIImage imageNamed:@"home.png"];
    
    tabBarItem2.image = [UIImage imageNamed:@"diary.png"];
    
    tabBarItem3.image = [UIImage imageNamed:@"profile.png"];
    
    
   
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tab-back.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    


    return YES;
}



    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
    {
        NSUInteger capacity = [deviceToken length] * 2;
        NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
        const unsigned char *dataBuffer = [deviceToken bytes];
        NSInteger i;
        for (i=0; i<[deviceToken length]; ++i) {
            [stringBuffer appendFormat:@"%02X", (NSUInteger)dataBuffer[i]];
        }
        NSLog(@"token string buffer is %@",stringBuffer);
        NSLog(@"token is %@",deviceToken);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:stringBuffer forKey:@"conDeviceToken"];
        [defaults synchronize];
    }
  
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end