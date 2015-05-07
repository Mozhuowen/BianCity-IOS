//
//  saveAddrViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "saveAddrViewController.h"
#import "GeoInfo.h"
#import "upLoadImageViewController.h"
@interface saveAddrViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconAddrImage;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UITextField *userAddrTextField;
@property (nonatomic,strong) MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *msglabel;
@property (strong,nonatomic) GeoInfo *geoInfo;
@property (strong,nonatomic) UIImage *screenImage;
@end

@implementation saveAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"使用自定义地址";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _msglabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _msglabel.text = @"你可以长按并拖动地图中的图标到准确位置";
    _msglabel.lineBreakMode = NSLineBreakByWordWrapping;
    _msglabel.numberOfLines = 0;
    _iconAddrImage.image = [UIImage imageNamed:@"ic_location_large"];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:@""];
    [addr appendString:(_geoInfo.province!=nil?_geoInfo.province:@"")];
    [addr appendString:(_geoInfo.city!=nil?_geoInfo.city:@"")];
    _addrLabel.text = addr;
    _userAddrTextField.placeholder =@"自定义地址";
   // _userAddrTextField.borderStyle = UITextBorderStyleBezel;
    _userAddrTextField.delegate = self;
    _userAddrTextField.returnKeyType =UIReturnKeyDone;
#pragma location
    [MAMapServices sharedServices].apiKey =@"3b9e1284b49e66b32342d17309eb45eb";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 140, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-120.0)];
    _mapView.delegate = self;
    //_mapView.showsUserLocation = YES;
    
   // _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //[_mapView setZoomLevel:16.1 animated:YES];
    _mapView.centerCoordinate =CLLocationCoordinate2DMake([_geoInfo.latitude doubleValue],[_geoInfo.longitude doubleValue]);
    
    
    
    [self.view addSubview:_mapView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([_geoInfo.latitude doubleValue], [_geoInfo.longitude doubleValue]);
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(void)selectLeftAction:(id)sender{
    [_userAddrTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
      [_userAddrTextField resignFirstResponder];
    //截取地图图片
    CGRect inRect = _mapView.frame;
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    _geoInfo.freeaddr = _userAddrTextField.text;
    _geoInfo.screenpng = fileName;
    NSLog(@"fialename is %@",fileName);
    _screenImage =[_mapView takeSnapshotInRect:inRect];
   // [_buttom addSubview: [[UIImageView alloc]initWithImage:image]];
    
    upLoadImageViewController *upload = [[upLoadImageViewController alloc] initWithNibName:@"upLoadImageViewController" bundle:nil];
  
    [self.navigationController pushViewController:upload  animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setGeoInfo:(GeoInfo*) sender{
    _geoInfo = sender;
    
    

    NSLog(@"save   ");
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
