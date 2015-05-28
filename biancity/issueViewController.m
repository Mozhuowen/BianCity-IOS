//
//  issueViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/28.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "issueViewController.h"

@interface issueViewController ()
@property (nonatomic,strong) UITableView * bgTableView;
@property (nonatomic,strong) NSMutableArray* question;
@property (nonatomic,strong) NSMutableArray *Answer;
@end

@implementation issueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常见问题";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    _bgTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    _bgTableView.delegate = self;
    _bgTableView.dataSource = self;
    _bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_bgTableView];
    _question = [[NSMutableArray alloc] init];
    _Answer = [[NSMutableArray alloc] init];
    [_question addObject:@"1. 这个APP究竟是个什么鬼？\n"];
    [_Answer addObject:@"边城APP可以让你创建一个围绕准确地点的移动社区。你可以为任何感兴趣的地点创建边城社区，向人们分享你的移动社区的信息。\n\n\n\n"];
    
    [_question addObject:@"2、创建边城时为什么会提示无法获取当前地理位置？\n"];
    [_Answer addObject:@"创建边城需要开启手机定位功能，并给边城APP授权，如果已经开启定位并授权，获取位置需要一点时间，请耐心等待。\n\n\n\n"];
    
    [_question addObject:@"3、创建边城或者故事时上传图片失败？\n"];
    [_Answer addObject:@"检查一下你的网络哦，或者先保存到草稿箱，等到网络比较好的时候再上传就可以啦。\n\n\n\n"];
    
    [_question addObject:@"2. 我用得很不爽怎么办？\n"];
    [_Answer addObject:@"私密马赛~~~大鞠躬 如果有什么建议和问题记得骚扰我们，我们会下一版本中不断改进的，亲请耐心等待。\n\n\n\n"];
    
    [_question addObject:@"3. 怎么骚扰你们？\n"];
    [_Answer addObject:@"mozhuowen@gmail.com\n\n\n\n"];
    
    [_question addObject:@"4. 看完这一页我准备把你们的APP给卸了。\n"];
    [_Answer addObject:@"や!め!て! (ㄒoㄒ)// 泪奔中 边城APP不会后台运行不会弹通知骚扰不会收集隐私，你这样对一个乳齿善良的APP真的好么？ \n\n\n\n"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_question count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height=0;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 10)];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    lab.text = [_question objectAtIndex:indexPath.row];
    [lab sizeToFit];
    height+=lab.frame.size.height;
    lab = [[UILabel alloc] initWithFrame:CGRectMake(20,height, self.view.frame.size.width-40, 10)];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = [_Answer objectAtIndex:indexPath.row];
    [lab sizeToFit];
    height+=lab.frame.size.height;
    height +=10;
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height=0;
    CGRect rect1,rect2;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 10)];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    lab.text = [_question objectAtIndex:indexPath.row];
    [lab sizeToFit];
    rect1 = lab.frame;
    height+=lab.frame.size.height;
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(20,height, self.view.frame.size.width-40, 10)];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = [_Answer objectAtIndex:indexPath.row];
    [lab sizeToFit];
    rect2 = lab.frame;
     height+=lab.frame.size.height;
    height +=10;
    UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *q = [[UILabel alloc]initWithFrame:rect1];
    q.lineBreakMode = NSLineBreakByWordWrapping;
    q.numberOfLines = 0;
    q.text = [_question objectAtIndex:indexPath.row];
    [cell.contentView addSubview:q];
    UILabel *a = [[UILabel alloc]initWithFrame:rect2];
    a.lineBreakMode = NSLineBreakByWordWrapping;
    a.numberOfLines = 0;
    a.font = [UIFont systemFontOfSize:14];
    a.text = [_Answer objectAtIndex:indexPath.row];
    [cell.contentView addSubview:a];
    return  cell;
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
