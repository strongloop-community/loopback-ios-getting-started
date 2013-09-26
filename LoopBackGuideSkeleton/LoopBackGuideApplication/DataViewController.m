//
//  DataViewController.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "DataViewController.h"

@implementation DataViewData

+ (DataViewData *)dataWithTitle:(NSString *)title path:(NSString *)path {
    DataViewData *data = [[self alloc] init];

    if (data) {
        data.title = title;
        data.path = path;
    }

    return data;
}

@end

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Fill out known view data
    self.dataLabel.text = self.viewData.title;

    // Load subview
    NSObject *obj = [[[NSBundle mainBundle] loadNibNamed:self.viewData.path owner:self options:nil] objectAtIndex:0];

    if ([[obj class] isSubclassOfClass:[UIView class]]) {
        UIView *subview = (UIView *)obj;
        [self.containerView addSubview:subview];
        subview.frame = self.containerView.bounds;
    }
}

@end
