//
//  AppDelegate.h
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoopBack/LoopBack.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// The shared LBRESTAdapter instance, configured by Settings.plist.
@property (strong, nonatomic) LBRESTAdapter *adapter;

// Loads the values in Settings.plist.
- (NSDictionary *)loadSettings;

@end
