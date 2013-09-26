//
//  LessonThreeView.h
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LessonThreeView : UIView

@property (strong, nonatomic) IBOutlet MKMapView *map;

- (IBAction)sendRequest:(id)sender;

@end
