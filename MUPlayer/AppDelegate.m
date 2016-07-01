//
//  AppDelegate.m
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <RealReachability.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = vc;
    [GLobalRealReachability startNotifier];
    return YES;
}
- (void)netWorkStatusChanged:(NSNotification*)notification{
    RealReachability *reachability = (RealReachability*)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的网络已经断开请检查" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    NSLog(@"deededeeeeeeee%ld",(long)status);
    switch (status) {
        case RealStatusNotReachable:{
            [alerView show];
        }
            break;
        case RealStatusUnknown:{
            alerView.message = @"当前连接的是未知网络请检查";
           [alerView show];
        }
        case RealStatusViaWiFi:{
        //NSLog(@"wifi");
          //[alerView show];
        }
        case RealStatusViaWWAN:{
            alerView.message = @"当前使用流量观看视频土豪请随意";
          [alerView show];
        }
        default:
            break;
    }


}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged:) name:kRealReachabilityChangedNotification object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
