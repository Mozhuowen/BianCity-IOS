//
//  MyViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "UserViewController.h"
#import "UserCollectionReusableView.h"
@interface UserViewController ()
@property (strong, nonatomic)  UICollectionView *myCollectionView;

@end

@implementation UserViewController
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if(_requestUser.ptuserid == _userid){
        self.navigationItem.title = @"我的";
    }else{
        self.navigationItem.title =[NSString stringWithFormat:@"%@",_UserName];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:fl];
    _myCollectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _myCollectionView.dataSource =self;
    _myCollectionView.delegate = self;
    _applyTown = [[responseApplyTown alloc] init];
    _show  = [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    _town=[[townViewController alloc] initWithNibName:@"townViewController" bundle:nil];
    
    [_show pushViewController:_town animated:YES ];
    self.myCollectionView.frame =[UIScreen mainScreen].bounds;
    
 
    [self.myCollectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionReusableView"];
    
      [self.myCollectionView registerClass:[UserCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserCollectionReusableView"];
     
    [self.myCollectionView registerClass:[HotTownCollectionViewCell class] forCellWithReuseIdentifier:@"HotTownCollectionViewCell"];
    self.myCollectionView.dataSource =self;
    self.myCollectionView.delegate = self;
    self.myCollectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.myCollectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(self.myCollectionView.frame.size.width, self.myCollectionView.frame.size.width*9/16+self.myCollectionView.frame.size.width/7);
    self.myCollectionView.collectionViewLayout = collectionViewLayout;
    _requestUser = [[ModelUser alloc] init];
    _requestUser.onlystatis = NO;
    _requestUser.userid = _requestUser.ptuserid;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    [self addHeader];
    NSLog(@"width is %f,Height is %f",self.myCollectionView.frame.size.width,self.myCollectionView.frame.size.width);
    _myCollectionView.userInteractionEnabled = YES;
                         [  self.view addSubview:_myCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma CollectionView begin
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
    return [self.User.user.mytowns count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotTownCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotTownCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius =5;
    NSString * imageUrl = [[self.User.user.mytowns objectAtIndex:indexPath.row] cover];
    NSMutableString *pictureUrl = [[NSMutableString alloc] initWithString:getPictureUrl];
    [pictureUrl appendString:imageUrl];
    [pictureUrl appendString:@"!small"];
    [cell.HotTownCoverImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
    
    [cell.hotTownNameLabel setText:[[self.User.user.mytowns objectAtIndex:indexPath.row] townname]];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:[[self.User.user.mytowns objectAtIndex:indexPath.row] geoinfo].city];
    [addr appendString:[[self.User.user.mytowns objectAtIndex:indexPath.row] geoinfo].freeaddr];
    [cell.addrLabel setText:addr];
    [cell.goodLabel setText:[NSString stringWithFormat:@"%@", [[self.User.user.mytowns objectAtIndex:indexPath.row] good]]];
    cell.icon1Image.image = [UIImage imageNamed:@"ic_location_small_light"];
    cell.icon2Image.image = [UIImage imageNamed:@"ic_list_thumb_small"];
    cell.userInteractionEnabled =YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _applyTown = [_User.user.mytowns objectAtIndex:indexPath.row];
    _town.applyTown = _applyTown;
    [self presentViewController:_show animated:YES completion:^{}];
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
       
        if(_requestUser.ptuserid == _requestUser.userid){
             MyCollectionReusableView *header;
            header =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionReusableView" forIndexPath:indexPath];
            NSMutableString *pictureUrl = [[NSMutableString alloc] initWithString:getPictureUrl];
            if(!_User.user.wallimage)
                header.myCoverImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
            else{
                NSMutableString *bgImgUrl =[[NSMutableString alloc]initWithString: pictureUrl];
                [bgImgUrl appendString:_User.user.wallimage];
                [bgImgUrl appendString:@"!large"];
                [header.myCoverImage sd_setImageWithURL:[NSURL URLWithString:bgImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
            }
            NSString *myImgUrl = _User.user.cover;
            NSString *jap = @"http://";
            NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(_User.user.cover){
                if(foundObj.length>0) {
                    [header.iconMyImage sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }else {
                    NSMutableString * temp = [[NSMutableString alloc] initWithString:pictureUrl];
                    [temp appendString:_User.user.cover];
                    [temp appendString:@"!small"];
                    [header.iconMyImage sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }
            }else {
                header.iconMyImage.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
            }
            header.iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
            //[header.iconAddImage setTag:333];
            
            
            
            header.iconAddrImage.image = [UIImage imageNamed:@"ic_location_small"] ;
            
            header.iconSettingImage.image = [UIImage imageNamed:@"ic_account_setting"];
            
            // header.userInteractionEnabled = YES;
            header.iconMyImage.layer.masksToBounds=YES;
            header.iconMyImage.layer.cornerRadius=25.0;
            header.iconMyImage.layer.borderWidth=2.0;
            header.iconMyImage.layer.borderColor =[[UIColor whiteColor] CGColor];
            header.iconMyImage.backgroundColor = [UIColor whiteColor];
            header.iconLineImage.backgroundColor = [UIColor whiteColor];
            // NSString * str =nil;
            header.myNameLabel.text = _User.user.name;
            // NSLog(@"%@",_User.user.sex);
            if(_User.user.sex && [_User.user.sex isEqualToString:@"m"]){
                header.maleLabel.text =@"男";
                header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_boy"];
            }else {
                header.maleLabel.text =@"女";
                header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_girl"];
            }
            //str =[NSString stringWithString:_User.user.location];
            header.addrLabel.text = _User.user.location;
            header.myTownsLabel.text = [NSString stringWithFormat:@"%@",_User.user.towncount];
            header.myTownLabel.text = @"边城";
            
            header.myStorysLabel.text = [NSString stringWithFormat:@"%@",_User.user.putaocount];
            header.myStoryLabel.text = @"故事";
            
            header.fansLabel.text = [NSString stringWithFormat:@"%@",_User.user.fans];
            header.fanLabel.text = @"粉丝";
            
            header.checksLabel.text = [NSString stringWithFormat:@"%@",_User.user.subscricount];
            header.checkLabel.text = @"订阅";
            
            header.storesLabel.text = [NSString stringWithFormat:@"%@",_User.user.favoritecount];
            header.storeLabel.text = @"收藏";
            
            header.goodsLabel.text =[NSString stringWithFormat:@"%@",_User.user.begoodcount];
            header.goodLabel.text = @"被赞";
            header.t_delegate = self;
            return header;
        }else{
            UserCollectionReusableView *header;
             header =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UserCollectionReusableView" forIndexPath:indexPath];
            NSMutableString *pictureUrl = [[NSMutableString alloc] initWithString:getPictureUrl];
            if(!_User.user.wallimage)
                header.myCoverImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
            else{
                NSMutableString *bgImgUrl =[[NSMutableString alloc]initWithString: pictureUrl];
                [bgImgUrl appendString:_User.user.wallimage];
                [bgImgUrl appendString:@"!large"];
                [header.myCoverImage sd_setImageWithURL:[NSURL URLWithString:bgImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
            }
            NSString *myImgUrl = _User.user.cover;
            NSString *jap = @"http://";
            NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(_User.user.cover){
                if(foundObj.length>0) {
                    [header.iconMyImage sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }else {
                    NSMutableString * temp = [[NSMutableString alloc] initWithString:pictureUrl];
                    [temp appendString:_User.user.cover];
                    [temp appendString:@"!small"];
                    [header.iconMyImage sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }
            }else {
                header.iconMyImage.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
            }
//            header.iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
//            //[header.iconAddImage setTag:333];
//            
            
            
            header.iconAddrImage.image = [UIImage imageNamed:@"ic_location_small"] ;
//            
//            header.iconSettingImage.image = [UIImage imageNamed:@"ic_account_setting"];
            
            // header.userInteractionEnabled = YES;
            header.iconMyImage.layer.masksToBounds=YES;
            header.iconMyImage.layer.cornerRadius=25.0;
            header.iconMyImage.layer.borderWidth=2.0;
            header.iconMyImage.layer.borderColor =[[UIColor whiteColor] CGColor];
            header.iconMyImage.backgroundColor = [UIColor whiteColor];
            header.iconLineImage.backgroundColor = [UIColor whiteColor];
            // NSString * str =nil;
            header.myNameLabel.text = _User.user.name;
            // NSLog(@"%@",_User.user.sex);
            if(_User.user.sex && [_User.user.sex isEqualToString:@"m"]){
                header.maleLabel.text =@"男";
                header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_boy"];
            }else {
                header.maleLabel.text =@"女";
                header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_girl"];
            }
            //str =[NSString stringWithString:_User.user.location];
            header.addrLabel.text = _User.user.location;
            header.myTownsLabel.text = [NSString stringWithFormat:@"%@",_User.user.towncount];
            header.myTownLabel.text = @"边城";
            
            header.myStorysLabel.text = [NSString stringWithFormat:@"%@",_User.user.putaocount];
            header.myStoryLabel.text = @"故事";
            
            header.fansLabel.text = [NSString stringWithFormat:@"%@",_User.user.fans];
            header.fanLabel.text = @"粉丝";
            
            header.checksLabel.text = [NSString stringWithFormat:@"%@",_User.user.subscricount];
            header.checkLabel.text = @"订阅";
            
            header.storesLabel.text = [NSString stringWithFormat:@"%@",_User.user.favoritecount];
            header.storeLabel.text = @"收藏";
            
            header.goodsLabel.text =[NSString stringWithFormat:@"%@",_User.user.begoodcount];
            header.goodLabel.text = @"被赞";
            header.t_delegate = self;
            return header;
        }
      
    }
    return nil;
}

#pragma CollectionView End

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.myCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc loadInfo:0];
    }];
    [self.myCollectionView headerBeginRefreshing];
}
#pragma loading Infomation
-(void)loadInfo:(int)check{
    _requestUser.userid = _userid;
    NSDictionary *parameters=[_requestUser toDictionary];
    NSString *url =[NSString stringWithString:getUserInfoUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"User Info is %@",info);
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
            self.User = [[ResponseUser alloc] initWithDictionary:data error:nil];
            [self.myCollectionView headerEndRefreshing];
            [self.myCollectionView reloadData];
            // NSLog(@"USer is %@",_User);
        }else {
            ResponseUser *ad=[[ResponseUser alloc] initWithDictionary:data error:nil];
            _User.stat = ad.stat;
            _User.errcode = ad.errcode;
            [self.User.user.mytowns addObjectsFromArray:ad.user.mytowns];
            [self.myCollectionView footerEndRefreshing];
        }
        log(@"User stat is %d,errcode is %@",_User.stat,_User.errcode);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check ==0){
            [self.myCollectionView headerEndRefreshing];
        }else {
            [self.myCollectionView footerEndRefreshing];
        }
        
    }];
}

#pragma end loading Infomation
#pragma functions
-(void)addTown{
    // NSLog(@"add");
    showNavigationController *show= [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    locationViewController *location =[[locationViewController alloc] initWithNibName:@"locationViewController" bundle:nil];
    [show pushViewController:location animated:YES ];
    [self presentViewController:show animated:YES completion:^{}];
}
- (void) tappedWithObject:(id)sender{
    [self addTown];
}
-(void)setting:(id)sender{
    NSLog(@"sett");
    showNavigationController *show= [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    settingTableViewController *setting =[[settingTableViewController alloc] initWithNibName:@"settingTableViewController" bundle:nil];
    [show pushViewController:setting animated:YES ];
    [self presentViewController:show animated:YES completion:^{}];
    
}
#pragma end functions
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
