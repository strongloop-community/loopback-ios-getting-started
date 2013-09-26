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
    // 1. Grab the shared LBRESTAdapter instance.
    LBRESTAdapter *adapter = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adapter;

    // 2. Instantiate our ModelPrototype. Rather than create a subclass this time, we'll use the base
    //    classes to show off their off-the-shelf superpowers.
    LBModelPrototype *prototype = [adapter prototypeWithName:@"locations"];

    // 3. The meat of the lesson: custom behaviour. Here, we're invoking a custom, static method on
    //    the Location model type called "nearby". As you might expect, it does a geo-based query
    //    ordered by the closeness to the provided latitude and longitude. Rather than go through
    //    CoreLocation, we've plugged in the coordinates of our favorite noodle shop here in San Mateo,
    //    California.
    //
    //    Once we've successfully loaded the models, we pass them to our `addLocations:toMapView:`
    //    method to be converted to MKAnnotations and added to the map as clickable pins!
    [prototype invokeStaticMethod:@"nearby"
                       parameters:@{
                              @"here": @{
                                  @"lat": @37.56572191237293,
                                  @"lng": @-122.32357978820802
                              }
                          }
                          success:^(id value) {
                              NSLog(@"Successfully loaded locations.");
                              [self addLocations:value toMapView:self.map];
                          }
                          failure:^(NSError *error) {
                              NSLog(@"Failed to call nearby with %@", error);
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles:nil] show];
                          }];
}

@end
