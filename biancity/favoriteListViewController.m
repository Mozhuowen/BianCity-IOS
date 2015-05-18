//
//  favoriteListViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "favoriteListViewController.h"
#import "ResponseStory.h"
#import "basicRequest.h"
#import "StoryTableViewCell.h"
#import "storyViewController.h"
@interface favoriteListViewController ()
@property (nonatomic,strong) UITableView *favTableView;
@property (nonatomic,strong) ResponseStory *responseStroy;
@property (nonatomic,strong) basicRequest* requestStory;
@end

@implementation favoriteListViewController
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)viewWillAppear:(BOOL)animated{
   [self loadStorysInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"收藏列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;

    self.view.frame = [UIScreen mainScreen].bounds;
    _favTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _favTableView.delegate = self;
    _favTableView.dataSource = self;
    [_favTableView registerClass:[StoryTableViewCell class] forCellReuseIdentifier:@"StoryTableViewCell"];
    [self.view addSubview:_favTableView];
    _favTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _requestStory = [[basicRequest alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_responseStroy.putao count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryTableViewCell"];
    
    [cell.stroyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[[_responseStroy.putao objectAtIndex:indexPath.row]  cover],@"!small"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    cell.storyLabel.text = [[_responseStroy.putao objectAtIndex:indexPath.row] title];
    cell.dateLabel.text = [[_responseStroy.putao objectAtIndex:indexPath.row] createtime];
    cell.goodLabel.text =[NSString stringWithFormat:@"%@", [[_responseStroy.putao objectAtIndex:indexPath.row] goods]];
    cell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    storyViewController *story = [[storyViewController alloc] initWithNibName:@"storyViewController" bundle:nil];
    story.story = [_responseStroy.putao objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:story  animated:YES];
}
-(void)loadStorysInfo{
    
    NSDictionary *parameters = [_requestStory toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    url=[NSString stringWithString:getfavolistUrl];
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
        _responseStroy = [[ResponseStory alloc] initWithDictionary:data error:nil];
        // [self.bgScrollView headerEndRefreshing];
        log(@"loadSubscriListInfo stat is %d,errcode is %d",_responseStroy.stat,_responseStroy.errcode);
        [_favTableView reloadData];
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
