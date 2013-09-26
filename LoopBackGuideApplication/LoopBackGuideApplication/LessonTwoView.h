//
//  LessonTwoView.h
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonTwoView : UIView <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

- (IBAction)sendRequest:(id)sender;

@end
