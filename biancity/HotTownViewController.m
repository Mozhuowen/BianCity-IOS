//
//  ViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "HotTownViewController.h"
#import "Cells/HotTownCollectionViewCell.h"
#import "model/ResponseHotTown.h"
#import "Refresh.h"
#import "MsgEncrypt.h"
#import "ModelHotTown.h"
#import "responseApplyTown.h"
#import "AFHTTPRequestOperationManager.h"
#import "townViewController.h"
#import "showNavigationController.h"
@interface HotTownViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *HotTownCollectionView;
@property (nonatomic,strong) ResponseHotTown * hotTown;
@property (nonatomic,strong)  ModelHotTown *basic;
@property (nonatomic,strong) responseApplyTown *applyTown;
@property (nonatomic,strong)  showNavigationController *show;
@property (nonatomic,strong) townViewController *town;
@end

@implementation HotTownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _applyTown = [[responseApplyTown alloc] init];
    _show  = [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    _town=[[townViewController alloc] initWithNibName:@"townViewController" bundle:nil];
    
    [_show pushViewController:_town animated:YES ];
   _basic= [[ModelHotTown alloc] init];

    _basic.rejectid = [[NSMutableArray alloc]init];
    [self.HotTownCollectionView registerClass:[HotTownCollectionViewCell class] forCellWithReuseIdentifier:@"HotTownCollectionViewCell"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.HotTownCollectionView.dataSource =self;
    self.HotTownCollectionView.delegate = self;
 
    [self addHeader];
    [self addFooter];

    
    // Do any additional setup after loading the view, typically from a nib.
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
    //[_show pushViewController:_town animated:YES ];
    [self presentViewController:_show animated:YES completion:^{}];
    //self.view.window.rootViewController = _show;
}
#pragma Collectionview end

#pragma header and footer
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.HotTownCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
     [vc loadInfo:0];
    }];
    [self.HotTownCollectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.HotTownCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadInfo:1];
        
    }];
}
#pragma header and footer end

#pragma loading Infomation
-(void)loadInfo:(int)check{
    if(check==0){
        [_basic.rejectid removeAllObjects];
    }
    NSDictionary *parameters = [_basic toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:getHotTownUrl];
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
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check==0){
            self.hotTown = [[ResponseHotTown alloc] initWithDictionary:data error:nil];
            [self.HotTownCollectionView headerEndRefreshing];
            for(int i=0;i<[self.hotTown.towns count];i++){
                NSNumber* rjid= [[self.hotTown.towns objectAtIndex:i] townid];
                [_basic.rejectid  addObject:rjid];
            }
        }else {
            ResponseHotTown *ad=[[ResponseHotTown alloc] initWithDictionary:data error:nil];
            [self.hotTown.towns addObjectsFromArray:ad.towns];
            _hotTown.stat = ad.stat;
            _hotTown.errcode = ad.errcode;
            for(int i=0;i<[ad.towns count];i++){
                NSNumber* rjid= [[ad.towns objectAtIndex:i] townid];
                [_basic.rejectid addObject:rjid];
            }
            [self.HotTownCollectionView footerEndRefreshing];
        }
        [self.HotTownCollectionView reloadData];
        log(@"HotTown stat is %d,errcode is %d",_hotTown.stat,_hotTown.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check ==0){
            [self.HotTownCollectionView headerEndRefreshing];
        }else {
            [self.HotTownCollectionView footerEndRefreshing];
        }
        
    }];
}

#pragma end loading Infomation


@end
