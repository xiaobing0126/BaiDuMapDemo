//
//  RouteSearchViewController.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/29.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "RouteSearchViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


#import "RouteAnnotation.h"

@interface RouteSearchViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>

@property (nonatomic,strong)BMKMapView          *mapView;           // 地图
@property (nonatomic,strong)UIButton            *locationBtn;       // 定位按钮
@property (nonatomic,strong)BMKLocationService  *locationService;   // 定位服务
@property (nonatomic,strong)UIButton            *busBtn;            // 公交按钮
@property (nonatomic,strong)BMKGeoCodeSearch    *geoCodeSearch;

@property (nonatomic,strong)UIButton            *reverseGeoCodeBtn; // 反向编码

@property (nonatomic,copy)NSString              *titleStr;
@property (nonatomic,copy)NSString              *address;           // 纬度经度反编码获得地址

@property (nonatomic,assign)CLLocationCoordinate2D updateLocation;      // 定位的纬度 经度
@property (nonatomic,strong)BMKRouteSearch      *routeSearch;       // 路径搜索类

@end

@implementation RouteSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
}
#pragma mark - 视图定制
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH/4, 30)];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];

    
    _reverseGeoCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 74, SCREEN_WIDTH/4, 30)];
    [_reverseGeoCodeBtn setTitle:@"反编码" forState:UIControlStateNormal];
    [_reverseGeoCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_reverseGeoCodeBtn addTarget:self action:@selector(reverseCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reverseGeoCodeBtn];
    
    
    _busBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*2, 74, SCREEN_WIDTH/4, 30)];
    [_busBtn setTitle:@"公交" forState:UIControlStateNormal];
    [_busBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_busBtn addTarget:self action:@selector(busClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_busBtn];
    
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
    
    
    _locationService            = [[BMKLocationService alloc] init];
    _locationService.delegate   = self;
    
    
    _geoCodeSearch              = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate     = self;
    
    
    _routeSearch                = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate       = self;
}

#pragma mark - 搜索bus
- (void)busClick
{
    BMKPlanNode *start  = [[BMKPlanNode alloc] init];
    start.name          = @"利金城工业园";
    start.cityName      = @"深圳市";
    
    BMKPlanNode *end    = [[BMKPlanNode alloc] init];
    end.name            = @"滢水山庄";
    end.cityName        = @"深圳市";
    
    BMKMassTransitRoutePlanOption *transitRouteSearchOption = [[BMKMassTransitRoutePlanOption alloc] init];
    transitRouteSearchOption.from   = start;
    transitRouteSearchOption.to     = end;
    
    BOOL flag = [_routeSearch massTransitSearch:transitRouteSearchOption];
    if (flag)
    {
        NSLog(@"公交交通检索（支持垮城）发送成功");
    }
    else
    {
        NSLog(@"公交交通检索（支持垮城）发送失败");
    }
    
}

#pragma mark - 定位事件
- (void)locationClick
{
    // 开启定位
    [_locationService startUserLocationService];
    
}

#pragma mark - 反编码
- (void)reverseCodeClick
{
//    float lat = 22.610434;
//    float lot = 114.066266;
    
    CLLocationCoordinate2D pt = _updateLocation;
//    if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
//        pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
//    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}

#pragma mark - BMKGeoCodeSearchDelegate
// 地理位置反编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    // 所有的地址信息全部包括在BMKReverseGeoCodeResult这个类中
    // _address                 = @"广东省深圳市龙岗区五和大道"
    // _businessCircle          = @"坂田"
    // _sematicDescription      = @"深圳新融典科技有限公司附近14米"
    // _poiList                 = @"10 elements"
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0)
    {
        BMKPointAnnotation *item    = [[BMKPointAnnotation alloc]init];
        item.coordinate             = result.location;
        item.title                  = result.address;
        [_mapView addAnnotation:item];
        
        _mapView.centerCoordinate = result.location;
        
        _titleStr = @"反向地理编码";
        _address = [NSString stringWithFormat:@"%@",item.title];
        NSLog(@"拿到的定位数据 ========== %@",_address);
    }
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

// 途径的点
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]])
    {
        return [(RouteAnnotation *)annotation getRouteAnnotationView:mapView];
    }
    return nil;
}

