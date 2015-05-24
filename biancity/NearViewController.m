//
//  NearViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "NearViewController.h"
#import "Cells/HotTownCollectionViewCell.h"
#import "model/ResponseHotTown.h"
#import "Refresh.h"
#import "MsgEncrypt.h"
#import "basicRequest.h"
#import "ModelNearTown.h"
#import "AFHTTPRequestOperationManager.h"
#import "showNavigationController.h"
#import "responseApplyTown.h"
#import "townViewController.h"
@interface NearViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *nearCollectionView;
@property (nonatomic,strong) ResponseHotTown * hotTown;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) ModelNearTown* nearTown;
@property (nonatomic,strong) responseApplyTown *applyTown;
@property (nonatomic,strong)  showNavigationController *show;
@property (nonatomic,strong) townViewController *town;
@property (nonatomic,strong) MAMapView *mapView;
@end

@implementation NearViewController

-(void)viewWillAppear:(BOOL)animated{
    
    if (![CLLocationManager locationServicesEnabled]) {
        [self showAlert:@"定位服务当前可能尚未打开，请设置打开！"];
        return;
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        [self showAlert:@"请到后台设置APP可访问地理信息"];
        //[vc.nearCollectionView headerBeginRefreshing];
    }
        NSLog(@"appear");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _applyTown = [[responseApplyTown alloc] init];
    _show  = [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
     _town=[[townViewController alloc] initWithNibName:@"townViewController" bundle:nil];
  
    [_show pushViewController:_town animated:YES ];

   // UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
    _nearTown = [[ModelNearTown alloc] init];
    _nearTown.geo = [[GeoInfo alloc] init];
    _nearTown.rejectid =[[NSMutableArray alloc] init];
    [self.nearCollectionView registerClass:[HotTownCollectionViewCell class] forCellWithReuseIdentifier:@"HotTownCollectionViewCell"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.nearCollectionView.dataSource =self;
    self.nearCollectionView.delegate = self;
#pragma basic
//    _basic= [[basicRequest alloc] init];
//    _basic.ptoken=@"N6h5p5GsdTCHTooEXZkV0QfkckfmCBam";
//    _basic.ptuserid=17;
//  //  _basic.gethoturl =@"http://123.57.132.31:8080/gethot";
//    _basic.rejectid = [[NSMutableArray alloc]init];
//    _basic.gethoturl =@"http://123.57.132.31:8080/getnear";
#pragma end basic
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate =self;
    [self addHeader];
    [self addFooter];
    
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma CollectionView
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5.0, 5.0, 5.0);
};
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width-16)/2,(collectionView.frame.size.width-16)/2 +50);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.hotTown.towns count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotTownCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotTownCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius =5;
    NSString * imageUrl = [[self.hotTown.towns objectAtIndex:indexPath.row] cover];
    NSMutableString *pictureUrl = [[NSMutableString alloc] initWithString:getPictureUrl];
    [pictureUrl appendString:imageUrl];
    [pictureUrl appendString:@"!small"];
    // NSLog(@"imageUrl = %@",pictureUrl);
    [cell.HotTownCoverImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
    
    [cell.hotTownNameLabel setText:[[self.hotTown.towns objectAtIndex:indexPath.row] townname]];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:[[self.hotTown.towns objectAtIndex:indexPath.row] geoinfo].city];
    [addr appendString:[[self.hotTown.towns objectAtIndex:indexPath.row] geoinfo].freeaddr];
    [cell.addrLabel setText:addr];
    [cell.goodLabel setText:[NSString stringWithFormat:@"%@", [[self.hotTown.towns objectAtIndex:indexPath.row] good]]];
    cell.icon1Image.image = [UIImage imageNamed:@"ic_location_small_light"];
    cell.icon2Image.image = [UIImage imageNamed:@"ic_list_thumb_small"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    _applyTown = [_hotTown.towns objectAtIndex:indexPath.row];
     _town.applyTown = _applyTown;
    [self presentViewController:_show animated:YES completion:^{}];
    
}
#pragma Collectionview end
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status==kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.nearCollectionView headerBeginRefreshing];
    }
    NSLog(@"didChangeAuthorizationStatus");
}
#pragma header and footer
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.nearCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
           [_locationManager requestWhenInUseAuthorization];
            [vc.nearCollectionView headerEndRefreshing];
             //[vc.nearCollectionView headerBeginRefreshing];
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
//            //设置代理
//            _locationManager.delegate=vc;
//            //设置定位精度
//            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//            //定位频率,每隔多少米定位一次
//            CLLocationDistance distance=1.0;//十米定位一次
//            _locationManager.distanceFilter=distance;
//            //启动跟踪定位
//            [_locationManager startUpdatingLocation];
            [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";

            _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            _mapView.delegate = self;
            _mapView.showsUserLocation = YES;
        }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
            [vc.nearCollectionView headerEndRefreshing];

        }
        if (![CLLocationManager locationServicesEnabled]) {
            [self showAlert:@"定位服务当前可能尚未打开，请设置打开！"];
            return;
        }

        // [vc loadInfo:0];
    }];
    [self.nearCollectionView headerBeginRefreshing];
}
-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.nearCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadInfo:1];
        
    }];
}
#pragma header and footer end

