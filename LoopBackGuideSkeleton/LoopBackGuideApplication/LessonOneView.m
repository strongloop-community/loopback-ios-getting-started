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
 * Insert custom subclasses of LBModel and LBModelPrototype here.
 */


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


    /**
     * Insert implementation here.
     */
    
    
}

@end
