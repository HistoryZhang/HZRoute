//
//  HZRoute.m
//  HZRoute
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZRoute.h"

NSString * const kHZRouteErrorDomain = @"com.history.route.error";

typedef NS_ENUM(NSUInteger, HZRouteErrorCode) {
    HZRouteErrorCodeNotRegisterPath = 1000,
    HZRouteErrorCodeInitVcFail,
    HZRouteErrorCodeEmptyRegisterInfo,
    HZRouteErrorCodeEmptySbOrXib,
};

/**
 *  Some Register Information
 */
@interface HZRouteRegisterInfo : NSObject
/**
 *  Storyboard Name
 */
@property (copy, nonatomic) NSString *sbName;
/**
 *  ViewController Identifier
 */
@property (copy, nonatomic) NSString *vcIdentifier;
/**
 *  ViewController Class
 */
@property (strong, nonatomic) Class vcClass;
/**
 *  If YES, ViewController will create with `sbName` and `vcIdentifier`.
 *  Else, Use [[Class alloc] init] to create ViewController.
 *  Default is YES.
 */
@property (assign, nonatomic) BOOL loadXib;
/**
 *  Param Key Name.
 *  Param should be an Object.
 */
@property (copy, nonatomic) NSString *paramKeyName;
+ (instancetype)routeRegisterInfo;
@end

@implementation HZRouteRegisterInfo

+ (instancetype)routeRegisterInfo
{
    HZRouteRegisterInfo *info = [[HZRouteRegisterInfo alloc] init];
    info.loadXib = NO;
    info.sbName = nil;
    info.vcIdentifier = nil;
    info.vcClass = nil;
    info.paramKeyName = nil;
    return info;
}

@end

@interface __HZRoute : NSObject
{
    
}
@property (strong, nonatomic) NSMutableDictionary *routeMap;
@end

@implementation __HZRoute

+ (instancetype)share
{
    static __HZRoute *route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!route) {
            route = [[__HZRoute alloc] init];
        }
    });
    return route;
}

- (instancetype)init
{
    if (self = [super init]) {
        _routeMap = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Private
- (HZRouteRegisterInfo *)analyzeRoutePath:(NSString *)path
{
    NSString *routeInfo = _routeMap[path];
    NSArray *array = [routeInfo componentsSeparatedByString:@"/"];
    HZRouteRegisterInfo *info = [HZRouteRegisterInfo routeRegisterInfo];
    info.vcClass = NSClassFromString(array[0]);
    NSArray *subArray = [array[1] componentsSeparatedByString:@"-"];
    if ([subArray[0] boolValue]) { // 1 加载XIB
        info.loadXib = YES;
        info.sbName = subArray[1];
        info.vcIdentifier = subArray[2];
    }
    else {
        info.loadXib = NO;
    }
    if (3 == array.count) {
        info.paramKeyName = array[2];
    }
    return info;
}

#pragma mark -
- (BOOL)registerRoutePath:(NSString *)path routeInfo:(NSString *)routeInfo
{
    if (!path.length || !routeInfo.length) {
        return NO;
    }
    [_routeMap setObject:routeInfo forKey:path];
    return YES;
}
- (void)routePath:(NSString *)path param:(id)param success:(void(^)(UIViewController *viewController))success failure:(void(^)(NSError *error))failure
{
    if (!path.length || !_routeMap[path]) {
        if (failure) {
            failure([NSError errorWithDomain:kHZRouteErrorDomain
                                        code:HZRouteErrorCodeNotRegisterPath
                                    userInfo:@{
                                               NSLocalizedDescriptionKey: @"未注册的Path",
                                               }]);
        }
        return;
    }
    HZRouteRegisterInfo *registerInfo = [self analyzeRoutePath:path];
    if (!registerInfo) {
        if (failure) {
            failure([NSError errorWithDomain:kHZRouteErrorDomain
                                        code:HZRouteErrorCodeEmptyRegisterInfo
                                    userInfo:@{
                                               NSLocalizedDescriptionKey: @"Register Info为空",
                                               }]);
        }
        return;
    }
    if (!registerInfo.loadXib) {
        id viewController = [[registerInfo.vcClass alloc] init];
        if (viewController) {
            if (registerInfo.paramKeyName) {
                [viewController setValue:param forKey:registerInfo.paramKeyName];
            }
            [viewController setValue:[UIColor whiteColor] forKeyPath:@"view.backgroundColor"];
            if (success) {
                success(viewController);
            }
        }
        else {
            failure([NSError errorWithDomain:kHZRouteErrorDomain
                                        code:HZRouteErrorCodeInitVcFail
                                    userInfo:@{
                                               NSLocalizedDescriptionKey: @"无Nib创建Vc失败",
                                               }]);
        }
    }
    else {
        if (!registerInfo.sbName || !registerInfo.vcIdentifier) {
            if (failure) {
                failure([NSError errorWithDomain:kHZRouteErrorDomain
                                            code:HZRouteErrorCodeEmptySbOrXib
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey: @"Sb或Xib为空",
                                                   }]);
            }
            return;
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:registerInfo.sbName bundle:nil];
        id viewController = [sb instantiateViewControllerWithIdentifier:registerInfo.vcIdentifier];
        if (viewController) {
            if (registerInfo.paramKeyName) {
                [viewController setValue:param forKey:registerInfo.paramKeyName];
            }
            if (success) {
                success(viewController);
            }
        }
        else {
            failure([NSError errorWithDomain:kHZRouteErrorDomain
                                        code:HZRouteErrorCodeInitVcFail
                                    userInfo:@{
                                               NSLocalizedDescriptionKey: @"有Nib创建Vc失败",
                                               }]);
        }
    }
}
@end

@implementation HZRoute
+ (BOOL)registerPath:(NSString *)path routeInfo:(NSString *)info
{
    NSArray *array = [info componentsSeparatedByString:@"/"];
    if (3 == array.count || 2 == array.count) {
        return [[__HZRoute share] registerRoutePath:path routeInfo:info];
    }
    else {
        return NO;
    }
}
+ (void)routePath:(NSString *)path param:(id)param success:(void(^)(UIViewController *viewController))success failure:(void(^)(NSError *error))failure
{
    [[__HZRoute share] routePath:path
                           param:param
                         success:^(UIViewController *viewController) {
                             if (success) {
                                 success(viewController);
                             }
                         }
                         failure:^(NSError *error) {
                             if (failure) {
                                 failure(error);
                             }
                         }];
}
@end
