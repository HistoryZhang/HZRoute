//
//  HZRoute.h
//  HZRoute
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface HZRoute : NSObject
/**
 *  Register Route Path
 *
 *  @param path route path
 *              scheme://host
 *  @param info init viewcontroller info
 *              vcClass/1-sbName-vcIdentifier/paramKeyName
 *              vcClass/0/paramKeyName
 *  @return YES success
 *          NO  fail
 */
+ (BOOL)registerPath:(NSString *)path routeInfo:(NSString *)info;
/**
 *  Jump ViewController With Register Path
 *
 *  @param path    register path.
 *  @param param   extra param. you should set `paramKeyName` in `HZRouteRegisterInfo` first.
 *  @param success create ViewController success block.
 *  @param failure create ViewController fail block.
 */
+ (void)routePath:(NSString *)path param:(id)param success:(void(^)(UIViewController *viewController))success failure:(void(^)(NSError *error))failure;
@end
