//
//  MyViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "MyViewController.h"
#import "subscriViewController.h"
#import "favoriteListViewController.h"
#import "UMUUploaderManager.h"
#import "NLViewController.h"
#import "ModelCWall.h"
#import "ResponseSimple.h"
#import "ApplyTown.h"
#import "ResponseRegiste.h"
#import "ResponseLogin.h"
@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) UIImage* wallImage;
@property (nonatomic,strong) NSString *wallImageName;
@property (nonatomic,strong) SDDemoItemView *progress;
@property (nonatomic,strong) ModelCWall *requestCWall;
@property (nonatomic,strong) ResponseSimple *responseWall;
@property (nonatomic,strong) NSMutableArray * myTowns;
@property (nonatomic,strong) UILabel *msgPlaceholdLabel;
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated{
   // [self loadInfo:2];
    [self readUserDeafultsOwn];
    _User.user.mytowns = _myTowns;
    [self.myCollectionView reloadData];
    if([_User.user.mytowns count]==0){
          _msgPlaceholdLabel.hidden = NO;
    }
    if([_User.user.mytowns count]<3){
        [self loadInfo:0];
    }
    log(@"我的 appear");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _applyTown = [[responseApplyTown alloc] init];
    _show  = [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    _requestCWall =[[ModelCWall alloc] init];

    
    self.myCollectionView.frame = self.view.frame;//[UIScreen mainScreen].bounds;
    [self.myCollectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionReusableView"];
       [self.myCollectionView registerClass:[HotTownCollectionViewCell class] forCellWithReuseIdentifier:@"HotTownCollectionViewCell"];
    self.myCollectionView.dataSource =self;
    self.myCollectionView.delegate = self;
    self.myCollectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.myCollectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(self.myCollectionView.frame.size.width, self.myCollectionView.frame.size.width*3/5+self.myCollectionView.frame.size.width/7);
    self.myCollectionView.collectionViewLayout = collectionViewLayout;
    _requestUser = [[ModelUser alloc] init];
    _requestUser.userid = _requestUser.ptuserid;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    [self addHeader];
   log(@"width is %f,Height is %f",self.myCollectionView.frame.size.width,self.myCollectionView.frame.size.width);
    _myCollectionView.userInteractionEnabled = YES;
    [self readUserDeafultsOwn];
    [self loadInfo:0];
     CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- [UIScreen mainScreen].bounds.size.width);
    _msgPlaceholdLabel =[[UILabel alloc] initWithFrame:rect];
    _msgPlaceholdLabel.textAlignment = NSTextAlignmentCenter;
    _msgPlaceholdLabel.text = @"还没有边城，赶快创建吧";
    _msgPlaceholdLabel.textColor = [UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0];
    [self.view addSubview:_msgPlaceholdLabel];
    _msgPlaceholdLabel.hidden = YES;
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
  townViewController*  _town=[[townViewController alloc] initWithNibName:@"townViewController" bundle:nil];
    [_show pushViewController:_town animated:YES ];
    _applyTown = [_User.user.mytowns objectAtIndex:indexPath.row];
    _town.applyTown = _applyTown;
    [self presentViewController:_show animated:YES completion:^{}];
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
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
        UITapGestureRecognizer *tapwall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
        header.myCoverImage.userInteractionEnabled = YES;
        [header.myCoverImage addGestureRecognizer:tapwall];
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
       // log(@"%@",_User.user.sex);
        if(_User.user.sex && [_User.user.sex isEqualToString:@"m"]){
            header.maleLabel.text =@"男";
            header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_boy"];
        }else {
            header.maleLabel.text =@"女";
            header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_girl"];
        }
        //str =[NSString stringWithString:_User.user.location];
            header.addrLabel.text = _User.user.location;
        header.myTownsLabel.text = [NSString stringWithFormat:@"%@",(_User.user.towncount==nil)?@"0":_User.user.towncount];
        header.myTownLabel.text = @"边城";
        
        header.myStorysLabel.text = [NSString stringWithFormat:@"%@",(_User.user.putaocount==nil)?@"0":_User.user.putaocount];
        header.myStoryLabel.text = @"故事";
        
        header.fansLabel.text = [NSString stringWithFormat:@"%@",(_User.user.fans==nil)?@"0":_User.user.fans];
        header.fanLabel.text = @"粉丝";
        
        header.checksLabel.text = [NSString stringWithFormat:@"%@",(_User.user.subscricount==nil)?@"0":_User.user.subscricount];
        header.checkLabel.text = @"订阅";
        UITapGestureRecognizer *subi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subList)];
        [header.checkView addGestureRecognizer:subi];
        header.checkView.userInteractionEnabled = YES;
        header.storesLabel.text = [NSString stringWithFormat:@"%@",(_User.user.favoritecount==nil)?@"0":_User.user.favoritecount];
        header.storeLabel.text = @"收藏";
        UITapGestureRecognizer *tapfav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyList)];
        header.storeView.userInteractionEnabled =YES;
        [header.storeView addGestureRecognizer:tapfav];
        header.goodsLabel.text =[NSString stringWithFormat:@"%@",(_User.user.begoodcount==nil)?@"0":_User.user.begoodcount];
        header.goodLabel.text = @"被赞";
        header.t_delegate = self;
        return header;
    }
    return nil;
}

