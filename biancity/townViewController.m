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
#import "storyViewController.h"
#import "UserViewController.h"
#import "messageViewController.h"
#import "mapViewController.h"
#import "ModelDelete.h"
#import "ResponseSimple.h"
#import "TownHeaderTableViewCell.h"
#import "ResponseRegiste.h"
#import "ResponseLogin.h"
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
@property (nonatomic,strong) ModelDelete *requestDelete;
@property (nonatomic,strong) ResponseSimple *responseDelete;
@property (nonatomic) BOOL isDoGooding;
@property (nonatomic) BOOL isDoSubscring;
@end

@implementation townViewController

-(void)viewWillAppear:(BOOL)animated{

       if(_applyTown.userid == nil||[_requestStory.ptuserid isEqualToNumber:_applyTown.userid]){
        self.navigationItem.rightBarButtonItem = _rightButton;
       }else {
       
        self.navigationItem.rightBarButtonItem= nil;
      }
        
    if(_notEditFlag){
    self.navigationItem.rightBarButtonItem= nil;
    }
}

-(void)tapUser{
    
    UserViewController * user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    user.userid = _applyTown.userid;
    user.UserCover = _applyTown.usercover;
    user.UserName = _applyTown.username;
    user.via = YES;
    [self.navigationController pushViewController:user animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.navigationItem.title = [NSString stringWithFormat:@"%@•边城",_applyTown.townname];
    _placeholderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
     _leftButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    _requestDelete =[[ModelDelete alloc] init];

     _rightButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
    _requestGood =[[ModelGood alloc] init];
  
    _requestStory = [[ModelStory alloc] init];
    _requestSubscriTown = [[ModelSubscriTown alloc] init];
    _requestFans = [[ModelUser alloc] init];
    
    self.navigationItem.leftBarButtonItem = _leftButton;
    self.navigationItem.rightBarButtonItem = _rightButton;
        self.view.frame = [UIScreen mainScreen].bounds;
   _storyTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _storyTableView.dataSource = self;
    _storyTableView.delegate = self;
    [_storyTableView registerClass:[StoryTableViewCell class] forCellReuseIdentifier:@"StoryTableViewCell"];
    [_storyTableView registerClass:[TownHeaderTableViewCell class] forCellReuseIdentifier:@"TownHeaderTableViewCell"];
     _storyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_storyTableView];
    [self addHeader];
     [self addFooter];
    [self loadInfo:2];
    [self loadGoodInfo:0];
    [self loadFansInfo];
    [self loadSubscriInfo:0];
    _isDoGooding =NO;
    _isDoSubscring =NO;

    // Do any additional setup after loading the view from its nib.
}
-(void)doGoodCommit{
    //_iconGoodImageView.userInteractionEnabled =NO;
    if(!_isDoGooding){
    if(_responseGood.good.dogood){
        _requestGood.action = [NSNumber numberWithInt:1];
        _requestGood.type = [NSNumber numberWithInt:0];
        _requestGood.targetid = _applyTown.townid;
    }else{
        _requestGood.action = [NSNumber numberWithInt:0];
        _requestGood.type = [NSNumber numberWithInt:0];
        _requestGood.targetid = _applyTown.townid;

    }
        _isDoGooding = YES;
        [self loadGoodInfo:1];
    }
}

-(void)commitSubscri{
    if(!_isDoSubscring){
    _requestSubscriTown.townid = _applyTown.townid;
    if(_responseSubscriTown.subscri.dosubscri){
        _requestSubscriTown.action = [NSNumber numberWithInt:1];
    }else{
        _requestSubscriTown.action = [NSNumber numberWithInt:0];
    }
        _isDoSubscring =YES;
        [self loadSubscriInfo:1];
    }
   // _subscri.userInteractionEnabled =NO;
}
-(void)showMap{
    mapViewController *map = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
    map.townLocal = [[CLLocation alloc] initWithLatitude:[_applyTown.geoinfo.latitude doubleValue] longitude:[_applyTown.geoinfo.longitude doubleValue]];
    map.townname = _applyTown.townname;
    [self.navigationController pushViewController:map animated:YES];
}
-(void)tapLeave{
    messageViewController *mess = [[messageViewController alloc] initWithNibName:@"messageViewController" bundle:nil];
    mess.townid = _applyTown.townid;
    CLLocation *local = [[CLLocation alloc] initWithLatitude:[_applyTown.geoinfo.latitude doubleValue] longitude:[_applyTown.geoinfo.longitude doubleValue]];
    mess.townLocal = local;
    mess.townname = _applyTown.townname;
    [self.navigationController pushViewController:mess animated:YES];
}
-(void)AddStory{
    
    addStoryViewController * add = [[addStoryViewController alloc] init];
    add.townid = _applyTown.townid;
    [self.navigationController pushViewController:add  animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    if(_isComeFromSubscri){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }
}
-(void)selectRightAction:(id)sender{
    _requestDelete.type = [NSNumber numberWithInt:0];
    _requestDelete.id = _applyTown.townid;
    //[self.navigationController pushViewController:nil  animated:NO];
    [self showSheetSource:sender];
}
- (void)showSheetSource:(id)sender {
    // NSLog(@"showSheet");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确认删除"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"确定",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 0) {
       [self deleteInfo];
    }else if (buttonIndex == 1) {
        //   [self showAlert:@"第一项"];
         return;
    }
}
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.storyTableView addHeaderWithCallback:^{

        [vc loadInfo:0];
        [vc loadGoodInfo:0];
        [vc loadFansInfo];
        [vc loadSubscriInfo:0];
   // [vc.storyTableView headerEndRefreshing];
    }];
   // [self.storyTableView headerBeginRefreshing];
}
-(void)setApplyTownGeoInfo:(responseApplyTown *)sender{
    _applyTown = sender;
};
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.storyTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadInfo:1];
        
    }];
}

