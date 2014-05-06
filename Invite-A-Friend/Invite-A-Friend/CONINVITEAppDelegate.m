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
#import <GoogleMaps/GoogleMaps.h>

@implementation CONINVITEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GMSServices provideAPIKey:@"AIzaSyDZrNf8eUHU7VAQuf1unCGvKrDewHooeaY"];
   [Crashlytics startWithAPIKey:@"55c3ecc37a3b972e490db29a097513baf77b6aea"];
                // Register with apple that this app will use push notification
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
          UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
     [TestFlight takeOff:@"dae0430e-bac8-49e4-9857-14f024fb9b28"];
    
    NSString *buildversion = @"1.0 Beta 1";
    NSLog(@"Welcome to Concept96's Project Invite, you're are on v%@", buildversion);
  /*  [[Crashlytics sharedInstance] crash];
    1/0; */
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        UIViewController *initialViewController = nil;
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main_4s" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        }
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    }
    

    
    // Assign tab bar item with titles
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];

    
    
   tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Events";
    tabBarItem3.title = @"My Profile";
    
      /* tabBarItem1.title = @"";
     tabBarItem2.title = @"";
     tabBarItem3.title = @""; */
    
    tabBarItem1.image = [UIImage imageNamed:@"home.png"];
    
    tabBarItem2.image = [UIImage imageNamed:@"diary.png"];
    
    tabBarItem3.image = [UIImage imageNamed:@"profile.png"];
    
    tabBarItem1.selectedImage = [UIImage imageNamed:@"home.png"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"diary.png"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"profile.png"];
   
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tab-back.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    


    return YES;
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationPayload) {
         NSLog(@"We have a push!");
        // Create a pointer so we can tell what type of notification it is
        NSString *pointerType = [notificationPayload objectForKey:@"p"];
        // Create a pointer so we can collect ID's or other data to open a particular event etc
        NSString *pointerID = [notificationPayload objectForKey:@"pid"];
        
    
        if([pointerType isEqualToString:@"eventUp"]){
            //Was an event Updated?
    
            NSString *eventID = pointerID;
            
        } else if ([pointerType isEqualToString:@"invite"]){
            //Was the user invited to an event?
        
            NSString *eventID = pointerID;
            
        } else if ([pointerType isEqualToString:@"foll"]){
            //Was the user followed by someone
            
            NSString *UserID = pointerID;
            
        } else if ([pointerType isEqualToString:@"inresp"]){
            //Did someone respond to an invite?
            
            NSString *eventID = pointerID;
        }
        
    
    }
    
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSDictionary *notificationPayload = [userInfo objectForKey:@"aps"];
    
    // the userInfo dictionary usually contains the same information as the notificationPayload dictionary above
     NSLog(@"We have a push notification!");
    
    NSString *alertMessage = [notificationPayload objectForKey:@"alert"];
    NSLog(@"The alert said %@", alertMessage);
    
    
}


    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
    {
        NSUInteger capacity = [deviceToken length] * 2;
        NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
        const unsigned char *dataBuffer = [deviceToken bytes];
        NSInteger i;
        for (i=0; i<[deviceToken length]; ++i) {
            [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
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