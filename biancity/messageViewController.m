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
#import "UIView+KeyboardObserver.h"
#import "UserViewController.h"
#import "WGS84TOGCJ02.h"
#import "ModelGood.h"
#import "ResponseGood.h"
@interface messageViewController ()
{
    BOOL isloading;
    NSInteger index_comment;
}
@property (nonatomic,strong) ModelMessBoard* requestMess;
@property (nonatomic,strong) ResponseMess* responseMess;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation* local;
@property (nonatomic,strong)AMapSearchAPI * search;
@property (nonatomic,strong) GeoInfo* geoinfo;
@property (nonatomic,strong) UILabel *alertLabel;
@property (nonatomic,strong) UITextField * responseText;
@property (nonatomic,strong) UILabel * retrunLabel;
@property (nonatomic,strong) UIView *bgTextView;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) UILabel *bgPlaceHolderLabel;
@property (nonatomic,strong) ModelGood *requestGood;
@end

@implementation messageViewController
-(void)viewWillAppear:(BOOL)animated{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        [self showAlert:@"请设置app可访问位置信息"];
        
    }

    self.navigationItem.title =[NSString stringWithFormat:@"%@•留言",_townname];
    [_bgTextView addKeyboardObserver];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_bgTextView removeKeyboardObserver];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _geoinfo = [[GeoInfo alloc] init];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";
      _locationManager=[[CLLocationManager alloc]init];
    _requestGood = [[ModelGood alloc] init];
    _requestGood.type = [NSNumber numberWithInt:3];
    _requestGood.targetid = 0;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    _requestMess = [[ModelMessBoard alloc] init];
    _requestMess.messposition = [[NSNumber alloc] initWithInt:0];
    _messageTableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -32)];
    _messageTableView.delegate =self;
    _messageTableView.dataSource = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_messageTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
    
    _bgTextView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, _messageTableView.frame.size.width, 40)];
    _bgTextView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _responseText = [[UITextField alloc] initWithFrame:CGRectMake(5, 4, _bgTextView.frame.size.width-80, _bgTextView.frame.size.height-8)];
    _responseText.layer.borderWidth =1.0;
    _responseText.layer.cornerRadius =3.0;
    _responseText.backgroundColor =[UIColor whiteColor];
    _responseText.layer.borderColor = [[UIColor grayColor] CGColor];
    _responseText.returnKeyType =UIReturnKeyDone;
    _responseText.placeholder = @"说点什么吧";
    _responseText.delegate = self;
    _retrunLabel = [[UILabel alloc] initWithFrame:CGRectMake(_responseText.frame.size.width+_responseText.frame.origin.x+10, _responseText.frame.origin.y, 55, _responseText.frame.size.height)];
    _retrunLabel.textAlignment = NSTextAlignmentCenter;
    _retrunLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    _retrunLabel.layer.borderWidth = 1.0;
    _retrunLabel.backgroundColor = [UIColor whiteColor];
    _retrunLabel.layer.cornerRadius = 3.0;
    _retrunLabel.text = @"评论";
    UITapGestureRecognizer *commitComments = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitComment)];
    _retrunLabel.userInteractionEnabled = YES;
    [_retrunLabel addGestureRecognizer:commitComments];
    
    
    [_bgTextView addSubview:_responseText];
    [_bgTextView addSubview:_retrunLabel];
    _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 64, [UIScreen mainScreen].bounds.size.width-8, 10)];
    _alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _alertLabel.numberOfLines =0;
  
     _bgPlaceHolderLabel = [[UILabel alloc] initWithFrame:_messageTableView.frame];
    [self.view addSubview:_alertLabel];
    [self.view addSubview:_messageTableView];
    [self.view addSubview:_bgTextView];
    [self.view addSubview:_bgPlaceHolderLabel];
    _bgPlaceHolderLabel.hidden = YES;
     _bgTextView.alpha = 0;
    _bgTextView.hidden =YES;
    [self addHeader];
    [self addFooter];
    [self localInfo];
    index_comment =-1;
    isloading =NO;

}
-(void)commitComment{
    [_responseText resignFirstResponder];
    NSString *comm;
   if(index_comment>=0){
        comm =[NSString stringWithFormat:@"%@//<font color='#1E90FF'>@%@</font>:%@", _responseText.text,[[_responseMess.mess objectAtIndex:index_comment] username],[[_responseMess.mess objectAtIndex:index_comment] content]];
    }
    else{
        comm =[NSString stringWithFormat:@"%@", _responseText.text];
    }
    _responseText.text = @"";
    _requestMess.content = comm;
    [self loadInfo:2];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status==kCLAuthorizationStatusAuthorizedWhenInUse){
       [self localInfo];
    }
    NSLog(@"didChangeAuthorizationStatus");
}
-(void)localInfo{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
//        //设置代理
//        _locationManager.delegate=self;
//        //设置定位精度
//        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        //定位频率,每隔多少米定位一次
//        CLLocationDistance distance=1.0;//十米定位一次
//        _locationManager.distanceFilter=distance;
//        //启动跟踪定位
//        [_locationManager startUpdatingLocation];
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        UILabel* lab = [[UILabel alloc] initWithFrame:_alertLabel.frame];
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines =0;
        CGRect rect;
        lab.text =[NSString stringWithFormat:@"更多精彩，请允许程序访问位置信息(^o^)"];
        [lab sizeToFit];
        NSLog(@"frame w %f,h %f",lab.frame.size.width,lab.frame.size.height);
        rect = lab.frame;
        rect.size.height +=15;
        _alertLabel.frame = rect;
        _alertLabel.text= [NSString stringWithFormat:@"更多精彩，请允许程序访问位置信息(^o^)"];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        rect = _messageTableView.frame;
        rect.origin.y = _alertLabel.frame.size.height+_alertLabel.frame.origin.y;
        rect.size.height = [UIScreen mainScreen].bounds.size.height-rect.origin.y;
        _messageTableView.frame = rect;
        _bgTextView.hidden =YES;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }

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
#pragma Location
#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    if(userLocation){
        //        NSLog(@"%@",userLocation);
        _geoinfo.latitude =[[NSNumber alloc]initWithDouble:userLocation.coordinate.latitude];
        _geoinfo.longitude = [[NSNumber alloc] initWithDouble:userLocation.coordinate.longitude];
        _geoinfo.accuracy = [[NSNumber alloc] initWithDouble:userLocation.location.horizontalAccuracy] ;
        //
        _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey  Delegate:self];
    _local=[[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
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
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
     NSLog(@"AMapReGeocodeSearchResponse localtion");
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
        UILabel* lab = [[UILabel alloc] initWithFrame:_alertLabel.frame];
         lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines =0;
        if(_geoinfo.province.length>0){
            CLLocationDistance meters=[_local distanceFromLocation:_townLocal];
                       CGRect rect;
            NSLog(@"meters %f",meters);
            _mapView.showsUserLocation = NO;
            if(meters>500){
                lab.text =[NSString stringWithFormat:@"请开启手机定位功能，需要距离边城附近500才能留言哦，你距离边城还有%f米,在努力靠近一点吧",meters];
                [lab sizeToFit];
                NSLog(@"frame w %f,h %f",lab.frame.size.width,lab.frame.size.height);
                rect = lab.frame;
                rect.size.height +=15;
                _alertLabel.frame = rect;
                _alertLabel.text= [NSString stringWithFormat:@"请开启手机定位功能，需要距离边城附近500才能留言哦，你距离边城还有%f米,在努力靠近一点吧",meters];
                  _alertLabel.textAlignment = NSTextAlignmentCenter;
                rect = _messageTableView.frame;
                rect.origin.y = _alertLabel.frame.size.height+_alertLabel.frame.origin.y;
                rect.size.height = [UIScreen mainScreen].bounds.size.height-rect.origin.y;
                _messageTableView.frame = rect;
                _bgTextView.hidden =YES;
                [self.view setNeedsDisplay];
            }else{
                lab.text = [NSString stringWithFormat:@"你在边城附近，可以留言"];
                [lab sizeToFit];
                rect = lab.frame;
                rect.size.height+=10;
                _alertLabel.frame =rect;
                _alertLabel.text = [NSString stringWithFormat:@"你在边城附近，可以留言"];
                  _alertLabel.textAlignment = NSTextAlignmentCenter;
                rect = _messageTableView.frame;
                rect.origin.y = _alertLabel.frame.size.height+_alertLabel.frame.origin.y;
                rect.size.height = [UIScreen mainScreen].bounds.size.height-rect.origin.y;
                rect.size.height = rect.size.height -40;
                _messageTableView.frame = rect;
                _bgTextView.alpha = 1;
                _bgTextView.hidden = NO;
                [self.view setNeedsDisplay];
          }
        
        }else {
         _mapView.showsUserLocation=YES;
        }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(_bgTextView.hidden==NO){
         _responseText.placeholder = [NSString stringWithFormat:@"回复: %@",[[_responseMess.mess objectAtIndex:indexPath.row] username]];
        [_responseText becomeFirstResponder];
        index_comment = indexPath.row;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *commentCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-45, 10)];
    CGRect rect;
    ModelMessBoard *tmp;
    commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    
    UITapGestureRecognizer* tapGood = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doGoodCommit:)];
    if([((ModelMessBoard*)[_responseMess.mess objectAtIndex:indexPath.row]).dogood boolValue]){
        commentCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumbup"];
    }else{
        commentCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumb"];
    }
    commentCell.iconGoodImage.tag = indexPath.row;
    commentCell.iconGoodImage.userInteractionEnabled =YES;
    [commentCell.iconGoodImage addGestureRecognizer:tapGood];
    //commentCell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
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
-(void)doGoodCommit:(UITapGestureRecognizer*)sender{
    if(!isloading){
        NSInteger tag = ((UIImageView*)[sender view]).tag;
        
        if([((ModelMessBoard*)[_responseMess.mess objectAtIndex:tag]).dogood boolValue]){
            _requestGood.action = [NSNumber numberWithInt:1];
        }else{
            _requestGood.action = [NSNumber numberWithInt:0];
        }
        _requestGood.type = [NSNumber numberWithInt:3];
        _requestGood.targetid =((ModelMessBoard*)[_responseMess.mess objectAtIndex:tag]).messid;
        [self loadGoodInfo:1 tag:tag];
        isloading =YES;
    }
    
    
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
        _requestMess.geo = _geoinfo;
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
       
        if([_responseMess.mess count]==0){
             _bgPlaceHolderLabel.hidden = NO;
            CGRect rect =_messageTableView.frame;
            rect.size.height = 350;
            _bgPlaceHolderLabel.frame =rect;
            _bgPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
            _bgPlaceHolderLabel.text =@"还没有留言";
            _messageTableView.hidden = YES;
        }else{
            _bgPlaceHolderLabel.hidden = YES;
            _messageTableView.hidden =NO;
             [_messageTableView reloadData];
            if(check ==2){
                
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [_messageTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check==0){
             [_messageTableView headerEndRefreshing ];
        }else{
            [_messageTableView footerEndRefreshing];
        }
    }];
}


-(void)loadGoodInfo:(NSInteger)check tag:(NSInteger)tag{
    
    NSDictionary *parameters = [_requestGood toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    if(check ==0){
        url=[NSString stringWithString:getGoodsUrl];
    }else {
        url=[NSString stringWithString:doGoodUrl];
        
    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadGoodInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        // [self.bgScrollView headerEndRefreshing];
     
            ResponseGood * ad;
            ad = [[ResponseGood alloc] initWithDictionary:data error:nil];
            ((ModelMessBoard*) [_responseMess.mess objectAtIndex:tag]).dogood=[NSNumber numberWithBool: ad.good.dogood];
            ((ModelMessBoard*) [_responseMess.mess objectAtIndex:tag]).goods = ad.good.goods;
                [_messageTableView reloadData];
        isloading =NO;
        log(@"loadGoodInfo stat is %d,errcode is %d",ad.stat,ad.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[self.bgScrollView headerEndRefreshing];
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
