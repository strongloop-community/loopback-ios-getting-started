//
//  LBModel.h
//  LoopBack
//
//  Created by Michael Schoonmaker on 6/19/13.
//  Copyright (c) 2013 StrongLoop. All rights reserved.
//

#import <SLRemoting/SLRemoting.h>

/**
 * LBModel is the base class for all LoopBack Models.
 */
@interface LBModel : SLObject

/** All Models have a numerical `id` field. */
@property (nonatomic, readonly, copy) NSNumber *_id;

/**
 * Returns the value associated with a given key.
 *
 * @param  {id <NSCopying>} key  The key for which to return the corresponding value.
 * @return {id}                  The value associated with `key`, or `nil` if no value is associated with `key`.
 */
- (id)objectForKeyedSubscript:(id <NSCopying>)key;

/**
 * Adds a given key-value pair to the dictionary.
 *
 * @param {id}    obj           The value for aKey. A strong reference to the object is maintained by the dictionary. Raises an NSInvalidArgumentException if anObject is nil. If you need to represent a nil value in the dictionary, use NSNull.
 * @param {id <NSCopying>} key  The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol). Raises an NSInvalidArgumentException if aKey is nil. If aKey already exists in the dictionary anObject takes its place.
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/**
 * Converts the LBModel (and all of its @properties) into an NSDictionary.
 *
 * toDictionary should be overridden in child classes that wish to change this
 * behaviour: hiding properties, adding computed properties, etc.
 */
- (NSDictionary *)toDictionary;

/**
 * Saves the LBModel to the server.
 *
 * Calls `toDictionary` to determine which fields should be saved.
 *
 * @param {LBModelSaveSuccessBlock} success The block to be executed when the save is successful. The block takes no arguments.
 * @param {SLFailureBlock}          failure The block to be executed when the save fails. The block takes a single, NSError* argument.
 */
typedef void (^LBModelSaveSuccessBlock)();
- (void)saveWithSuccess:(LBModelSaveSuccessBlock)success
                failure:(SLFailureBlock)failure;

/**
 * Destroys the LBModel from the server.
 *
 * @param {LBModelDestroySuccessBlock} success The block to be executed when the destroy is successful. The block takes no arguments.
 * @param {SLFailureBlock}             failure The block to be executed when the destroy fails. The block takes a single, NSError* argument.
 */
typedef void (^LBModelDestroySuccessBlock)();
- (void)destroyWithSuccess:(LBModelDestroySuccessBlock)success
                   failure:(SLFailureBlock)failure;

@end

/**
 * LBModelPrototype provides a interface to the Model "class" itself from the backend.
 */
@interface LBModelPrototype : SLPrototype

@property Class modelClass;

- (SLRESTContract *)contract;

- (LBModel *)modelWithDictionary:(NSDictionary *)dictionary;

//typedef void (^LBModelExistsSuccessBlock)(BOOL exists);
//- (void)existsWithId:(NSNumber *)_id
//             success:(LBModelExistsSuccessBlock)success
//             failure:(SLFailureBlock)failure;

typedef void (^LBModelFindSuccessBlock)(LBModel *model);
- (void)findWithId:(NSNumber *)_id
           success:(LBModelFindSuccessBlock)success
           failure:(SLFailureBlock)failure;

typedef void (^LBModelAllSuccessBlock)(NSArray *models);
- (void)allWithSuccess:(LBModelAllSuccessBlock)success
               failure:(SLFailureBlock)failure;

//typedef void (^LBModelFindOneSuccessBlock)(LBModel *model);
//- (void)findOneWithFilter:(NSDictionary *)filter
//                  success:(LBModelFindOneSuccessBlock)success
//                  failure:(SLFailureBlock)failure;

@end
