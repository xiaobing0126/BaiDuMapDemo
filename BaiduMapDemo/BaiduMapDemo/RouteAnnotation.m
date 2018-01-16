//
//  RouteAnnotation.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2018/1/2.
//  Copyright © 2018年 宗炳林. All rights reserved.
//

#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

- (BMKAnnotationView *)getRouteAnnotationView:(BMKMapView *)mapView
{
    ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
    BMKAnnotationView *view = nil;
    switch (_type) {
        case 0:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_start.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
        case 1:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_end.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 2:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_bus.png"];
            }
        }
            break;
        case 3:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_rail.png"];
            }
        }
            break;
        case 4:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"route_node"];
            }
            else
            {
                [view setNeedsDisplay];
            }
            
            UIImage* image  = [UIImage imageNamed:@"icon_direction.png"];
            view.image      = [image imageRotateByDegrees:_degree];
        }
            break;
        case 5:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            }
            else
            {
                [view setNeedsDisplay];
            }
            
            UIImage* image  = [UIImage imageNamed:@"icon_waypoint.png"];
            view.image      = [image imageRotateByDegrees:_degree];
        }
            break;
            
        case 6:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"stairs_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"stairs_node"];
            }
            view.image = [UIImage imageNamed:@"icon_stairs.png"];
        }
            break;
            
        default:
            break;
    }
    return view;
}

@end
