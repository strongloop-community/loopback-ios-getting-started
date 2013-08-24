//
//  FirstViewController.m
//  loopback-ios-multi-model
//
//  Created by Matt Schmulen on 7/24/13.
//  Copyright (c) 2013 StrongLoop All rights reserved.
//


/*
 Tab 1, Step 1
 
 This Tab shows you how to Create Update and Delete Model types and persist to the LoopBack server
 
 Uncomment the code sections below to enable 
    - Referesh
    - Create
    - Update
    - Delete
 
 You will need to have your Loopback Node server running
 
 You can start your Loopback Node server from the command line terminal with $slnode run app.js from within the loopback-nodejs-server/ folder
 
 You can find developer doc's for LoopBack here:
    file://localhost/Users/mattschmulen/nodelife/strongloop/strongloop-mobile/loopback-clients/ios/docs/html/annotated.html
 
*/

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) LBRESTAdapter *adapter;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableDictionary *guide;
@end

@implementation FirstViewController

// The LBRESTAdapter defines the API server location endpoint for LoopBack server Calls
// file://localhost/loopback-clients/ios/docs/html/interface_l_b_r_e_s_t_adapter.html
- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}

- (NSArray *) tableData
{
    if ( !_tableData) _tableData = [[NSArray alloc] init];
    return _tableData;
};

- ( void ) getModels
{
    // ++++++++++++++++++++++++++++++++++++
    // Remove the Comment below to pull model instances from the server
    // ++++++++++++++++++++++++++++++++++++
    /*
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
        //[[[UIApplication sharedApplication] delegate] showGuideMessage:@"No Server Found"];
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        self.tableData  = models;
        [self.myTableView reloadData];
       // [self showGuideMessage:@"Great! you just pulled code from node"];
    };//end selfSuccessBlock
    
    //Get a local representation of the 'products' model type
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"products"];
    
    // Invoke the allWithSuccess message for the 'products' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/products
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    */
};


- ( void ) createNewModel
{
    // ++++++++++++++++++++++++++++++++++++
    // Remove the Comment below to create a new model instance on the server
    // ++++++++++++++++++++++++++++++++++++
    /*
    //Get a local representation of the 'products' model type
    LBModelPrototype *prototype = [self.adapter prototypeWithName:@"products"];
    
    //create new LBModel of type
    LBModel *model = [prototype modelWithDictionary:@{ @"name": @"new product" , @"inventory" : @"77" }];
    
    // Define the load error functional block
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error on Save %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
    };
    
    // Define the load success block for saveNewSuccessBlock message
    void (^saveNewSuccessBlock)() = ^() {
       NSLog( @"Create Success !" );
    };
    
    //Persist the newly created Model to the LoopBack node server
    [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    */
};

- ( void ) updateExistingModel
{
    // ++++++++++++++++++++++++++++++++++++
    // Remove the Comment below to 'Update' an existing model instance on the server
    // with a new paramater variable that is defined by the mobile client
    //
    // The ability to define your mobile schema from them mobile client allows your mobile client to create
    // new undefined parameter schemas easily through your mobile application dev cycle.
    // ++++++++++++++++++++++++++++++++++++
    /*
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error No model found with ID %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        //dynamically add an 'inventory' variable to this model type before saving it to the server
        model[@"inventory"] = @"22";
        
        //Define the save error block
        void (^saveErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^saveSuccessBlock)() = ^() {
            [AppDelegate showGuideMessage: @"Tab 'One' UpdateSuccess"];
        };
        [model saveWithSuccess:saveSuccessBlock failure:saveErrorBlock];
    };
    
    //Get a local representation of the 'products' model type
    LBModelPrototype *prototype = [self.adapter prototypeWithName:@"products"];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://localhost:3000/products/2
    [prototype findWithId:@2 success:findSuccessBlock failure:findErrorBlock ];
    */
}//end updateExistingModelAndPushToServer

- ( void ) deleteExistingModel
{
    /*
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error No model found with ID %@", error.description);
        [AppDelegate showGuideMessage: @"No Server Found"];
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        //dynamically add an 'inventory' variable to this model type before saving it to the server
        model[@"inventory"] = @"22";
        
        //Define the save error block
        void (^removeErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^removeSuccessBlock)() = ^() {
            [AppDelegate showGuideMessage: @"Tab 'One' UpdateSuccess"];
        };
        
        //[model saveWithSuccess:saveSuccessBlock failure:saveErrorBlock];
        //[self invokeMethod:@"remove" parameters:[self toDictionary] success:removeSuccessBlock failure:removeSuccessBlock];
    };
    
    //Get a local representation of the 'products' model type
    LBModelPrototype *prototype = [self.adapter prototypeWithName:@"products"];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://localhost:3000/products/2
    [prototype findWithId:@2 success:findSuccessBlock failure:findErrorBlock ];
    */
    
}//end deleteExistingModel

- (IBAction)actionRefresh:(id)sender {
     [self getModels];
}

- (IBAction)actionCreate:(id)sender {
    [self createNewModel];
}

- (IBAction)actionUpdate:(id)sender {
     [self updateExistingModel];
}

- (IBAction)actionDelete:(id)sender {
    [self deleteExistingModel];
}

// UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[LBModel class]])
    {
        LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
        cell.textLabel.text = model[@"name"]; // [model objectForKeyedSubscript:@"name"];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %d", [model objectForKeyedSubscript:@"name"] , [[model objectForKeyedSubscript:@"inventory"] integerValue] ];
    }
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate showGuideMessage: @"Tab 'One' Step1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
