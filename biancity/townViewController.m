//
//  townViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/7.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "townViewController.h"
#import "Refresh.h"
#import "responseApplyTown.h"
#import "ResponseStory.h"
#import "Modelstory.h"
#import "StoryTableViewCell.h"
#import "ModelGood.h"
#import "ModelSubscriTown.h"
#import "ModelUser.h"
#import "ResponseSubscriTown.h"
#import "ResponseUser.h"
#import "addStoryViewController.h"
#import "ResponseGood.h"
@interface townViewController ()
@property (nonatomic,strong) ResponseStory *responseStroys;
@property (nonatomic,strong) ModelStory *requestStory;
@property (nonatomic,strong) UITableView *storyTableView;
@property (nonatomic,strong) ModelGood *requestGood;
@property (nonatomic,strong) ResponseGood *responseGood;
@property (nonatomic,strong) ModelSubscriTown *requestSubscriTown;
@property (nonatomic,strong) ResponseSubscriTown *responseSubscriTown;
@property (nonatomic,strong) ModelUser *requestFans;
@property (nonatomic,strong) ResponseUser *responseFans;
@property (nonatomic)  CGSize origin;
@property (nonatomic) NSInteger oldTownid;
@end

@implementation townViewController
-(void)viewWillAppear:(BOOL)animated{
    if(_oldTownid != [_applyTown.townid integerValue])
    [self.bgScrollView headerBeginRefreshing];
    _requestStory.townid = [_applyTown.townid intValue];
    _requestGood.targetid = _applyTown.townid;
    _requestGood.type = 0;
       _requestFans.userid = _applyTown.userid;
      _requestSubscriTown.townid = _applyTown.townid;
    if([_applyTown.ptuserid isEqualToNumber:_applyTown.userid]){
    self.navigationItem.title = @"我的边城";
        self.navigationItem.rightBarButtonItem = _rightButton;
        _iconAddImage.hidden = NO;
        
    }else {
        self.navigationItem.title = @"边城";
        self.navigationItem.rightBarButtonItem= nil;
        _iconAddImage.hidden = YES;
    }
    
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.cover,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
   
    NSString *myImgUrl = _applyTown.usercover;
    NSString *jap = @"http://";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(_applyTown.usercover){
        if(foundObj.length>0) {
            [_userImageView  sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options: 0] ;
        }else {
            NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
            [temp appendString:_applyTown.usercover];
            [temp appendString:@"!small"];
            [_userImageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
        }
    }else {
        _userImageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    }
    
    _leaveMsgLabel.text = @"留言";
     _storyLabel.text =[NSString stringWithFormat:@"故事(%@)",_applyTown.storycount];
    _townNameLabel.text = _applyTown.townname;
    _summaryLabel.text = [NSString stringWithFormat:@"简介: %@",_applyTown.descri];//@"描述";
        _userNameLabel.text = _applyTown.username;
    [_addrMapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.geoinfo.screenpng,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
    
    _addrLabel.text = [NSString stringWithFormat:@"%@%@%@",_applyTown.geoinfo.province,_applyTown.geoinfo.city,_applyTown.geoinfo.freeaddr];
    _oldTownid = [_applyTown.townid integerValue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;

     _leftButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    
     _rightButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
    _requestGood =[[ModelGood alloc] init];
    _requestGood.targetid = _applyTown.townid;
    _requestGood.type = 0;
    _requestStory = [[ModelStory alloc] init];
    _requestSubscriTown = [[ModelSubscriTown alloc] init];
    _requestFans = [[ModelUser alloc] init];
    _requestFans.userid = _applyTown.userid;
    _requestSubscriTown.townid = _applyTown.townid;
    self.navigationItem.leftBarButtonItem = _leftButton;
    self.navigationItem.rightBarButtonItem = _rightButton;
        self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGSize size = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height+100) ;
    _origin = size;
    _bgScrollView.contentSize = size;
   _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bgScrollView.frame.size.width, _bgScrollView.frame.size.width)];
    
    _townNameLabel =[[UILabel alloc ] initWithFrame:CGRectMake(4, _bgImageView.frame.origin.y+_bgImageView.frame.size.height+5, 150, 20)];
    _townNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    _goodslabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-70, _townNameLabel.frame.origin.y, 40, 20)];
    _goodslabel.textAlignment = NSTextAlignmentRight;
    
    _iconGoodImageView =[[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-25, _townNameLabel.frame.origin.y, 24, 24)];
    _iconGoodImageView.image =[UIImage imageNamed:@"ic_list_thumb"];
    _summaryLabel =[[UILabel alloc] initWithFrame:CGRectMake(4, _townNameLabel.frame.origin.y+_townNameLabel.frame.size.height+5, _bgImageView.frame.size.width-10, 15)];
    _summaryLabel.font = [UIFont systemFontOfSize:10];
    
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, _summaryLabel.frame.origin.y+30, 50, 50)];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 25;
//    _userImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.height+4, _userImageView.frame.origin.y, 100, 20)];
    _userNameLabel.font = [UIFont systemFontOfSize:14];

    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.size.height+_userNameLabel.frame.origin.y+5, 80, 12)];
   _fansLabel.font = [UIFont systemFontOfSize:14];
    
    _iconAddrimage = [[UIImageView alloc] initWithFrame:CGRectMake(_userImageView.frame.origin.x, _userImageView.frame.origin.y+_userImageView.frame.size.height+15, 20, 20)];
    
    _iconAddrimage.image = [UIImage imageNamed:@"ic_location_small"];
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake( _iconAddrimage.frame.origin.x+_iconAddrimage.frame.size.width+2, _iconAddrimage.frame.origin.y+3, 200, 12)];
    _addrLabel.font = [UIFont systemFontOfSize:14];
    _subscri = [[UILabel alloc ] initWithFrame:CGRectMake(5, _iconAddrimage.frame.origin.y+50, 80, 40)];
    _subscri.layer.borderWidth = 1.0;
    _subscri.layer.cornerRadius = 3.0;
    _subscri.textAlignment =NSTextAlignmentCenter;
    _subscri.layer.borderColor =[[UIColor grayColor] CGColor];
    _leaveMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subscri.frame.origin.x+90, _subscri.frame.origin.y, 80, 40)];
    _leaveMsgLabel.layer.borderWidth = 1.0;
    _leaveMsgLabel.layer.cornerRadius = 3.0;
    _leaveMsgLabel.layer.borderColor =[[UIColor grayColor] CGColor];
    _leaveMsgLabel.textAlignment =NSTextAlignmentCenter;
    _addrMapImage = [[UIImageView alloc ]initWithFrame:CGRectMake(self.view.frame.size.width*3/5-10,_summaryLabel.frame.origin.y+18, self.view.frame.size.width*2/5, _leaveMsgLabel.frame.origin.y+40-(_summaryLabel.frame.origin.y+20))];