#pragma loading Infomation
-(void)loadInfo:(int)check{
    if(check==0){
        [_nearTown.rejectid removeAllObjects];
    }
    _nearTown.rejectid =_nearTown.rejectid  ;
    NSDictionary *parameters = [_nearTown toDictionary];//[[basicRequest sharedBaseic] paraters];
  //  NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getNearTownUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Near Info is %@",info);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check==0){
            self.hotTown = [[ResponseHotTown alloc] initWithDictionary:data error:nil];
            [self.nearCollectionView headerEndRefreshing];
            for(int i=0;i<[self.hotTown.towns count];i++){
                NSNumber* rjid= [[self.hotTown.towns objectAtIndex:i] townid];
                [_nearTown.rejectid  addObject:rjid];
            }
        }else {
            ResponseHotTown *ad=[[ResponseHotTown alloc] initWithDictionary:data error:nil];
            [self.hotTown.towns addObjectsFromArray:ad.towns];
            _hotTown.stat = ad.stat;
            _hotTown.errcode = ad.errcode;
            for(int i=0;i<[ad.towns count];i++){
                NSNumber* rjid= [[ad.towns objectAtIndex:i] townid];
                [_nearTown.rejectid addObject:rjid];
            }
            [self.nearCollectionView footerEndRefreshing];
        }
        [self.nearCollectionView reloadData];
        log(@"near stat is %d,errcode is %d",self.hotTown.stat,self.hotTown.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check ==0){
            [self.nearCollectionView headerEndRefreshing];
        }else {
            [self.nearCollectionView footerEndRefreshing];
        }
        
    }];
}

#pragma end loading Infomation

#pragma Location
#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
   // NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    _nearTown.geo.latitude = [[NSNumber alloc] initWithDouble:coordinate.latitude];
    _nearTown.geo.longitude = [[NSNumber alloc] initWithDouble:coordinate.longitude];
        if(_nearTown.geo.latitude!=nil){
        [_locationManager stopUpdatingLocation];
        [self loadInfo:0];
        }else{
         [_locationManager startUpdatingLocation];
        }
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    if(userLocation){
        //        NSLog(@"%@",userLocation);
          _nearTown.geo.latitude =[[NSNumber alloc]initWithDouble:userLocation.coordinate.latitude];
          _nearTown.geo.longitude = [[NSNumber alloc] initWithDouble:userLocation.coordinate.longitude];
        
        if(_nearTown.geo.latitude!=nil){
            _mapView.showsUserLocation = NO;
            [_mapView removeFromSuperview];
            [self loadInfo:0];
        }else{
            _mapView.showsUserLocation = YES;
        }

       
//        _geoinfo.accuracy = [[NSNumber alloc] initWithDouble:userLocation.location.horizontalAccuracy] ;
//        //
//        _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey  Delegate:self];
//        _local=[[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//        //
//        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
//        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//        regeoRequest.searchType = AMapSearchType_ReGeocode;
//        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//        regeoRequest.radius = 10000;
//        regeoRequest.requireExtension = YES;
//        
//        //发起逆地理编码
//        [_search AMapReGoecodeSearch: regeoRequest];
    }
}
#pragma end location
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
