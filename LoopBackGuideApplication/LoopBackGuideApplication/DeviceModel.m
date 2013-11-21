#import "DeviceModel.h"

@implementation DeviceModel

/**
 * Saves the desired Device model to the server with all values pulled from the UI.
 */
+ (void)register:(NSData *)deviceToken adapter:(LBRESTAdapter *) adapter {
    // 1. Convert device token from NSData to NSString
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
    // 2. Instantiate our DeviceModelRepository. For the intrepid, notice that we could create this
    //    once (say, in initWithFrame:) and use the same instance for every request. Additionally,
    //    the shared adapter is associated with the repository, so we'd only have to do step 1 in
    //    initWithFrame: also. This more verbose version is presented as an example; making it more
    //    efficient is left as a rewarding exercise for the reader.
    DeviceModelRepository *repository = (DeviceModelRepository *)[adapter repositoryWithClass:[DeviceModelRepository class]];
    
    // 3. From that repository, create a new DeviceModel. We pass in an empty dictionary to defer setting
    //    any values.
    DeviceModel *model = (DeviceModel *)[repository modelWithDictionary:@{
                                           @"appId": @"Cl8DRoMP6fgCWT45Iu3ZQfcwVl4=",
                                           @"appVersion": @"1.0.0",
                                           @"userId": @"raymond",
                                           @"deviceType": @"ios",
                                           @"deviceToken": hexToken,
                                           @"badge": @0}];
    
    /*
    model.appId = @"loopback-ios-guide";
    model.appVersion = @"1.0.0";
    model.userId = @"unknown";
    model.deviceToken = hexToken;
    model.badge = 0;
    */
    
    // 4. Save!
    [model saveWithSuccess:^{
        NSLog(@"Successfully saved %@", model);
    } failure:^(NSError *error) {
        NSLog(@"Failed to save %@ with %@", model, error);
    }];
}

@end


@implementation DeviceModelRepository

+ (instancetype)repository {
    DeviceModelRepository *repository = [self repositoryForClassName:@"devices"];
    repository.modelClass = [DeviceModel class];
    return repository;
}

@end