//    _addrMapImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];

    _storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,_leaveMsgLabel.frame.origin.y+80, 80, 35)];
    _storyLabel.textAlignment =NSTextAlignmentCenter;
    _storyLabel.backgroundColor = [UIColor blueColor];
    _storyLabel.textColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddStory)];
    _iconAddImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width -50, _storyLabel.frame.origin.y-5, 45, 45)];
    _iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
    _iconAddImage.userInteractionEnabled = YES;
    [_iconAddImage addGestureRecognizer:tap];
    _storyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _iconAddImage.frame.origin.y+50, self.view.frame.size.width, 200)];
    _storyTableView.dataSource = self;
    _storyTableView.delegate = self;
    [_storyTableView registerClass:[StoryTableViewCell class] forCellReuseIdentifier:@"StoryTableViewCell"];
     _storyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgScrollView addSubview:_bgImageView];
    [_bgScrollView addSubview:_townNameLabel];
    [_bgScrollView addSubview:_goodslabel];
    [_bgScrollView addSubview:_iconGoodImageView];
    [_bgScrollView addSubview:_summaryLabel];
    [_bgScrollView addSubview:_userImageView];
    [_bgScrollView addSubview:_userNameLabel];
    [_bgScrollView addSubview:_fansLabel];
    [_bgScrollView addSubview:_iconAddrimage];
    [_bgScrollView addSubview:_addrLabel];
    
    [_bgScrollView addSubview:_subscri];
    [_bgScrollView addSubview:_leaveMsgLabel];
    [_bgScrollView addSubview:_addrMapImage];
    [_bgScrollView addSubview:_fansLabel];
    [_bgScrollView addSubview:_storyLabel];
    [_bgScrollView addSubview:_iconAddImage];
    [_bgImageView addSubview:_storyTableView];
    [self.view addSubview:_bgScrollView];
    _bgScrollView.userInteractionEnabled =YES;
    [self addHeader];
    [self addFooter];
    // Do any additional setup after loading the view from its nib.
}
-(void)AddStory{
    addStoryViewController * add = [[addStoryViewController alloc] init];
    [self.navigationController pushViewController:add  animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{

    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
    
    [self.navigationController pushViewController:nil  animated:NO];
}
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.bgScrollView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
//        UILabel *tmp = [[UILabel alloc] initWithFrame:vc.view.frame];
//        tmp.textAlignment = NSTextAlignmentCenter;
//        tmp.text = @"add header success!";
//        //tmp.backgroundColor= [UIColor grayColor];
//        [vc.bgScrollView addSubview:tmp];
        [vc loadInfo:0];
        [vc loadGoodInfo];
        [vc loadFansInfo];
        [vc loadSubscriInfo];
       //[vc.bgScrollView headerEndRefreshing];
    }];
    [self.bgScrollView headerBeginRefreshing];
}
-(void)setApplyTownGeoInfo:(responseApplyTown *)sender{
    _applyTown = sender;
};
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.bgScrollView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadInfo:1];
        
    }];
}

