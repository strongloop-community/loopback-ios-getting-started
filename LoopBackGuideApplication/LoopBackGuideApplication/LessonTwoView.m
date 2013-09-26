//
//  LessonTwoView.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "LessonTwoView.h"

#import <LoopBack/LoopBack.h>

#import "AppDelegate.h"

@interface WeaponModel : LBModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) int audibleRange;
@property (nonatomic) int effectiveRange;
@property (nonatomic) int rounds;
@property (nonatomic, copy) NSString *extras;
@property (nonatomic, copy) NSString *fireModes;

@end

@implementation WeaponModel

@end

@interface WeaponModelPrototype : LBModelPrototype

+ (instancetype)prototype;

@end

@implementation WeaponModelPrototype

+ (instancetype)prototype {
    WeaponModelPrototype *prototype = [self prototypeWithName:@"weapons"];
    prototype.modelClass = [WeaponModel class];
    return prototype;
}

@end

@interface LessonTwoView()

@property (strong, nonatomic) NSArray *weapons;

@end

@implementation LessonTwoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.weapons = @[];
        [self.resultsTable registerNib:[UINib nibWithNibName:@"LessonTwoTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Getting rows: %lu", (unsigned long)self.weapons.count);

    return self.weapons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    WeaponModel *model = (WeaponModel *)self.weapons[indexPath.row];

    NSLog(@"Trying to assign text label for %@", model.name);
    cell.textLabel.text = model.name;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/**
 * Saves the desired Ammo model to the server with all values pulled from the UI.
 */
- (IBAction)sendRequest:(id)sender {
    // 1. Grab the shared LBRESTAdapter instance.
    LBRESTAdapter *adapter = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adapter;

    // 2. Instantiate our AmmoModelPrototype. For the intrepid, notice that we could create this
    //    once (say, in initWithFrame:) and use the same instance for every request. Additionally,
    //    the shared adapter is associated with the prototype, so we'd only have to do step 1 in
    //    initWithFrame: also. This more verbose version is presented as an example; making it more
    //    efficient is left as a rewarding exercise for the reader.
    WeaponModelPrototype *prototype = (WeaponModelPrototype *)[adapter prototypeWithClass:[WeaponModelPrototype class]];

    [prototype allWithSuccess:^(NSArray *models) {
        NSLog(@"Models: %@", models);
        
        self.weapons = models;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.resultsTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get all with %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
    }];
}

@end
