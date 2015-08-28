//
//  ViewController.m
//  HZRoute
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZXibViewController.h"
#import "HZRoute.h"

@interface HZXibViewController ()

@end

@implementation HZXibViewController

+ (void)load
{
    HZRouteRegisterInfo *info = [HZRouteRegisterInfo routeRegisterInfo];
    info.sbName = @"Main";
    info.vcClass = [HZXibViewController class];
    info.vcIdentifier = @"kVcIdfViewController";
    info.loadXib = YES;
    info.paramKeyName = @"param";
    [HZRoute addRoutePath:@"vc/HZXibViewController" registerInfo:info];
}
- (IBAction)buttonAction:(id)sender
{
    [HZRoute routePath:@"vc/HZNoXibViewController"
                 param:@"NoXib"
               success:^(UIViewController *viewController) {
                   [self.navigationController pushViewController:viewController animated:YES];
               }
               failure:^(NSError *error) {
                   NSLog(@"%@", error.localizedDescription);
               }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", _param);
    
    self.title = @"根据XIB创建";
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