#pragma loading Infomation
-(void)loadInfo:(int)check{
    if(check==0){
        _requestStory.position =0;
    }
    NSDictionary *parameters = [_requestStory toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getStoryUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Near Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log(@"%@",responseObject);
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check==0){
            _responseStroys = [[ResponseStory alloc] initWithDictionary:data error:nil];
            [self.bgScrollView headerEndRefreshing];
            _requestStory.position =(int) [_responseStroys.putao count];
        }else {
            ResponseStory *ad=[[ResponseStory alloc] initWithDictionary:data error:nil];
            [_responseStroys.putao addObjectsFromArray:ad.putao];
            _responseStroys.stat = ad.stat;
            _responseStroys.errcode = ad.errcode;
        _requestStory.position =(int) [_responseStroys.putao count];
            [self.bgScrollView footerEndRefreshing];
        }
        if(_requestStory.position>0){
             self.bgScrollView.contentSize= _origin;
            self.storyTableView.hidden = NO;
        self.storyTableView.frame = CGRectMake(0,self.bgScrollView.contentSize.height-50,self.bgScrollView.frame.size.width, _requestStory.position*90);
            self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.frame.size.width, self.bgScrollView.contentSize.height+_requestStory.position*90);
                    [self.storyTableView reloadData];
            if(check ==1){
                _bgScrollView.contentOffset = CGPointMake(0, self.bgScrollView.contentSize.height);
            }
        }else {
            self.bgScrollView.contentSize= _origin;
            if(check ==0)
        [self.bgScrollView setNeedsDisplay];
            self.storyTableView.hidden = YES;
        }
        if(_requestStory.position==0||_requestStory.position%10 != 0){
            _bgScrollView.footerHidden = YES;
            }else{
            _bgScrollView.footerHidden = NO;
        }
       
        log(@"story stat is %d,errcode is %d",_responseStroys.stat,_responseStroys.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check ==0){
            [self.bgScrollView headerEndRefreshing];
        }else {
            [self.bgScrollView footerEndRefreshing];
        }
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        
        case 0:
        NSLog(@"count is %lu",(unsigned long)[_responseStroys.putao count]);
        return  [_responseStroys.putao count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
        break;
                default:
        return 0;
        break;
        
    }
    
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryTableViewCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        
        case 0://对应各自的分区
        
        [cell.stroyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[[_responseStroys.putao objectAtIndex:indexPath.row]  cover],@"!small"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
        cell.storyLabel.text = [[_responseStroys.putao objectAtIndex:indexPath.row] title];
        cell.dateLabel.text = [[_responseStroys.putao objectAtIndex:indexPath.row] createtime];
        cell.goodLabel.text =[NSString stringWithFormat:@"%@", [[_responseStroys.putao objectAtIndex:indexPath.row] goods]];
        cell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
        //给cell添加数据
        break;
        default:
        [[cell textLabel]  setText:@"Unknown"];
        
    }
    // Configure the cell...
   
    return cell;
}

-(void)loadGoodInfo{
   
    NSDictionary *parameters = [_requestGood toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getGoodsUrl];
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
            _responseGood = [[ResponseGood alloc] initWithDictionary:data error:nil];
       // [self.bgScrollView headerEndRefreshing];
        [self.bgScrollView setNeedsDisplay];
         _goodslabel.text = [NSString stringWithFormat:@"%@",_responseGood.good.goods];
        log(@"loadGoodInfo stat is %d,errcode is %d",_responseGood.stat,_responseGood.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[self.bgScrollView headerEndRefreshing];
    }];
}

-(void)loadFansInfo{
    
    NSDictionary *parameters = [_requestFans toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getFansUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadFansInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseFans = [[ResponseUser alloc] initWithDictionary:data error:nil];
       // [self.bgScrollView headerEndRefreshing];
        [self.bgScrollView setNeedsDisplay];
         _fansLabel.text =  [[NSString alloc] initWithFormat:@"粉丝 %@",_responseFans.user.fans];
        log(@"loadFansInfo stat is %d,errcode is %@",_responseFans.stat,_responseFans.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       // [self.bgScrollView headerEndRefreshing];
    }];
}

-(void)loadSubscriInfo{
    
    NSDictionary *parameters = [_requestSubscriTown toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getSubscriUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadSubscriInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseSubscriTown = [[ResponseSubscriTown alloc] initWithDictionary:data error:nil];
       // [self.bgScrollView headerEndRefreshing];
        [self.bgScrollView setNeedsDisplay];
        if(_responseSubscriTown.subscri.dosubscri){
            _subscri.text =@"取消订阅";
        }else {
            _subscri.text =@"订阅";
        }

        log(@"loadSubscriInfo stat is %d,errcode is %d",_responseSubscriTown.stat,_responseSubscriTown.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       // [self.bgScrollView headerEndRefreshing];
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
