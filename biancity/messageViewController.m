//
//  messageViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/17.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "messageViewController.h"
#import "CommentTableViewCell.h"
#import "ModelMessBoard.h"
#import "ResponseMess.h"
#import "Refresh.h"

#import "UserViewController.h"
@interface messageViewController ()
@property (nonatomic,strong) ModelMessBoard* requestMess;
@property (nonatomic,strong) ResponseMess* responseMess;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation* local;
@property (nonatomic,strong)AMapSearchAPI * search;
@property (nonatomic,strong) GeoInfo* geoinfo;
@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _geoinfo = [[GeoInfo alloc] init];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";
      _locationManager=[[CLLocationManager alloc]init];
     self.navigationItem.title = @"评论";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
   
    _requestMess = [[ModelMessBoard alloc] init];
    _requestMess.messposition = [[NSNumber alloc] initWithInt:0];
    _messageTableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -84)];
    _messageTableView.delegate =self;
    _messageTableView.dataSource = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_messageTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
    [self.view addSubview:_messageTableView];
  
    [self addHeader];
    [self addFooter];
}
-(void)localInfo{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=1.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }

}
#pragma Location
#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    // NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    _geoinfo.latitude =[[NSNumber alloc]initWithDouble:location.coordinate.latitude];
    _geoinfo.longitude = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
    _geoinfo.accuracy = [[NSNumber alloc] initWithDouble:location.horizontalAccuracy] ;
    _local=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_locationManager stopUpdatingLocation];
    CLLocationDistance meters=[_local distanceFromLocation:_townLocal];
    if(meters>50){
    
    }else{
        _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey  Delegate:self];
        //
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
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
#pragma end location
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"mess count %ld",[_responseMess.mess count]);
    return [_responseMess.mess count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label;
    NSString *str;
    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-45, 10)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    str= [[[_responseMess.mess objectAtIndex:indexPath.row] content] stringByReplacingOccurrencesOfString:@"<font color='#1E90FF'>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    
    label.text =str;
    [label sizeToFit];
    return 40 + ((label.frame.size.height+20)>45?(label.frame.size.height+20):45);

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *commentCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-45, 10)];
    CGRect rect;
    ModelMessBoard *tmp;
    commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    commentCell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
    NSLog(@"index.row is %ld",(long)indexPath.row);
    tmp =[_responseMess.mess objectAtIndex:indexPath.row];
    [self setUserImage:tmp.cover imageView:commentCell.iconUserImage row:indexPath.row];
    NSString*str= [tmp.content stringByReplacingOccurrencesOfString:@"<font color='#1E90FF'>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text =str;
    [label sizeToFit];
    rect = commentCell.commentlabel.frame;
    rect.size.height = label.frame.size.height>35?label.frame.size.height:35;
    rect.size.width = label.frame.size.width >=275?label.frame.size.width:275;
    rect.size.height +=10;
    
    NSString *myImgUrl = tmp.content;
    NSString *jap = @"</font>";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0){
        commentCell.commentRTlabel.hidden =NO;
        commentCell.commentRTlabel.frame =rect;
        commentCell.commentRTlabel.text =tmp.content;
        commentCell.commentlabel.hidden = YES;
    }else{
        commentCell.commentlabel.hidden = NO;
        commentCell.commentlabel.frame = rect;
        commentCell.commentlabel.text = tmp.content;
        commentCell.commentRTlabel.hidden =YES;
    }
    log(@"commentCell width %f,commentCell height %f",commentCell.commentlabel.frame.size.width,commentCell.commentlabel.frame.size.height);
    // [commentCell.commentlabel setNeedsDisplay];
    commentCell.userNameLabel.text = tmp.username;
    commentCell.dateLabel.text =tmp.time;
    commentCell.goodLabel.text = [NSString stringWithFormat:@"%@",tmp.goods];
    
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return commentCell;
}

-(void)setUserImage:(NSString *)imageName imageView:(UIImageView*)imView row:(NSInteger)index_row{
    NSString *myImgUrl = imageName;
    NSString *jap = @"http://";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(imageName){
        if(foundObj.length>0) {
            [imView  sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options: index_row == 0 ? SDWebImageRefreshCached : 0] ;
        }else {
            NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
            [temp appendString:imageName];
            [temp appendString:@"!small"];
            [imView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:index_row == 0 ? SDWebImageRefreshCached : 0] ;
        }
    }else {
        imView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    }
    imView.tag = index_row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
    [imView addGestureRecognizer:tap];
    imView.userInteractionEnabled =YES;
}
-(void)tapUser:(UITapGestureRecognizer*)sender{
    UIImageView *vi =( UIImageView *) [sender view];
    NSInteger idx_user = vi.tag;
    NSLog(@"tag %ld",(long)idx_user);
    UserViewController * user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];

        user.userid = [[_responseMess.mess objectAtIndex:idx_user] userid];
        user.UserCover = [[_responseMess.mess objectAtIndex:idx_user] cover];
        user.UserName = [[_responseMess.mess objectAtIndex:idx_user] username];
    user.via = YES;
    [self.navigationController pushViewController:user animated:YES];
}


#pragma header and footer
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.messageTableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc loadInfo:0];
    }];
    [self.messageTableView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.messageTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadInfo:1];
        
    }];
}
#pragma loading Infomation
-(void)loadInfo:(int)check{
    NSDictionary *parameters;
    NSString *url ;
    if(check<=1){
        if(check==0){
            _requestMess.messposition =[NSNumber numberWithInt:0];;
        }
        url =[NSString stringWithString:getMessUrl];
    }else{
      url =[NSString stringWithString:submitMesstUrl];
    }
    _requestMess.townid =_townid;
      parameters = [_requestMess toDictionary];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Mess Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check ==0){
            self.responseMess = [[ResponseMess alloc] initWithDictionary:data error:nil];
            [_messageTableView headerEndRefreshing ];
        }else if(check==1){
            ResponseMess *ad = [[ResponseMess alloc] initWithDictionary:data error:nil];
            [_responseMess.mess addObjectsFromArray:ad.mess];
            [_messageTableView footerEndRefreshing];
        }else{
              self.responseMess = [[ResponseMess alloc] initWithDictionary:data error:nil];
        }
        _requestMess.messposition =[NSNumber numberWithInteger:[_responseMess.mess count]];
        log(@"responseMess stat is %d,errcode is %d",_responseMess.stat,_responseMess.errcode);
        [_messageTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check==0){
             [_messageTableView headerEndRefreshing ];
        }else{
            [_messageTableView footerEndRefreshing];
        }
    }];
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
