//
//  WelcomeViewController.m
//  loopback-ios-multi-model
//
//  Created by Matt Schmulen on 8/14/13.
//  Copyright (c) 2013 StrongLoop All rights reserved.
//

/*
 
 Welcome to LoopBack StrongLoop Node.js and LoopBack
 
 To Get Started make sure you have the latest version of the StrongLoop Distro ( http://strongloop.com/products ) intalled on your machine
 
 Verify installation and version from the command line with $slnode version
 
 Run this getting started application Running the application in the iOS Simulator ( CMD+R )
 
*/

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (IBAction)StartWithTab1:(id)sender {
    // Start with Tab1, push the user to the next tab
    [self.tabBarController setSelectedIndex:1];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
