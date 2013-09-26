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


/**
 * Insert custom subclasses of LBModel and LBModelPrototype here.
 */


/**
 * Private Intervace for Lesson Two: Existing Data? No Problem.
 */
@interface LessonTwoView()

@property (strong, nonatomic) NSArray *weapons;

@end

/**
 * Implementation for Lesson Two: Existing Data? No Problem.
 */
@implementation LessonTwoView

- (id)init {
    NSLog(@"init");
    return [super init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.weapons = @[];

//        [self.resultsTable registerNib:[UINib nibWithNibName:@"LessonTwoTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    }

    return self;
}

/**
 * Basic UITableViewDataSource implementation using our custom LBModel type.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weapons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"LessonTwoTableCell" owner:self options:nil] objectAtIndex:0];

    NSString *name = @"";
    NSNumber *range = @0;


    /**
     * Here, you should set `name` and `range` to the two properties from your model subclass.
     */


    cell.textLabel.text = name;

    if ([range isKindOfClass:[NSNumber class]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m", range];
    } else {
        cell.detailTextLabel.text = @"-";
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/**
 * Loads all Weapon models from the server. To make full use of this, return to your (running) Sample Application
 * and restart it with the DB environment variable set to "oracle". For example, on most *nix flavors (including
 * Mac OS X), that looks like:
 *
 * 1. Stop the current server with Ctrl-C.
 * 2. DB=oracle slc run app
 *
 * What does this do, you ask? Without that environment variable, the Sample Application uses simple, in-memory
 * storage for all models. With the environment variable, it uses a custom-made Oracle adapter with a demo
 * Oracle database we host for this purpose. If you have existing data, it's that easy to pull into LoopBack.
 * No need to leave it behind.
 *
 * Advanced users: LoopBack supports multiple data sources simultaneously, albeit on a per-model basis. In your
 * next project, try connecting a schema-less model (e.g. our Ammo example) to a Mongo data source, while
 * connecting a legacy model (e.g. this Weapon example) to an Oracle data source.
 */
- (IBAction)sendRequest:(id)sender {


    /**
     * Insert implementation here.
     */

    
}

@end
