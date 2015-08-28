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
@property (copy, nonatomic) NSMutableDictionary *routeMap;
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

- (void)registerRoutePath:(NSString *)path registerInfo:(HZRouteRegisterInfo *)registerInfo
{
    [_routeMap setObject:registerInfo forKey:path];
}
- (void)routePath:(NSString *)path param:(id)param success:(void(^)(UIViewController *viewController))success failure:(void(^)(NSError *error))failure
{
    if (!path.length) {
        if (failure) {
            failure([NSError errorWithDomain:kHZRouteErrorDomain
                                        code:HZRouteErrorCodeNotRegisterPath
                                    userInfo:@{
                                               NSLocalizedDescriptionKey: @"未注册的Path",
                                               }]);
        }
        return;
    }
    HZRouteRegisterInfo *registerInfo = _routeMap[path];
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
        id viewController = [[UIStoryboard storyboardWithName:registerInfo.sbName bundle:nil] instantiateViewControllerWithIdentifier:registerInfo.vcIdentifier];
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
+ (void)addRoutePath:(NSString *)path registerInfo:(HZRouteRegisterInfo *)registerInfo
{
    [[__HZRoute share] registerRoutePath:path registerInfo:registerInfo];
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
                                    
                                }
                                failure(error);
                            }];
}
@end
