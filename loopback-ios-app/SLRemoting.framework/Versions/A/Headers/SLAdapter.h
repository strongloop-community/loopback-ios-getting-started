/**
 * @file SLAdapter.h
 *
 * @author Michael Schoonmaker
 * @copyright (c) 2013 StrongLoop. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * Blocks of this type are executed for any successful method invocation, i.e.
 * one where the remote method called the callback as `callback(null, value)`.
 *
 * **Example:**
 * @code
 * [...
 *     success:^(id value) {
 *         NSLog(@"The result was: %@", value);
 *     }
 * ...];
 * @endcode
 *
 * @param {id} value  The top-level value returned by the remote method, typed
 *                    appropriately: an NSNumber for all Numbers, an
 *                    NSDictionary for all Objects, etc.
 */
typedef void (^SLSuccessBlock)(id value);

/**
 * Blocks of this type are executed for any failed method invocation, i.e. one
 * where the remote method called the callback as `callback(error, null)` or
 * just `callback(error)`.
 *
 * **Example:**
 * @code
 * [...
 *     success:^(id value) {
 *         NSLog(@"The result was: %@", value);
 *     }
 * ...];
 * @endcode
 *
 * @param {NSError *} error  The error received, as a properly-formatted
 *                           NSError.
 */
typedef void (^SLFailureBlock)(NSError *error);

/**
 * An error description for SLAdapters that are not connected to any server.
 * Errors with this description will be passed to the SLFailureBlock associated
 * with a request made of a disconnected Adapter.
 */
extern NSString *SLAdapterNotConnectedErrorDescription;

/**
 * The entry point to all networking accomplished with LoopBack. Adapters
 * encapsulate information consistent to all networked operations, such as base
 * URL, port, etc.
 */
@interface SLAdapter : NSObject

/** YES if the SLAdapter is connected to a server, NO otherwise. */
@property (readonly, nonatomic) BOOL connected;

+ (instancetype)adapter;
+ (instancetype)adapterWithURL:(NSURL *)url;

- (instancetype)initWithURL:(NSURL *)url;

- (void)connectToURL:(NSURL *)url;

/**
 *
 * @snippet snippets.m SLAdapter Static Method
 *
 * @param {NSString     *}     method        [description]
 * @param {NSDictionary *}     parameters    [description]
 * @param {SLSuccessBlock}  success [description]
 * @param {SLFailureBlock}  failure [description]
 */
- (void)invokeStaticMethod:(NSString *)method
                parameters:(NSDictionary *)parameters
                   success:(SLSuccessBlock)success
                   failure:(SLFailureBlock)failure;

- (void)invokeInstanceMethod:(NSString *)method
       constructorParameters:(NSDictionary *)constructorParameters
                  parameters:(NSDictionary *)parameters
                     success:(SLSuccessBlock)success
                     failure:(SLFailureBlock)failure;

@end
