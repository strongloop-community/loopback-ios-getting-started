//
//  LessonThreeView.m
//  LoopBackGuideApplication
//
//  Created by Michael Schoonmaker on 9/25/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import "LessonThreeView.h"

#import <LoopBack/LoopBack.h>

#import "AppDelegate.h"

/**
 * Boring, ordinary MKAnnotation implementation. Nothing to see here.
 *
 * For more information, see https://developer.apple.com/library/ios/documentation/MapKit/Reference/MKAnnotation_Protocol/Reference/Reference.html
 */
@interface LocationAnnotation : NSObject<MKAnnotation>

+ (instancetype)annotationFromLocation:(NSDictionary *)location;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation LocationAnnotation

+ (instancetype)annotationFromLocation:(NSDictionary *)location {
    LocationAnnotation *annotation = [[super alloc] init];

    if (annotation) {
        annotation.title = location[@"name"];
        annotation.subtitle = location[@"city"];

        NSNumber *latitude = location[@"geo"][@"lat"];
        NSNumber *longitude = location[@"geo"][@"lng"];
        annotation.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    }

    return annotation;
}

@end

/**
 * Private Intervace for Lesson Three: Don't Outgrow, Outbuild.
 */
@interface LessonThreeView()

- (void)addLocations:(NSArray *)locations toMapView:(MKMapView *)map;

@end

/**
 * Implementation for Lesson Three: Don't Outgrow, Outbuild.
 */
@implementation LessonThreeView

- (void)addLocations:(NSArray *)locations toMapView:(MKMapView *)map {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:locations.count];

    [locations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        annotations[idx] = [LocationAnnotation annotationFromLocation:locations[idx]];
    }];

    [map addAnnotations:annotations];
}

/**
 * Loads all Locations from the server, passing them to our MapView to be displayed as pins.
 */
- (IBAction)sendRequest:(id)sender {


    /**
     * Insert implementation here.
     */

    
}

@end
