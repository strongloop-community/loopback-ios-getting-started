//
//  SecondViewController.m
//  loopback-ios-multi-model
//
//  Created by Matt Schmulen on 7/24/13.
//  Copyright (c) 2013 StrongLoop All rights reserved.
//

/*
Tab 2, Step 2

This Tab shows you how to Create Update and Delete Model types with an inheritance paradigm instead of functional blocks with Value Pairs

Uncomment the code sections below to enable
- Referesh
- Create
- Update
- Delete

You will need to have your Loopback Node server running

You can start your Loopback Node server from the command line terminal with $slnode run app.js from within the loopback-nodejs-server/ folder
*/


#import "SecondViewController.h"
#import "AppDelegate.h"

//Local Objective C reporesentation of the our Mobile Model Object
@interface Car : LBModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *milage;
@property (nonatomic) NSNumber *yack2;
@end

@implementation Car
@end

@interface CarPrototype : LBModelPrototype
+ (instancetype)prototype;
@end

@implementation CarPrototype
+ (instancetype)prototype { return [self prototypeWithName:@"cars"]; }
@end




@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) LBRESTAdapter *adapter;
@property (weak, nonatomic) CarPrototype *prototypeObjectReference;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableDictionary *guide;
@end

@implementation SecondViewController


- (LBRESTAdapter *) adapter
{
    // cd /Users/mattschmulen/nodelife/strongloop/strongloop-community/loopback-ios-hello-node/loopback-nodejs-server
    // slnode run app.js
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}

- (CarPrototype *) prototypeObjectReference
{
    if (!_prototypeObjectReference)
          _prototypeObjectReference = (CarPrototype *)[_adapter prototypeWithClass:[CarPrototype class]];
    return _prototypeObjectReference;
}


- (NSArray *) tableData
{
    if ( !_tableData) _tableData = [[NSArray alloc] init];
    return _tableData;
};


- ( void ) getModels
{
    NSLog( @"getModels  " );
    void (^loadFailBlock)(NSError *) = ^(NSError *error) {
        [AppDelegate showGuideMessage: @"No Server Found"];
    };//end selfFailblock
    
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"cars"];
    
    // Invoke the allWithSuccess message for the 'cars' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/cars
    [ self.prototypeObjectReference allWithSuccess:^(NSArray *models) {
        NSLog( @"Success %d", [models count]);
        
        self.tableData = models;
        [self.myTableView reloadData];
    } failure:loadFailBlock];
    
};//end getModels


- ( void ) createNewModel
{
    NSLog( @"CreateNew Model and push to the server");
    
    void (^saveNewFailBlock)(NSError *) = ^(NSError *error) {
       [AppDelegate showGuideMessage: @"No Server Found"];
    };
    
    /*
    LBModelPrototype *prototype = [self.adapter prototypeWithName:@"products"];
    LBModel *model = [prototype modelWithDictionary:@{ @"name": @"My New Product" }];
    NSLog( @"Created new model with property name %@ ,created ",  [NSString stringWithFormat:[model objectForKeyedSubscript:@"name"]] );
    
    //save the model back to the server
   
    void (^saveNewSuccessBlock)() = ^() {
        NSLog( @"Sav Success !" );//model.count);
    };
    [model saveWithSuccess:saveNewSuccessBlock failure:saveNewFailBlock];
    */
    
    Car *modelInstance = (Car*)[self.prototypeObjectReference modelWithDictionary:@{ @"name": @"BWM", @"milage": @111 }];
    
    NSLog( @"Created local Object %@", modelInstance.name );
    modelInstance.name = @"camero";
    NSLog( @"Created local Object %@", modelInstance.name );
    
    //STAssertEqualObjects(model.bars, @1, @"Invalid bars.");
    //STAssertNil(model._id, nil, @"Invalid id");
    
    [modelInstance saveWithSuccess:^{
        NSLog( @"Save Success %@", modelInstance.name );
        //lastId = model._id;
        //STAssertNotNil(model._id, @"Invalid id");
    } failure:saveNewFailBlock];
    
}//end createNewModuleAndPushToServer

- ( void ) updateExistingModel
{
    // MAS TODO
}//end updateExistingModelAndPushToServer

- ( void ) deleteExistingModel
{
    // MAS TODO
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
        Car *modelInstance = (Car*)[self.tableData objectAtIndex:indexPath.row];
        
        //LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
        //cell.textLabel.text = model[@"name"]; //[model objectForKeyedSubscript:@"name"];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@", modelInstance.name, [ modelInstance.milage stringValue] ];
    }
    return cell;

    
    
    /*
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[LBModel class]])
    {
        LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
        //NSLog( [NSString stringWithFormat:[model objectAtKeyedSubscript:@"name"]] );
        //cell.textLabel.text = [NSString stringWithFormat:[model objectForKeyedSubscript:@"name"]];
        cell.textLabel.text = model[@"city"];
        cell.textLabel.text = [model objectForKeyedSubscript:@"city"];
        
    }
    return cell;
     */
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate showGuideMessage: @"Tab 'Two' Step2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 //MATT REMOVE ME
 You can use the LoopBack SDK LBMODEL as a parent for Mobile Objective-C Objects Making it easy to add CRUD and
 remoting featues to your Objects.
 
 This tab provides the Same CRUD featues as the First Tab only we are using an inheritence paradigm instead
 of functional blocks.
 
 In this case we create a local Parent object Product that inherits from LBModel and a ProductPrototype that is descended from LBModelPrototype
 
 */




@end
