//
//  AboutUsViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/28.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic,strong) UIScrollView * bgScrollView;
@property (nonatomic,strong) UIImageView * AppIcon;
@property (nonatomic,strong) UILabel * appVersion;
@property (nonatomic,strong) UILabel * msgLabel;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView =[[UIScrollView alloc] initWithFrame:self.view.frame];
    CGRect rect = self.view.frame;
    rect.size.height *=1.5;
    _bgScrollView.contentSize = rect.size;
    rect = CGRectMake(_bgScrollView.center.x-70, 10, 140, 140);
    _AppIcon = [[UIImageView alloc] initWithFrame:rect];
     rect = CGRectMake(_bgScrollView.center.x-40, 160, 80, 20);
    _appVersion = [[UILabel alloc] initWithFrame:rect];
    _appVersion.textAlignment = NSTextAlignmentCenter;
      rect = CGRectMake(20, 190, _bgScrollView.frame.size.width-40, _bgScrollView.contentSize.height-210);
    _msgLabel = [[UILabel alloc] initWithFrame:rect];
    _msgLabel.lineBreakMode =NSLineBreakByWordWrapping;
    _msgLabel.numberOfLines =0;
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"边城APP可以帮助你创建一个基于地点的移动社区。你可以在任何感兴趣的地点创建边城移动社区，向周围的人分享你的信息。\n\n"];
    [str appendString:@"如果你是商家，你可以为你的店铺创建一个边城，向附近的消费者展示你商品和服务，和你的顾客保持联系。\n\n"];
  [str appendString: @"如果你是一名旅行者，你可在令你惊叹的景点创建一个边城，向景点附近的人们分享你的发现和感受，并和网友讨论感兴趣的旅行信息。\n\n"];
   [str appendString: @"如果你是一名学生，你可以在你的学校、教室、宿舍为地点中心创建一个边城，向周围的同学朋友分享和讨论你们的趣事。\n\n"];
   [str appendString: @"如果你是一名白领，你可以为上下班途中的一个公交站、餐厅创建边城，和经过这里的人们交流彼此的故事，发现相同轨迹的人不一样的人生。\n\n"];
    [str appendString:@"如果你正在热恋，不要忘了在他当初向你表白的那颗梧桐树下创建一个边城。\n\n"];
   [str appendString: @"如果你正在创业，不要忘了在你们最初奋斗的那个出租房创建一个边城。\n\n"];
  [str appendString: @"翠翠的边城里写满了美好、感动和遗憾，你的呢？\n"];
    _msgLabel.text = str;
    _AppIcon.image = [UIImage imageNamed:@"appIcon"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    _appVersion.text =[NSString stringWithFormat:@"版本:%@",versionNum];
    [_bgScrollView addSubview:_AppIcon];
    [_bgScrollView addSubview:_appVersion];
    [_bgScrollView addSubview:_msgLabel];
    [self.view addSubview:_bgScrollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
