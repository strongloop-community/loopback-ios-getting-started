//
//  DeviceModel.h
//  LoopBackGuideApplication
//
//  Created by Raymond Feng on 11/20/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#ifndef LoopBackGuideApplication_DeviceModel_h
#define LoopBackGuideApplication_DeviceModel_h

#import <LoopBack/LoopBack.h>

@interface DeviceModel : LBModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString* deviceType;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSNumber *badge;

+ (void)register: (NSData *) deviceToken adapter: (LBRESTAdapter *) adapter;

@end


/**
 * Our custom ModelRepository subclass. See Lesson One for more information.
 */
@interface DeviceModelRepository : LBModelRepository

+ (instancetype)repository;

@end


#endif