#pragma loading Infomation
-(void)loadInfo:(int)check{
     _requestStory.townid = [_applyTown.townid intValue];
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
    log(@"Near Info is %@,%ld",info,(unsigned long)info.length);
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
            _responseStroys = [[ResponseStory alloc] initWithDictionary:data error:nil];
            [self.storyTableView headerEndRefreshing];
            _requestStory.position =(int) [_responseStroys.putao count];
        }else if(check ==1){
            ResponseStory *ad=[[ResponseStory alloc] initWithDictionary:data error:nil];
            [_responseStroys.putao addObjectsFromArray:ad.putao];
            _responseStroys.stat = ad.stat;
            _responseStroys.errcode = ad.errcode;
        _requestStory.position =(int) [_responseStroys.putao count];
            [self.storyTableView footerEndRefreshing];
        }else if(check ==2){
            _responseStroys = [[ResponseStory alloc] initWithDictionary:data error:nil];
            _requestStory.position =(int) [_responseStroys.putao count];
        }

      [self.storyTableView reloadData];
        
    if(_requestStory.position==0||_requestStory.position%10 != 0){
            _storyTableView.footerHidden = YES;
            }else{
            _storyTableView.footerHidden = NO;
        }
        log(@"story stat is %d,errcode is %d",_responseStroys.stat,_responseStroys.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check ==0){
            [self.storyTableView headerEndRefreshing];
        }else if(check ==1) {
            [self.storyTableView footerEndRefreshing];
        }
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        NSLog(@"count is %lu",(unsigned long)[_responseStroys.putao count]);
        return  [_responseStroys.putao count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
        break;
    }
    
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{        UILabel *la;
    switch (indexPath.section) {
        case 0:
            la = [[UILabel alloc] initWithFrame:CGRectMake(4, 0+5,[UIScreen mainScreen].bounds.size.width-10, 5)];
            la.text = [NSString stringWithFormat:@"简介: %@",_applyTown.descri];//@"描述";
            la.font = [UIFont systemFontOfSize:14];
            la.lineBreakMode = NSLineBreakByWordWrapping;
            la.numberOfLines = 0;
            [la sizeToFit];
            return [UIScreen mainScreen].bounds.size.width+290+la.frame.size.height+5;
            break;
        case 1:
            return 90;
            break;
    }
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    switch (indexPath.section) {
        case 0:
            return;
            break;
            
        case 1:
            NSLog(@"did select");
            storyViewController *story = [[storyViewController alloc] initWithNibName:@"storyViewController" bundle:nil];
            story.story = [_responseStroys.putao objectAtIndex:indexPath.row];
            story.notEditFlag =_notEditFlag;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:story  animated:YES];
            return;
            break;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    StoryTableViewCell *storyCell;
    TownHeaderTableViewCell *townCell;
    UITapGestureRecognizer* tapGood = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doGoodCommit)];
      UITapGestureRecognizer *tapUser=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser)];
     UITapGestureRecognizer* tapShowMap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMap)];
     UITapGestureRecognizer *tapSubscri = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitSubscri)];
     UITapGestureRecognizer *tapLe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeave)];
      UITapGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddStory)];
    UILabel *la;
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.cover,@"!small"]];
    NSString *myImgUrl = _applyTown.usercover;
    NSString *jap = @"http://";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    __weak UIImageView * bgimage;
    switch (indexPath.section) {
        case 0:
            townCell=[tableView dequeueReusableCellWithIdentifier:@"TownHeaderTableViewCell" forIndexPath:indexPath];
            [townCell.addrMapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.geoinfo.screenpng,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
            bgimage = townCell.bgImageView;
            if(url){
            [_placeholderImage sd_setImageWithURL:url
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                                          options:SDWebImageProgressiveDownload
                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                             //add some ting
                                         }
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            NSLog(@"loadbgImage complete");
                                            
                                            [bgimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.cover,@"!large"]]  placeholderImage:image options:0] ;
                                        }];
            
            }else{
            [townCell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.cover,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
            }
            la = [[UILabel alloc] initWithFrame:CGRectMake(4, townCell.townNameLabel.frame.origin.y+townCell.townNameLabel.frame.size.height+5,[UIScreen mainScreen].bounds.size.width-10, 5)];
                la.text = [NSString stringWithFormat:@"简介: %@",_applyTown.descri];//@"描述";
             la.font = [UIFont systemFontOfSize:14];
                la.lineBreakMode = NSLineBreakByWordWrapping;
                la.numberOfLines = 0;
                [la sizeToFit];
                CGRect rect = la.frame;
                rect.size.width =  rect.size.width > 300? rect.size.width:300;
                 townCell.summaryLabel.frame = rect;
                 townCell.summaryLabel.text = [NSString stringWithFormat:@"简介: %@",_applyTown.descri];//@"描述";
            [townCell changeFrame];
            [townCell.subscri addGestureRecognizer:tapSubscri];
            townCell.subscri.userInteractionEnabled =YES;
            townCell.addrMapImage.userInteractionEnabled =YES;
            [townCell.addrMapImage addGestureRecognizer:tapShowMap];
            townCell.userImageView.userInteractionEnabled = YES;
            [townCell.userImageView addGestureRecognizer:tapUser];
            townCell.iconGoodImageView.userInteractionEnabled = YES;
            [townCell.iconGoodImageView addGestureRecognizer:tapGood];
            townCell.leaveMsgLabel.userInteractionEnabled = YES;
            [townCell.leaveMsgLabel addGestureRecognizer:tapLe];
            townCell.leaveMsgLabel.text = @"留言";
            townCell.storyLabel.text =[NSString stringWithFormat:@"故事(%@)",(_applyTown.storycount==nil)?@"0":_applyTown.storycount];
            townCell.townNameLabel.text = _applyTown.townname;
            if(_responseGood.good.dogood){
                townCell.iconGoodImageView.image =[UIImage imageNamed:@"ic_list_thumbup"];
                }else{
            townCell.iconGoodImageView.image =[UIImage imageNamed:@"ic_list_thumb"];
                }
            if(_responseSubscriTown.subscri.dosubscri){
                    townCell.subscri.text =@"取消订阅";
               }else {
                    townCell.subscri.text =@"订阅";
              }
            
            la.frame = townCell.addrLabel.frame;
                la.text =  [NSString stringWithFormat:@"%@%@%@",_applyTown.geoinfo.province,_applyTown.geoinfo.city,_applyTown.geoinfo.freeaddr];
            la.font = [UIFont systemFontOfSize:14];
                [la sizeToFit];
                rect = la.frame;
               rect.size.height += 5;
                townCell.addrLabel.frame =rect;
                townCell.addrLabel.text = [NSString stringWithFormat:@"%@%@%@",_applyTown.geoinfo.province,_applyTown.geoinfo.city,_applyTown.geoinfo.freeaddr];
//            townCell.addrLabel.text = [NSString stringWithFormat:@"%@%@%@",_applyTown.geoinfo.province,_applyTown.geoinfo.city,_applyTown.geoinfo.freeaddr];
            if([_applyTown.userid isEqual:_requestStory.ptuserid]){
                townCell.iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
                townCell.iconAddImage.userInteractionEnabled =YES;
                [townCell.iconAddImage addGestureRecognizer:tapAdd];
            }else {
                townCell.iconAddImage.hidden = YES;
            }
            if(_notEditFlag){
            townCell.iconAddImage.hidden = YES;
            }
            townCell.userNameLabel.text = _applyTown.username;
            townCell.fansLabel.text =  [[NSString alloc] initWithFormat:@"粉丝 %@",(_responseFans.user.fans==nil)?@"0":_responseFans.user.fans];
           
                if(_applyTown.usercover){
                    if(foundObj.length>0) {
                        [townCell.userImageView  sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options: 0] ;
                    }else {
                        NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
                        [temp appendString:_applyTown.usercover];
                        [temp appendString:@"!small"];
                        [townCell.userImageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
                    }
                }else {
                    townCell.userImageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
                }
            townCell.townNameLabel.text = _applyTown.townname;
            townCell.goodslabel.text = [NSString stringWithFormat:@"%@",(_responseGood.good.goods==nil)?@"0":_responseGood.good.goods];
            townCell.iconAddrimage.image = [UIImage imageNamed:@"ic_location_small"];
       townCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell= townCell;
            break;
        case 1://对应各自的分区
            storyCell = [tableView dequeueReusableCellWithIdentifier:@"StoryTableViewCell" forIndexPath:indexPath];
        [storyCell.stroyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[[_responseStroys.putao objectAtIndex:indexPath.row]  cover],@"!small"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        storyCell.storyLabel.text = [[_responseStroys.putao objectAtIndex:indexPath.row] title];
            storyCell.storyLabel.lineBreakMode = NSLineBreakByWordWrapping;
            storyCell.storyLabel.numberOfLines = 0;
        storyCell.dateLabel.text = [[_responseStroys.putao objectAtIndex:indexPath.row] createtime];
        storyCell.goodLabel.text =[NSString stringWithFormat:@"%@", ([[_responseStroys.putao objectAtIndex:indexPath.row] goods]==nil)?@"0":[[_responseStroys.putao objectAtIndex:indexPath.row] goods]];
        storyCell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
            
        //给cell添加数据
            cell = storyCell;
        break;
    }

  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadGoodInfo:(NSInteger)check{
    _requestGood.targetid = _applyTown.townid;
    _requestGood.type = 0;
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
    log(@"loadGoodInfo Info is %@,%ld",info,(unsigned long)info.length);
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
          [_storyTableView reloadData];
        _isDoGooding =NO;
       
        log(@"loadGoodInfo stat is %d,errcode is %d",_responseGood.stat,_responseGood.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[self.bgScrollView headerEndRefreshing];
    }];
}

-(void)loadFansInfo{
    _requestFans.userid = _applyTown.userid;
    NSDictionary *parameters = [_requestFans toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getFansUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadFansInfo Info is %@,%ld",info,(unsigned long)info.length);
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
          [_storyTableView reloadData];
        log(@"loadFansInfo stat is %d,errcode is %@",_responseFans.stat,_responseFans.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       // [self.bgScrollView headerEndRefreshing];
    }];
}

-(void)loadSubscriInfo:(NSInteger)check{
    _requestSubscriTown.townid = _applyTown.townid;
    NSDictionary *parameters = [_requestSubscriTown toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    if(check ==0){
        url=[NSString stringWithString:getSubscriUrl];
    }else {
        url=[NSString stringWithString:doSubscriUrl];

    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadSubscriInfo Info is %@,%ld",info,(unsigned long)info.length);
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
        _isDoSubscring =NO;
        [_storyTableView reloadData];
        log(@"loadSubscriInfo stat is %d,errcode is %d",_responseSubscriTown.stat,_responseSubscriTown.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       // [self.bgScrollView headerEndRefreshing];
    }];
}


-(void)deleteInfo{
    _requestDelete.type = [NSNumber numberWithInt:0];
    _requestDelete.id = _applyTown.townid;
    NSDictionary *parameters = [_requestDelete toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:deleteUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Delete Info is %@,%ld",info,(unsigned long)info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseDelete = [[ResponseSimple alloc] initWithDictionary:data error:nil];
        [self deleteUserTown];
        log(@"responseDelete stat is %d,errcode is %d",_responseDelete.stat,_responseDelete.errcode);
        if(_responseDelete.stat){
            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // [self.bgScrollView headerEndRefreshing];
    }];
}

- (void)deleteUserTown{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    if([(NSNumber*)[cache objectForKey:@"needregiste"] boolValue]){
        cache = [userDefaults dictionaryForKey:REGISTE_INFO];
        ResponseRegiste *registe =[[ResponseRegiste alloc] initWithDictionary:cache error:nil];
        for(int i=0;i<[registe.mytowns count];i++){
            if([((ModelAppleTown*)[registe.mytowns objectAtIndex:i]).townid isEqual:_requestDelete.id])
                [registe.mytowns removeObjectAtIndex:i];
        }
        
        NSLog(@"registe is %@",registe);
        [userDefaults setObject:[registe toDictionary] forKey:REGISTE_INFO];
        [userDefaults synchronize];
        return;
    }
    cache = [userDefaults dictionaryForKey:LOGIN_INFO];
    ResponseLogin *login = [[ResponseLogin alloc] initWithDictionary:cache error:nil];
    for(int i=0;i<[login.mytowns count];i++){
        if([((ModelAppleTown*)[login.mytowns objectAtIndex:i]).townid isEqual:_requestDelete.id])
            [login.mytowns removeObjectAtIndex:i];
    }
    NSLog(@"login is %@",login);
    [userDefaults setObject:[login toDictionary] forKey:LOGIN_INFO];
    [userDefaults synchronize];
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
