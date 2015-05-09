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
@interface townViewController ()
@end

@implementation townViewController
-(void)viewWillAppear:(BOOL)animated{
    if([_applyTown.ptuserid isEqualToNumber:_applyTown.userid]){
    self.navigationItem.title = @"我的边城";
        self.navigationItem.rightBarButtonItem = _rightButton;
  
    }else {
        self.navigationItem.title = @"边城";
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.cover,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
    _goodslabel.text = [NSString stringWithFormat:@"%@",_applyTown.good];
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
     _fansLabel.text =  [[NSString alloc] initWithFormat:@"粉丝 0"];
     _subscri.text =@"订阅";
     _leaveMsgLabel.text = @"留言";
     _storyLabel.text =@"故事(0)";
    _townNameLabel.text = _applyTown.townname;
    _summaryLabel.text = [NSString stringWithFormat:@"简介: %@",_applyTown.descri];//@"描述";
        _userNameLabel.text = _applyTown.username;
    [_addrMapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_applyTown.geoinfo.screenpng,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
    
    _addrLabel.text = [NSString stringWithFormat:@"%@%@%@",_applyTown.geoinfo.province,_applyTown.geoinfo.city,_applyTown.geoinfo.freeaddr];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;

     _leftButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    
     _rightButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
    self.navigationItem.leftBarButtonItem = _leftButton;
    self.navigationItem.rightBarButtonItem = _rightButton;
        self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGSize size = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height+100) ;
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

    _storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,_leaveMsgLabel.frame.origin.y+80, 55, 35)];
    _storyLabel.textAlignment =NSTextAlignmentCenter;
    _storyLabel.backgroundColor = [UIColor blueColor];
    _iconAddImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width -50, _storyLabel.frame.origin.y-5, 45, 45)];
    _iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
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
    
    [self.view addSubview:_bgScrollView];
    [self addHeader];
    // Do any additional setup after loading the view from its nib.
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
       [vc.bgScrollView headerEndRefreshing];
    }];
    [self.bgScrollView headerBeginRefreshing];
}
-(void)setApplyTownGeoInfo:(responseApplyTown *)sender{
    _applyTown = sender;
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
