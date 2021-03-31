//
//  AppDelegate.m
//  bookReader
//
//  Created by Jobs on 2020/6/3.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "AppDelegate.h"
#import "BRTabBarViewController.h"
#import <UMCommon/UMConfigure.h>
#import <Bugly/Bugly.h>
#import "BRDataBaseCacheManager.h"
#import "CFAltUtils.h"

@interface AppDelegate () {
    
}

@property(nonatomic, strong) BRDataBaseCacheManager *cacheManager;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMConfigure initWithAppkey:[CFAltUtils UMConfigureKey] channel:@"App Store"];
        
    [Bugly startWithAppId:[CFAltUtils BuglyAppId]];
    
    self.cacheManager = [BRDataBaseCacheManager sharedInstance];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    BRTabBarViewController *root = [[BRTabBarViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];

    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];

    return YES;
}


//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
