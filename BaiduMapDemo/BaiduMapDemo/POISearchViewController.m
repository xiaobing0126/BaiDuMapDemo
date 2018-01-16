//
//  POISearchViewController.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/29.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "POISearchViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface POISearchViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@property (nonatomic,strong)BMKMapView      *mapView;
@property (nonatomic,strong)BMKPoiSearch    *poiSearch;
@property (nonatomic,strong)UITextField     *keyTf;         // 地址输入
@property (nonatomic,strong)UIButton        *locationBtn;   // 定位按钮
@property (nonatomic,strong)BMKLocationService  *locationService;   // 定位服务
@property (nonatomic,strong)UIButton        *searchBtn;     // 搜索按钮
@property (nonatomic,assign)int             currentPage;
@property (nonatomic,strong)CLLocation      *keyLocation;

@end

@implementation POISearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"POI热点搜索";
    
    [self initMapView];
}

#pragma mark - 地图定制
- (void)initMapView
{
    _keyTf = [[UITextField alloc] initWithFrame:CGRectMake(15, 64+10, SCREEN_WIDTH-30, 40)];
    _keyTf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_keyTf];
    
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_keyTf.frame), 120, 40)];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];
    
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationBtn.frame), CGRectGetMaxY(_keyTf.frame), 120, 40)];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    
    _mapView    = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBtn.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64-50-20)];
    _mapView.zoomLevel          = 16;                       // 比例尺
    _mapView.delegate           = self;
    _mapView.showsUserLocation  = YES;                      //显示定位图层
    _mapView.isSelectedAnnotationViewFront = YES;           //设定是否总让选中的annotaion置于最前面
    _mapView.userTrackingMode   = BMKUserTrackingModeFollowWithHeading;
    
    //      BMKUserTrackingModeFollow;    // 定位跟随模式，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转
    //      BMKUserTrackingModeHeading;             // v4.1起支持，普通定位+定位罗盘模式，显示我的位置，我的位置始终在地图中心，我的位置图标会旋转，地图不会旋转。即在普通定位模式的基础上显示方向。
    //      BMKUserTrackingModeFollowWithHeading;   // 定位罗盘模式，我的位置始终在地图中心，我的位置图标和地图都会跟着旋转
    //      BMKUserTrackingModeNone;                // 设置定位的状态为普通定位模式
    [self.view addSubview:_mapView];
    
    
    _locationService    = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    
    
    _poiSearch = [[BMKPoiSearch alloc] init];
    _poiSearch.delegate = self;
    
    
}

#pragma mark - 搜索事件
- (void)searchClick
{
    [_keyTf resignFirstResponder];
    
    _currentPage = 0;
    // 周边云检搜索信息类
    BMKNearbySearchOption *nearBySearchOption = [[BMKNearbySearchOption alloc] init];
    nearBySearchOption.pageIndex = 0;
    nearBySearchOption.pageCapacity = 10;
    nearBySearchOption.keyword = _keyTf.text;
    ///周边检索半径
    nearBySearchOption.radius = 100;
    ///检索的中心点，经纬度
    nearBySearchOption.location = _keyLocation.coordinate;
    
    BOOL flag = [_poiSearch poiSearchNearBy:nearBySearchOption];
    if (flag)
    {
        NSLog(@"周边云搜索成功");
    }
    else
    {
        NSLog(@"周边云搜索失败");
    }
    
}


#pragma mark - 定位事件
- (void)locationClick
{
    [_locationService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _keyLocation = userLocation.location;
    NSLog(@"纬度经度 ========= lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
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

/**
 *根据anntation生成对应的View
 *@param view 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *annotationViewId = @"annotationViewId";
    
    // 检查是否有重用的缓存
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    
    // 点击地图上的标注点，可以设置导航路线
    
    
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark - BMKSearchDelegate
/**
 *根据中心点、半径和检索词发起周边检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiResult通知
 *@param option 周边搜索的搜索参数类（BMKNearbySearchOption）
 *@param index 页码，如果是第一次发起搜索，填0，根据返回的结果可以去获取第n页的结果，页码从0开始
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiSearchNearBy:(BMKNearbySearchOption*)option
{
    return YES;
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    // 清除屏幕中所有的annotation
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    // 检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (int i = 0; i < poiResult.poiInfoList.count; i++)
        {
            BMKPoiInfo *poi = [poiResult.poiInfoList objectAtIndex:i];
            
            // 这是标注，搜索的结果在地图上以标注形式显示
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = poi.address;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        
    }
    else
    {
        NSLog(@"检索出错情况 ========== %u",errorCode);
    }

}


#pragma mark - 销毁
- (void)dealloc
{
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
    _poiSearch.delegate = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
