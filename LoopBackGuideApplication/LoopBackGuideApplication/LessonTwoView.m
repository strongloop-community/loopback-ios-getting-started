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
 * Unlike Lesson One, our CarModel class is based _entirely_ on an existing schema.
 *
 * In this case, every field in Oracle that's defined as a NUMBER type becomes an NSNumber,
 * and each field defined as a VARCHAR2 becomes an NSString.
 *
 * When we load these models from Oracle, LoopBack uses these @property declarations to know
 * what data we care about. If we left off `extras`, for example, LoopBack would simply omit
 * that field.
 */
@interface CarModel : LBModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSNumber *year;
@property (nonatomic, copy) NSString *make;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *carClass;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *image;

@end

@implementation CarModel

@end

/**
 * Our custom ModelRepository subclass. See Lesson One for more information.
 */
@interface CarModelRepository : LBModelRepository

+ (instancetype)repository;

@end

@implementation CarModelRepository

+ (instancetype)repository {
    CarModelRepository *repository = [self repositoryWithClassName:@"cars"];
    repository.modelClass = [CarModel class];
    return repository;
}

@end

/**
 * Private Intervace for Lesson Two: Existing Data? No Problem.
 */
@interface LessonTwoView()

@property (strong, nonatomic) NSArray *cars;

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
        self.cars = @[];

//        [self.resultsTable registerNib:[UINib nibWithNibName:@"LessonTwoTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    }

    return self;
}

/**
 * Basic UITableViewDataSource implementation using our custom LBModel type.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"LessonTwoTableCell" owner:self options:nil] objectAtIndex:0];

    CarModel *model = (CarModel *)self.cars[indexPath.row];

    cell.textLabel.text = model.model;

    if ([model.year isKindOfClass:[NSNumber class]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.year, model.make, model.model];
    } else {
        cell.detailTextLabel.text = @"-";
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/**
 * Loads all Car models from the server. To make full use of this, return to your (running) Sample Application
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
 * next project, try connecting a schema-less model (e.g. our Note example) to a Mongo data source, while
 * connecting a legacy model (e.g. this Car example) to an Oracle data source.
 */
- (IBAction)sendRequest:(id)sender {
    // 1. Grab the shared LBRESTAdapter instance.
    LBRESTAdapter *adapter = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adapter;

    // 2. Instantiate our NoteModelRepository. See LessonOneView for further discussion.
    CarModelRepository *repository = (CarModelRepository *)[adapter repositoryWithClass:[CarModelRepository class]];

    // 3. Rather than instantiate a model directly like we did in Lesson One, we'll query the server for
    //    all Cars, filling out our UITableView with the results. In this case, the Repository is really
    //    the workhorse; the Model is just a simple container.
    [repository allWithSuccess:^(NSArray *models) {
        NSLog(@"Successfully loaded all Car models.");
        self.cars = models;
        [self.resultsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
