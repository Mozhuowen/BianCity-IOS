//
//  subscriViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "subscriViewController.h"
#import "subscriTableViewCell.h"
#import "basicRequest.h"
#import "ResponseSubscriTown.h"
#import "townViewController.h"
@interface subscriViewController ()
@property (nonatomic,strong) UITableView *subscriTableView;
@property (nonatomic,strong) basicRequest *request;
@property (nonatomic,strong) ResponseSubscriTown *response;
@end

@implementation subscriViewController
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];

}
-(void)viewWillAppear:(BOOL)animated{
    
  //[self loadSubscriInfo];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title =@"订阅列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    _subscriTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _subscriTableView.delegate = self;
    _subscriTableView.dataSource = self;
    [_subscriTableView registerClass:[subscriTableViewCell class] forCellReuseIdentifier:@"subscriTableViewCell"];
    _subscriTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_subscriTableView];
    _request =[[basicRequest alloc] init];
  [self loadSubscriInfo];
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
    return [_response.towns count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    subscriTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"subscriTableViewCell"];
    cell.iconAddrImage.image = [UIImage imageNamed:@"ic_location_small"];
  [cell.townImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[[_response.towns objectAtIndex:indexPath.row]cover],@"!small"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    cell.townNameLabel.text = [[_response.towns objectAtIndex:indexPath.row] townname];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:[[_response.towns objectAtIndex:indexPath.row] geoinfo].city];
    [addr appendString:[[_response.towns objectAtIndex:indexPath.row] geoinfo].freeaddr];
    cell.townAddrLabel.text = addr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    townViewController *town = [[townViewController alloc] initWithNibName:@"townViewController" bundle:nil];
    town.applyTown = [_response.towns objectAtIndex:indexPath.row];
    town.isComeFromSubscri = YES;
    [self.navigationController pushViewController:town animated:YES];
}
-(void)loadSubscriInfo{
    
    NSDictionary *parameters = [_request toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
            url=[NSString stringWithString:getsubslistUrl];
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
        _response = [[ResponseSubscriTown alloc] initWithDictionary:data error:nil];
        // [self.bgScrollView headerEndRefreshing];
        log(@"loadSubscriListInfo stat is %d,errcode is %d",_response.stat,_response.errcode);
        [_subscriTableView reloadData];
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
