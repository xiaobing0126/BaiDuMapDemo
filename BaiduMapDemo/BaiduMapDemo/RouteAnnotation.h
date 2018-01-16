//
//  RouteAnnotation.h
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2018/1/2.
//  Copyright © 2018年 宗炳林. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
@property (nonatomic)NSInteger type;
@property (nonatomic)NSInteger degree;

/**
 *  获取该RouteAnnotation对象的BMKAnnotationView
 */
- (BMKAnnotationView *)getRouteAnnotationView:(BMKMapView *)mapView;

@end
