//
//  RootViewController.m
//  BaiduMapDemo
//
//  Created by 宗炳林 on 2017/12/28.
//  Copyright © 2017年 宗炳林. All rights reserved.
//

#import "RootViewController.h"
#import "MapViewController.h"
#import "LocationViewController.h"
#import "POISearchViewController.h"
#import "RouteSearchViewController.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"百度地图Demo";
    
    [self initData];
    [self initView];
}

#pragma mark - 初始化数据
- (void)initData
{
    _dataArray = @[@"地图",@"定位",@"POI搜索",@"路线规划"];
}

#pragma mark - 视图定制
- (void)initView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _listTableView.dataSource   = self;
    _listTableView.delegate     = self;
    _listTableView.tableFooterView = [UIView new];
    [self.view addSubview:_listTableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            
            MapViewController *mapVc = [[MapViewController alloc] init];
            [self.navigationController pushViewController:mapVc animated:YES];
            
            break;
        }
            
        case 1:
        {
            
            LocationViewController *locationVc = [[LocationViewController alloc] init];
            [self.navigationController pushViewController:locationVc animated:YES];
            
            break;
        }
            
        case 2:
        {
            
            POISearchViewController *poiSearchVc = [[POISearchViewController alloc] init];
            [self.navigationController pushViewController:poiSearchVc animated:YES];
            
            break;
        }
            
        case 3:
        {
            
            RouteSearchViewController *routeSearchVc = [[RouteSearchViewController alloc] init];
            [self.navigationController pushViewController:routeSearchVc animated:YES];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
