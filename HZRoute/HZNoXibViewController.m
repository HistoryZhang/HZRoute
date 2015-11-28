//
//  HZNoXibViewController.m
//  HZRoute
//
//  Created by History on 15/8/28.
//  Copyright © 2015年 history. All rights reserved.
//

#import "HZNoXibViewController.h"
#import "HZRoute.h"
#import "HZXibViewController.h"

NSString * kNoXibVcPath = @"hzroute://kHZNoXibVcPath";

@interface HZNoXibViewController ()

@end

@implementation HZNoXibViewController

+ (void)load
{
    [HZRoute registerPath:@"hzroute://kHZNoXibVcPath" routeInfo:@"HZNoXibViewController/0/extra"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"没有Xib创建";
    
    NSLog(@"%@", _extra);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:button
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:button
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
}

- (void)buttonAction
{
    [HZRoute routePath:kXibVcPath
                 param:@"Xib"
               success:^(UIViewController *viewController) {
                   [self.navigationController pushViewController:viewController animated:YES];
               }
               failure:^(NSError *error) {
                   NSLog(@"%@", error.localizedDescription);
               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
