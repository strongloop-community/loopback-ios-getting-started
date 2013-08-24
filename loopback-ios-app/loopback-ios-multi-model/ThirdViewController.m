//
//  ThirdViewController.m
//  loopback-ios-multi-model
//
//  Created by Matt Schmulen on 7/24/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"

@interface ThirdViewController ()
@property (weak, nonatomic) LBRESTAdapter *adapter;
@end

@implementation ThirdViewController


- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}


- (IBAction)actionMethod1:(id)sender {
    
    // ++++++++++++++++++++++++++++++++++++
    // Remove the Comment below to pull model instances from the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
        //[[[UIApplication sharedApplication] delegate] showGuideMessage:@"No Server Found"];
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        //self.tableData  = models;
        //[self.myTableView reloadData];
        // [self showGuideMessage:@"Great! you just pulled code from node"];
    };//end selfSuccessBlock
    
    //Get a local representation of the 'products' model type
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"products"];
    
    // Invoke the allWithSuccess message for the 'products' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/products
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    //[objectB custommethod: @"yack" loadSuccessBlock failure: loadErrorBlock];
}

- (IBAction)actionMethod2:(id)sender {
    
    
}

- (IBAction)actionMethod3:(id)sender {
    
    
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
    [AppDelegate showGuideMessage: @"Tab 'Three' Step3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
