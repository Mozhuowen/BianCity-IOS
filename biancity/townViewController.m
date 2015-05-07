//
//  townViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/7.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "townViewController.h"
#import "Refresh.h"
@interface townViewController ()
@property (nonatomic,strong) UIScrollView * bgScrollView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *townNameLabel;
@property (nonatomic,strong) UIImageView *iconGoodImageView;
@property (nonatomic,strong) UILabel *goodslabel;
@property (nonatomic,strong) UILabel *summaryLabel;
@property (nonatomic,strong) UIImageView *userImageView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *fansLabel;
@property (nonatomic,strong) UIImageView *iconAddrimage;
@property (nonatomic,strong) UILabel* addrLabel;
@property (nonatomic,strong) UIImageView *addrMapImage;
@property (nonatomic,strong) UILabel *subscri;
@property (nonatomic,strong) UILabel *leaveMsgLabel;
@property (nonatomic,strong) UILabel *storyLabel;
@property (nonatomic,strong) UIImageView *iconAddImage;
@end

@implementation townViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的边城";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGSize size = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height+100) ;
    _bgScrollView.contentSize = size;
   _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bgScrollView.frame.size.width, _bgScrollView.frame.size.width)];
    _bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    _townNameLabel =[[UILabel alloc ] initWithFrame:CGRectMake(4, _bgImageView.frame.origin.y+_bgImageView.frame.size.height+5, 150, 20)];
    _townNameLabel.text = @"边城名";
    _goodslabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-70, _townNameLabel.frame.origin.y, 40, 20)];
    _goodslabel.textAlignment = NSTextAlignmentRight;
    _goodslabel.text = @"0";
    _iconGoodImageView =[[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-25, _townNameLabel.frame.origin.y, 20, 20)];
    _iconGoodImageView.image =[UIImage imageNamed:@"ic_list_thumb"];
    _summaryLabel =[[UILabel alloc] initWithFrame:CGRectMake(4, _townNameLabel.frame.origin.y+_townNameLabel.frame.size.height+5, _bgImageView.frame.size.width-10, 10)];
    _summaryLabel.text = @"描述";
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _summaryLabel.frame.origin.y+30, 50, 50)];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 25;
    _userImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.height+4, _userImageView.frame.origin.y, 60, 20)];
    _userNameLabel.text = @"用户名";
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.size.height+_userNameLabel.frame.origin.y+5, 80, 12)];
    _fansLabel.text = @"粉丝 0";
    _iconAddrimage = [[UIImageView alloc] initWithFrame:CGRectMake(_userImageView.frame.origin.x, _userImageView.frame.origin.y+_userImageView.frame.size.height+15, 20, 20)];
    _iconAddrimage.image = [UIImage imageNamed:@"ic_location_small"];
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake( _iconAddrimage.frame.origin.x+_iconAddrimage.frame.size.width+2, _iconAddrimage.frame.origin.y, 200, 12)];
    _addrLabel.text = @"地址";
    _subscri = [[UILabel alloc ] initWithFrame:CGRectMake(5, _iconAddrimage.frame.origin.y+50, 60, 40)];
    _subscri.text =@"订阅";
    _leaveMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subscri.frame.origin.x+70, _subscri.frame.origin.y, 60, 40)];
    _leaveMsgLabel.text = @"留言";
    _addrMapImage = [[UIImageView alloc ]initWithFrame:CGRectMake(self.view.frame.size.width/2+5,_summaryLabel.frame.origin.y+10, self.view.frame.size.width/2-10, _leaveMsgLabel.frame.origin.y+40-(_summaryLabel.frame.origin.y+20))];
    _addrMapImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    _storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,_leaveMsgLabel.frame.origin.y+80, 55, 35)];
    _storyLabel.text =@"故事(0)";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
