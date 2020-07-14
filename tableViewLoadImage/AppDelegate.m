//
//  AppDelegate.m
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import "AppDelegate.h"
#import "HKTableViewController.h"
#import <SDWebImage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HKTableViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    //下面两行代码主要是防止加载大分辨率图片时内存暴涨crash
    [SDImageCache sharedImageCache].config.shouldCacheImagesInMemory = NO;//缓存图片不放入内存
    //sd中可点击diskCacheReadingOptions跳转到这个属性，提示设置为NSDataReadingMappedIfSafe可提高性能
    [SDImageCache sharedImageCache].config.diskCacheReadingOptions = NSDataReadingMappedIfSafe;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeDisk completion:nil];
}

@end
