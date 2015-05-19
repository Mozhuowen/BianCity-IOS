//
//  configureViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/19.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "configureViewController.h"
#import "settingTableViewCell.h"
@interface configureViewController ()
@property (nonatomic,strong) UITableView* configureTableView;
@property (nonatomic,strong) NSMutableArray *section;
@end

@implementation configureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    CGRect rc  = [UIScreen mainScreen].bounds;
    rc.origin.y +=20;
    
    _configureTableView = [[UITableView alloc] initWithFrame:rc];
    _configureTableView.delegate =self;
    _configureTableView.dataSource =self;
  [self.configureTableView registerClass:[settingTableViewCell class] forCellReuseIdentifier:@"settingTableViewCell"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
 _section = [[NSMutableArray alloc] initWithObjects:@"点击修改头像",@"昵称",@"性别",@"所在地", nil];
    [self.view addSubview:_configureTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
            return  4;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
     return 80;
    }else {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
            
        case 0://对应各自的分区
            
            [[cell textLabel]  setText:[_section objectAtIndex:indexPath.row]];//给cell添加数据
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            cell.imageView.layer.masksToBounds = YES;
            [cell imageView].layer.cornerRadius = 20;
            //NSLog(@"w %f,h %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
            if(_user){
                NSString *myImgUrl = _user.cover;
                NSString *jap = @"http://";
                NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
                if(_user.cover){
                    if(foundObj.length>0) {
                        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                    }else {
                        NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
                        [temp appendString:_user.cover];
                        [temp appendString:@"!small"];
                        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                    }
                }else {
                    cell.imageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
                }
            }
            
            break;
        case 1:  [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],_user.name]];
            break;
        case 2:   [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],[_user.sex isEqualToString:@"f"]?@"女": @"男"]];
            break;
        case 3:   [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],_user.location]];
            break;
            
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
            switch (indexPath.row) {
                case 0:
                  
                    return;
                    break;
                case 1:
                    return;
                    break;
                case 2:
                    return;
                    break;
                case 3:
                    return;
                    break;
            }
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
