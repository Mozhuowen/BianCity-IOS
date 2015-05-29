//
//  mapViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "mapViewController.h"

@interface mapViewController ()
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) UILabel *locallabel;
@end

@implementation mapViewController
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)startlocal{
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectLeftAction:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
        
    [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";
    self.view.frame = [UIScreen mainScreen].bounds;
   
    _locallabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, [UIScreen mainScreen].bounds.size.width-120, 40)];
    _locallabel.backgroundColor =[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    UITapGestureRecognizer* tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startlocal)];
    [_locallabel addGestureRecognizer:tapMap];
    _locallabel.userInteractionEnabled =YES;
    _locallabel.text = @"定位到我的位置";
    _locallabel.layer.borderWidth =1.0;
    _locallabel.layer.cornerRadius =4.0;
    _locallabel.layer.borderColor= [[UIColor grayColor]CGColor];
    _locallabel.textAlignment =NSTextAlignmentCenter;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, _locallabel.frame.origin.y+_locallabel.frame.size.height+5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40.0)];
    _mapView.delegate = self;
    _mapView.centerCoordinate =CLLocationCoordinate2DMake(_townLocal.coordinate.latitude ,_townLocal.coordinate.longitude);
    [self.view  addSubview:_locallabel];
    [self.view addSubview:_mapView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
        self.navigationItem.title =[NSString stringWithFormat:@"%@•位置",_townname];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_townLocal.coordinate.latitude , _townLocal.coordinate.longitude);
    pointAnnotation.title = @"边城位置";
    
    [_mapView setZoomLevel:16.1 animated:YES];
    [_mapView addAnnotation:pointAnnotation];
}
#pragma mark mapView Delegate 地图 添加标注时 回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
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