-(void)storyList{
    
    showNavigationController *showSubscri =[[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    favoriteListViewController *favlist = [[favoriteListViewController alloc] initWithNibName:@"favoriteListViewController" bundle:nil];
    
      [showSubscri pushViewController:favlist animated:YES];
    [self presentViewController:showSubscri animated:YES completion:^{}];
}
-(void)subList{
    showNavigationController *showSubscri =[[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    subscriViewController *subscri = [[subscriViewController alloc] initWithNibName:@"subscriViewController" bundle:nil];
    [showSubscri pushViewController:subscri animated:YES];
   [self presentViewController:showSubscri animated:YES completion:^{}];

}
#pragma CollectionView End

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.myCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
       [vc loadInfo:1];
    }];
    //[self.myCollectionView headerBeginRefreshing];
}
#pragma loading Infomation
-(void)loadInfo:(int)check{
    if(check==0){
          _requestUser.onlystatis = YES;
    }else{
      _requestUser.onlystatis = NO;
    }
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
            if(!_User.stat){
                PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 40)];               [self.view addSubview:pop];
                int idx =  [(NSNumber*)[data objectForKey:@"errcode"] intValue];
                [pop setText:[ErrCode errcode:idx]];
             
            }

            _User.user.mytowns = _myTowns;
           // [self.myCollectionView headerEndRefreshing];
          [self.myCollectionView reloadData];
          // log(@"USer is %@",_User);
        }
        if (check ==1) {
              self.User = [[ResponseUser alloc] initWithDictionary:data error:nil];
            if(!_User.stat){
                PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 40)];               [self.view addSubview:pop];
                int idx =  [(NSNumber*)[data objectForKey:@"errcode"] intValue];
                [pop setText:[ErrCode errcode:idx]];
                
            }

            [self refreshUserDeafultsOwn ];
            [self.myCollectionView headerEndRefreshing];
            [self.myCollectionView reloadData];

        }
        log(@"User stat is %d,errcode is %@,%@",_User.stat,_User.errcode,_User);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log(@"Error: %@", error);
        if(check ==0){
            //[self.myCollectionView headerEndRefreshing];
        }else{
            [self.myCollectionView headerEndRefreshing];

            //[self.myCollectionView footerEndRefreshing];
        }
        
    }];
}

#pragma end loading Infomation
#pragma functions
-(void)addTown{
   // log(@"add");
    showNavigationController *show= [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    locationViewController *location =[[locationViewController alloc] initWithNibName:@"locationViewController" bundle:nil];
       [show pushViewController:location animated:YES ];
        [self presentViewController:show animated:YES completion:^{}];
}
- (void) tappedWithObject:(id)sender{
 [self addTown];
}
-(void)setting:(id)sender{
    log(@"sett");
    showNavigationController *show= [[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    settingTableViewController *setting =[[settingTableViewController alloc] initWithNibName:@"settingTableViewController" bundle:nil];
   // setting.user = _requestUser;//_User.user;
    [show pushViewController:setting animated:YES ];
    [self presentViewController:show animated:YES completion:^{}];

}

- (void)showSheetSource:(UITapGestureRecognizer* )sender {
    // log(@"showSheet");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择照片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册中选择", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1) {
        //   [self showAlert:@"第一项"];
        sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType])
        {
            [self showAlert:@"相机不可用，使用相册"];
            return;
            // sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }else if(buttonIndex == 2) {
        
        //  [self showAlert:@"第二项"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    // imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    
}

-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"警告"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
        NLViewController *pic = [[NLViewController alloc] initWithNibName:@"NLViewController" bundle:nil];
        pic.bgImage = image;
        pic.Nl_delegate =self;
    pic.isComeFormMy =YES;
    showNavigationController *show =[[showNavigationController alloc] initWithNibName:@"showNavigationController" bundle:nil];
    [show pushViewController:pic  animated:NO];
    [self presentViewController:show animated:NO completion:^{}];


}
-(void)changeiamge:(UIImage*)image{
    _wallImage = image;
    _wallImageName = [self createFileName];
    _requestCWall.wallimage = _wallImageName;
    [self uploadFiles];
};
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSString*)createFileName{
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    return fileName;
}
#pragma end functions


- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
#pragma warning 您需要加上自己的bucket和secret
    NSString * bucket = @"xiaocheng";
    NSString * secret = @"8giBNZVp2lo8f9c7gf6Q8Wk8BQw=";
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
        [mutableDic setObject:[NSString stringWithString:_wallImageName] forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}

- (void)uploadFiles
{
    
        _progress= [SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
        _progress.frame = [UIScreen mainScreen].bounds;//CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-100, 200, 200);
        [self.view addSubview:_progress];
    NSData * fileData;
        fileData=UIImagePNGRepresentation(_wallImage);
  
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:fileData];//获取文件信息
    
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    __weak typeof(self)weakSelf = self;
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:fileData policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        log(@"%f",percent);
        
        weakSelf.progress.progressView.progress =percent;        log(@"progress is %f", weakSelf.progress.progressView.progress);
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        UIAlertView * alert;
        //self.propressView.alpha = 0;
        if (completed) {
           
//        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                log(@"%@",result);
        [self loadWallInfo];
            [_progress removeFromSuperview];
        }else {
            alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传背景失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            log(@"%@",error);
            [alert show];
        }
        
        
    }];
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}


#pragma loading Infomation
-(void)loadWallInfo{
    NSDictionary *parameters = [_requestCWall toDictionary];
    //log(@"%@",parameters);
    NSString *url =[NSString stringWithString:getCwallUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"create story Info is %@,%ld",info,(unsigned long)info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        self.responseWall = [[ResponseSimple alloc] initWithDictionary:data error:nil];
        
        log(@"creatStroy stat is %d,errcode is %d",_responseWall.stat,_responseWall.errcode);
        if(_responseWall.stat ==1){
            [self loadInfo:0];
        }else{
            
                PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 40)];               [self.view addSubview:pop];
                int idx =  [(NSNumber*)[data objectForKey:@"errcode"] intValue];
                [pop setText:[ErrCode errcode:idx]];
                

        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log(@"Error: %@", error);
        [self showAlert:@"更换背景失败"];
    }];
}

- (void) readUserDeafultsOwn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
        cache = [userDefaults dictionaryForKey:LOGIN_INFO];
    if([(NSNumber*)[cache objectForKey:@"needregiste"] boolValue]){
     cache = [userDefaults dictionaryForKey:REGISTE_INFO];
        ResponseRegiste *registe =[[ResponseRegiste alloc] initWithDictionary:cache error:nil];
        _myTowns = registe.mytowns;
        return;
    }
    ResponseLogin *login=[[ResponseLogin alloc] initWithDictionary:cache error:nil];
    _myTowns = login.mytowns;
}
- (void) refreshUserDeafultsOwn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    if([(NSNumber*)[cache objectForKey:@"needregiste"] boolValue]){
        cache = [userDefaults dictionaryForKey:REGISTE_INFO];
        ResponseRegiste *registe =[[ResponseRegiste alloc] initWithDictionary:cache error:nil];
      registe.mytowns = _User.user.mytowns;
        [userDefaults setObject:[registe toDictionary] forKey:REGISTE_INFO];
        [userDefaults synchronize];
        return;
    }
    cache = [userDefaults dictionaryForKey:LOGIN_INFO];
    ResponseLogin *login=[[ResponseLogin alloc] initWithDictionary:cache error:nil];
    login.mytowns = _User.user.mytowns;
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
