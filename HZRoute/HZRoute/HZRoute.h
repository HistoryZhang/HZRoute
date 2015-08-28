//
//  HZRoute.h
//  HZRoute
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

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

@interface HZRoute : NSObject
/**
 *  Register Route Path
 *
 *  @param path         route path
 *  @param registerInfo register info
 */
+ (void)addRoutePath:(NSString *)path registerInfo:(HZRouteRegisterInfo *)registerInfo;
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
