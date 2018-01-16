//
//  LocationViewController.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/28.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKLocationManagerDelegate>

@property (nonatomic,strong)BMKMapView          *mapView;           // 地图
@property (nonatomic,strong)UIButton            *locationBtn;       // 定位按钮
//@property (nonatomic,strong)BMKLocationService  *locationService;   // 定位服务
@property (nonatomic,strong)UIButton            *accuracyBtn;       // 更新精度按钮

@property (nonatomic,strong)BMKLocationManager  *locationManager;   // 定位请求
@property (nonatomic,assign)BOOL                isLocationing;      // 是否正在定位

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"定位";
    
    _isLocationing = NO;
    
    [self initView];

}

#pragma mark - 视图定制
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, 140, 30)];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];
    
    
    _accuracyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationBtn.frame)+10, 74, 100, 30)];
    [_accuracyBtn setTitle:@"精度" forState:UIControlStateNormal];
    [_accuracyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_accuracyBtn addTarget:self action:@selector(accuracyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_accuracyBtn];
    
    
    _mapView    = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    _mapView.zoomLevel          = 18;                       // 比例尺
    _mapView.delegate           = self;
    _mapView.showsUserLocation  = YES;                      //显示定位图层
    _mapView.userTrackingMode   = BMKUserTrackingModeFollowWithHeading;
    
    //      BMKUserTrackingModeFollow;    // 定位跟随模式，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转
    //      BMKUserTrackingModeHeading;             // v4.1起支持，普通定位+定位罗盘模式，显示我的位置，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转。即在普通定位模式的基础上显示方向。
    //      BMKUserTrackingModeFollowWithHeading;   // 定位罗盘模式，我的位置始终在地图中心，我的位置图标和地图都会跟着旋转
    //      BMKUserTrackingModeNone;                // 设置定位的状态为普通定位模式
    [self.view addSubview:_mapView];
    
    
//    _locationService    = [[BMKLocationService alloc] init];
//    _locationService.delegate = self;
    
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = 20;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位,YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
    _locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
}

#pragma mark - 定位事件
- (void)locationClick
{
    // 开启定位
//    [_locationService startUserLocationService];
    
    if (_isLocationing)
    {
        // 停止连续定位。调用此方法会cancel掉所有的单次定位请求，可以用来取消单次定位。
        [_locationManager stopUpdatingLocation];
        
        // 是否支持设备朝向事件回调
        if ([BMKLocationManager headingAvailable])
        {
            // 为BMKLocationManager停止设备朝向事件回调
            [_locationManager stopUpdatingHeading];
        }
        _isLocationing = NO;
        [_locationBtn setTitle:@"开始连续定位" forState:UIControlStateNormal];
    }
    else
    {
        // 连续定位是否返回逆地理信息，默认YES。
        _locationManager.locatingWithReGeocode = YES;
        [_locationManager startUpdatingLocation];
        
        // 是否支持设备朝向事件回调
        if ([BMKLocationManager headingAvailable])
        {
            [_locationManager startUpdatingHeading];
        }
        _isLocationing = YES;
        [_locationBtn setTitle:@"停止连续定位" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 精度事件
- (void)accuracyClick
{
//    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
//    param.accuracyCircleStrokeColor = [UIColor redColor];
//    param.accuracyCircleFillColor   = [UIColor blueColor];
//    param.isAccuracyCircleShow      = YES;
//    param.canShowCallOut            = YES;
//    [_mapView updateLocationViewWithParam:param];
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"BMKMapView控件初始化完成");
}

// 单次点击
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"地图单击");
}

// 双击
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"地图双击");
}


#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    NSLog(@"连续定位出错 ===== %@", error);
}


/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error
{
    if (error)
    {
        NSLog(@"连续定位出错:%ld ======== %@",error.code, error.localizedDescription);
    }
    
    
    if (location)
    {
        // 得到定位信息，添加annotation
        if (location.location)
        {
            NSLog(@"得到的定位信息 ======== %@",location.location);
        }
        
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
        pointAnnotation.coordinate          = location.location.coordinate;
        pointAnnotation.title               = @"连续定位";
        
        // 地址数据
        if (location.rgcData)
        {
            pointAnnotation.subtitle = [location.rgcData description];
        }
        else
        {
            pointAnnotation.subtitle = @"rgc:null";
        }
        
        [_mapView addAnnotation:pointAnnotation];
        
        // 需要用一个结构体转化
//        [_mapView updateLocationData:(BMKUserLocation *)location.location];
        [_mapView setCenterCoordinate:location.location.coordinate animated:YES];
        
        
        NSLog(@"纬度 ============= %.5f 经度 ===== %.5f",location.location.coordinate.latitude,location.location.coordinate.longitude);
        
    }
    
}


/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"连续定位的权限状态 ========= %d", status);
}

/**
 * BMKLocationManagerShouldDisplayHeadingCalibration:
 *    该方法为BMKLocationManager提示需要设备校正回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 */
- (BOOL)BMKLocationManagerShouldDisplayHeadingCalibration:(BMKLocationManager * _Nonnull)manager
{
    NSLog(@"连续定位提示需要设备校正");
    return YES;
}


/**
 * BMKLocationManager:didUpdateHeading:
 *    该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading
{
//    NSLog(@"连续定位设备朝向 = %@", heading.description);
}


#pragma mark - BMKLocationServiceDelegate
///**
// *在地图View将要启动定位时，会调用此函数
// */
//- (void)willStartLocatingUser
//{
//    NSLog(@"start locate");
//}
//
///**
// *用户方向更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
//}
//
///**
// *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [_mapView updateLocationData:userLocation];
//}
//
///**
// *在地图View停止定位后，会调用此函数
// */
//- (void)didStopLocatingUser
//{
//    NSLog(@"stop locate");
//}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//    NSLog(@"location error");
//}

#pragma mark - 销毁
- (void)dealloc
{
    _mapView.delegate = nil; // 不用时，置nil
//    _locationService.delegate = nil;
    _locationManager = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
