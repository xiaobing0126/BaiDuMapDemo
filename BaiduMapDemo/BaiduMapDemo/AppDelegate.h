//
//  AppDelegate.h
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/28.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import <UIKit/UIKit.h>

// BaiduMapAPI_Base.framework    为基础包，使用SDK任何功能都需导入，其他分包可按需导入。
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#import <BMKLocationKit/BMKLocationAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

