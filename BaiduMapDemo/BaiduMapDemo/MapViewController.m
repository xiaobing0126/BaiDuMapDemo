//
//  MapViewController.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/28.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MapViewController ()<BMKMapViewDelegate>

@property (nonatomic,strong)BMKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"地图";

    [self initMapView];
}

#pragma mark - 地图定制
- (void)initMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];

}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"BMKMapView控件初始化完成");
}

// 单次点击
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"map view: click blank");
}

// 双击
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"map view: double click");
}

#pragma mark - 释放
- (void)dealloc
{
    _mapView = nil;
    _mapView.delegate = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
