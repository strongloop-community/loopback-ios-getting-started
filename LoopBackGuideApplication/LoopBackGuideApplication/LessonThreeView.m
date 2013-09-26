//
//  LessonThreeView.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "LessonThreeView.h"

#import <LoopBack/LoopBack.h>

@implementation LessonThreeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)sendRequest:(id)sender {
    NSLog(@"WRITE!");
}

@end
