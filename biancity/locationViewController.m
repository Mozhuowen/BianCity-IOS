//
//  locationViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "locationViewController.h"

@interface locationViewController ()
@property (nonatomic,strong) MAMapView *mapView;
@end

@implementation locationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建边城";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _msgLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _msgLabel.text = @"你将在以下地点附近建立边城，请开启手机定位功能并等待定位到当前位置";
    _msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
     _msgLabel.numberOfLines = 0;
    
#pragma location
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-120.0)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
     [self.view addSubview:_mapView];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectLeftAction:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
    [self.navigationController pushViewController:nil  animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
