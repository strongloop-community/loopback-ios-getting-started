//
//  DataViewController.h
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewData : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *path;

+ (DataViewData *)dataWithTitle:(NSString *)title path:(NSString *)path;

@end

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) DataViewData *viewData;

@end
