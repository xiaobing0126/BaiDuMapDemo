//
//  AppDelegate.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/28.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()<BMKGeneralDelegate,BMKLocationAuthDelegate>

@property (nonatomic,strong)BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL])
    {
        NSLog(@"经纬度类型设置成功");
    }
    else
    {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:@"I5k0VYkvx4tgDUp2BpTrP6f8D7vpq2oH" generalDelegate:self];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"I5k0VYkvx4tgDUp2BpTrP6f8D7vpq2oH" authDelegate:self];
    
    
    RootViewController *rootVc = [[RootViewController alloc] init];
    UINavigationController *RootNav = [[UINavigationController alloc] initWithRootViewController:rootVc];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = RootNav;
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError
{
    if (iError == BMKLocationAuthErrorSuccess)
    {
        NSLog(@"定位鉴权成功");
    }
    else
    {
        NSLog(@"定位鉴权失败 ======= %ld",(long)iError);
    }
    
}

#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"onGetPermissionState %d",iError);
    }
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


@end
