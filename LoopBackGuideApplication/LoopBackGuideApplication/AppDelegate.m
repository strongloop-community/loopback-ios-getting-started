//
//  AppDelegate.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceModel.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Handle APN on Terminated state, app launched because of APN
	NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (payload) {
        NSLog(@"Payload from notification: %@", @"payload");
    }

    NSDictionary *settings = [self loadSettings];

    // Instantiate the shared LBRESTAdapter. In most circumstances, you'll do this only once; putting that reference in a
    // singleton is recommended for the sake of simplicity. However, some applications will need to talk to more than one
    // server - create as many Adapters as you need.
    self.adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:settings[@"RootPath"]]];

    // This boilerplate is required for Lesson Three.
    [self.adapter.contract addItem:[SLRESTContractItem itemWithPattern:@"locations/nearby" verb:@"GET"] forMethod:@"locations.nearby"];

    return YES;
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

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    [DeviceModel register:deviceToken adapter:self.adapter];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Detect if APN is received on Background or Foreground state
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Inactive - User info: %@", userInfo);
    }
    else if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"Active - User info: %@", userInfo);
    }
}


- (NSDictionary *)loadSettings {
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
