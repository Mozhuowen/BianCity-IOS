//
//  locationViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "locationViewController.h"
#import "saveAddrViewController.h"
#import "GeoInfo.h"
@interface locationViewController ()
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) GeoInfo* geoinfo;
@property (nonatomic,strong)AMapSearchAPI * search;
@end

@implementation locationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _geoinfo = [[GeoInfo alloc] init];
    self.navigationItem.title = @"创建边城";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _msgLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _msgLabel.text = @"你将在以下地点附近建立边城，请开启手机定位功能并等待定位到当前位置";
    _msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
     _msgLabel.numberOfLines = 0;
    
#pragma location
    [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-120.0)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //[_mapView setZoomLevel:16.1 animated:YES];
     [self.view addSubview:_mapView];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectLeftAction:(id)sender{
     _mapView.showsUserLocation = NO;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
    _mapView.showsUserLocation = NO;
    
    saveAddrViewController *save = [[saveAddrViewController alloc] initWithNibName:@"saveAddrViewController" bundle:nil];
    self.t_delegate = save;
   [self transfromInfo];
    [self.navigationController pushViewController:save  animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定位
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    if(userLocation){
//        NSLog(@"%@",userLocation);
        _geoinfo.latitude =[[NSNumber alloc]initWithDouble:userLocation.coordinate.latitude];
        _geoinfo.longitude = [[NSNumber alloc] initWithDouble:userLocation.coordinate.longitude];
      _geoinfo.accuracy = [[NSNumber alloc] initWithDouble:userLocation.location.horizontalAccuracy] ;
//        
        _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey  Delegate:self];
//        
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeoRequest];
    }
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        _geoinfo.province = response.regeocode.addressComponent.province;
        _geoinfo.city = response.regeocode.addressComponent.city;
        _geoinfo.district = response.regeocode.addressComponent.district;
         _geoinfo.citycode =  response.regeocode.addressComponent.citycode;
         _geoinfo.country = @"中国";
         _geoinfo.district = response.regeocode.addressComponent.district;
         _geoinfo.street = response.regeocode.addressComponent.streetNumber.street;
        NSArray * road = response.regeocode.roads ;
        AMapRoad *roadD = [road objectAtIndex:0];
         _geoinfo.road = roadD.name ;
        NSMutableString * addr = [[NSMutableString alloc] initWithString:_geoinfo.province];
        [addr appendString:_geoinfo.city];
         [addr appendString:_geoinfo.district];
         [addr appendString:response.regeocode.addressComponent.township];
         [addr appendString:_geoinfo.street];
          [addr appendString:_geoinfo.road];
        _geoinfo.address = addr;
      //  NSLog(@"%@",_geoinfo);
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        NSLog(@"ReGeo: %@", result);
    }
}

- (void)transfromInfo{
    // NSLog(@"tapped");
    if ([self.t_delegate respondsToSelector:@selector(setGeoInfo:)])
    {
        [self.t_delegate setGeoInfo:_geoinfo];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
