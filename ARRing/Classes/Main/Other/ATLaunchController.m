//
//  ATLaunchController.m
//  Yami
//
//  Created by CoderLT on 2016/10/19.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATLaunchController.h"

@interface ATLaunchController ()

@end

@implementation ATLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateInitialViewController];
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
