//
//  AppDelegate.m
//  图片查看器
//
//  Created by 李自杨 on 17/2/9.
//  Copyright © 2017年 View. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *main = [[MainViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:main];
    
    self.window.rootViewController = navi;
    
    return YES;
}

@end