// 途径的点描绘出来
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *polylineView   = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor          = [UIColor redColor];
        polylineView.strokeColor        = [UIColor cyanColor];
        polylineView.lineWidth          = 2;
        return polylineView;
    }
    return nil;
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
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
    _updateLocation = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
//    NSLog(@"纬度======%f",userLocation.location.coordinate.latitude);
//    NSLog(@"经度======%f",userLocation.location.coordinate.longitude);
//    NSLog(@"位置======%@",userLocation.title);
//    NSLog(@"子位置======%@",userLocation.subtitle);

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

#pragma mark - BMKRouteSearchDelegate
/**
 *  返回公交路线检索结果
 *  @param searcher 搜索对象
 *  @param result   搜索结果，类型为BMKMassTransitRouteResult
 *  @param error    错误号，类型为BMKSearchErrorCode
 */
- (void)onGetMassTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKMassTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"公交查询线路结果 ============= %u",error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR)
    {
        BMKMassTransitRouteLine* routeLine = (BMKMassTransitRouteLine*)[result.routes objectAtIndex:0];
        
        BOOL startCoorIsNull = YES;
        CLLocationCoordinate2D startCoor;//起点经纬度
        CLLocationCoordinate2D endCoor;//终点经纬度
        
        NSInteger size = [routeLine.steps count];
        NSInteger planPointCounts = 0;
        for (NSInteger i = 0; i < size; i++)
        {
            BMKMassTransitStep* transitStep = [routeLine.steps objectAtIndex:i];
            
            for (BMKMassTransitSubStep *subStep in transitStep.steps)
            {
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = subStep.entraceCoor;
                item.title = subStep.instructions;
                item.type = 2;
                [_mapView addAnnotation:item];
                
                if (startCoorIsNull)
                {
                    startCoor = subStep.entraceCoor;
                    startCoorIsNull = NO;
                }
                endCoor = subStep.exitCoor;
                
                //轨迹点总数累计
                planPointCounts += subStep.pointsCount;
                
                //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
                if (transitStep.isSubStep == NO)
                {
                    //是子方案，只取第一条方案
                    break;
                }
                else
                {
                    //是子路段，需要完整遍历transitStep.steps
                }
            }
        }
        
        //添加起点标注
        RouteAnnotation* startAnnotation = [[RouteAnnotation alloc]init];
        startAnnotation.coordinate = startCoor;
        startAnnotation.title = @"起点";
        startAnnotation.type = 0;
        [_mapView addAnnotation:startAnnotation];
        
        //添加终点标注
        RouteAnnotation* endAnnotation = [[RouteAnnotation alloc]init];
        endAnnotation.coordinate = endCoor;
        endAnnotation.title = @"终点";
        endAnnotation.type = 1;
        [_mapView addAnnotation:endAnnotation];
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        NSInteger index = 0;
        for (BMKMassTransitStep* transitStep in routeLine.steps)
        {
            for (BMKMassTransitSubStep *subStep in transitStep.steps)
            {
                for (NSInteger i = 0; i < subStep.pointsCount; i++)
                {
                    temppoints[index].x = subStep.points[i].x;
                    temppoints[index].y = subStep.points[i].y;
                    index++;
                }
                
                //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
                if (transitStep.isSubStep == NO)
                {
                    //是子方案，只取第一条方案
                    break;
                }
                else
                {
                    //是子路段，需要完整遍历transitStep.steps
                }
            }
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
}

#pragma mark - 私有

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *)polyLine
{
    CGFloat leftTopX, leftTopY, rightBottomX, rightBottomY;
    if (polyLine.pointCount < 1)
    {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    // 左上角顶点
    leftTopX = pt.x;
    leftTopY = pt.y;
    // 右下角顶点
    rightBottomX = pt.x;
    rightBottomY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
        leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
        rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
        rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTopX, leftTopY);
    rect.size = BMKMapSizeMake(rightBottomX - leftTopX, rightBottomY - leftTopY);
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 0, 100, 0);
    BMKMapRect fitRect = [_mapView mapRectThatFits:rect edgePadding:padding];
    [_mapView setVisibleMapRect:fitRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
