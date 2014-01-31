//
//  LessonOneView.h
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonOneView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) IBOutlet UISwitch *reviewedSwitch;

- (IBAction)sendRequest:(id)sender;

@end
