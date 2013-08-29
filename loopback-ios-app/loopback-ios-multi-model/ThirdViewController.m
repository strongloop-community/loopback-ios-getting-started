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
@property (nonatomic) CLLocation *location;
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
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
        //[[[UIApplication sharedApplication] delegate] showGuideMessage:@"No Server Found"];
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^staticMethodSuccessBlock)() = ^(id result) {
        NSLog(@"Got result: %@", result);

        //NSLog( @"selfSuccessBlock %d", models.count);
        //self.tableData  = models;
        //[self.myTableView reloadData];
        // [self showGuideMessage:@"Great! you just pulled code from node"];
    };//end selfSuccessBlock
    
    //Get a local representation of the 'products' model type
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"locations"];
    [[self.adapter contract] addItem:[SLRESTContractItem itemWithPattern:@"/locations/nearby" verb:@"GET"] forMethod:@"locations.nearby"];

    // Invoke the allWithSuccess message for the 'products' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/products
    
    //http://localhost:3000/cars/custommethod?arg1=yack&arg2=123
    //[objectB invokeStaticMethod:@"custommethod" parameters:@{@"arg1":@"yack" , @"arg2":@123} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    [objectB invokeStaticMethod:@"nearby"
                     parameters:@{
                            @"here": @{
                                @"lat": @(self.location.coordinate.latitude),
                                @"lng": @(self.location.coordinate.longitude)
                            }
                        }
                        success:staticMethodSuccessBlock
                        failure:staticMethodErrorBlock];
    
    //[objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    //[objectB custommethod: @"yack" loadSuccessBlock failure: loadErrorBlock];
}

- (IBAction)actionMethod2:(id)sender {
    
}
- (IBAction)actionMethod3:(id)sender {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Updated location.");
    self.location = (CLLocation *)[locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error in updating location: %@", error);
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

    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    manager.delegate = self;
    [manager startUpdatingLocation];

    // In the event the location services are disabled, start with a default location:
    self.location = [[CLLocation alloc] initWithLatitude:37.587409 longitude:-122.338225];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
