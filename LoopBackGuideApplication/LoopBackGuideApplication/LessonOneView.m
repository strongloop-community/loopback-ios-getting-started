//
//  LessonOneView.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "LessonOneView.h"

#import <LoopBack/LoopBack.h>

#import "AppDelegate.h"

/**
 * This custom subclass of LBModel is the closest thing to a "schema" the Ammo model has.
 * 
 * When we save an instance of AmmoModel, LoopBack uses the @property definitions of the subclass to
 * customize the request it makes to the server. The server handles this freeform request appropriately,
 * saving our freeform model to the database just as we expect.
 */
@interface AmmoModel : LBModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *caliber;
@property (nonatomic) bool armorPiercing;

@end

@implementation AmmoModel

@end

/**
 * The LBModelRepository provides an interface to the Model's "type" on the server. For instance, we'll
 * (SPOILER!) see in Lessons Two how the Repository is used for queries; in Lesson Three we'll use it
 * for custom, collection-level behaviour: those locations within the collection closest to the given
 * coordinates.
 *
 * This subclass, however, provides an additional benefit: it acts as glue within the LoopBack interface
 * between a LBRESTAdapter representing the _server_ and a named collection or type of model within it.
 * In this case, that type of model is named "ammo", and it contains AmmoModel instances.
 */
@interface AmmoModelRepository : LBModelRepository

+ (instancetype)repository;

@end

@implementation AmmoModelRepository

+ (instancetype)repository {
    AmmoModelRepository *repository = [self repositoryWithClassName:@"ammo"];
    repository.modelClass = [AmmoModel class];
    return repository;
}

@end

/**
 * Implementation for Lesson One: One Model, Hold the Schema
 */
@implementation LessonOneView

// Simple delegate implementation to auto-dismiss UITextFields.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/**
 * Saves the desired Ammo model to the server with all values pulled from the UI.
 */
- (IBAction)sendRequest:(id)sender {
    // 1. Grab the shared LBRESTAdapter instance.
    LBRESTAdapter *adapter = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adapter;

    // 2. Instantiate our AmmoModelRepository. For the intrepid, notice that we could create this
    //    once (say, in initWithFrame:) and use the same instance for every request. Additionally,
    //    the shared adapter is associated with the prototype, so we'd only have to do step 1 in
    //    initWithFrame: also. This more verbose version is presented as an example; making it more
    //    efficient is left as a rewarding exercise for the reader.
    AmmoModelRepository *repository = (AmmoModelRepository *)[adapter repositoryWithClass:[AmmoModelRepository class]];
    
    // 3. From that prototype, create a new AmmoModel. We pass in an empty dictionary to defer setting
    //    any values.
    AmmoModel *model = (AmmoModel *)[repository modelWithDictionary:@{}];

    // 4. Pull model values from the UI.
    model.name = self.nameField.text;
    model.caliber = self.caliberField.text;
    model.armorPiercing = self.armorPiercingSwitch.enabled ? true : false;

    // 5. Save!
    [model saveWithSuccess:^{
        NSLog(@"Successfully saved %@", model);
    } failure:^(NSError *error) {
        NSLog(@"Failed to save %@ with %@", model, error);
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
    }];
}

@end
