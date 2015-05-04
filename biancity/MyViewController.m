//
//  MyViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "MyViewController.h"
#import "MyCollectionReusableView.h"
#import "HotTownCollectionViewCell.h"
#import "ResponseHotTown.h"
@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) ResponseHotTown * hotTown;
@property (strong,nonatomic) NSMutableArray *fakeColors;
@end

@implementation MyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   
     [self.myCollectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionReusableView"];
       [self.myCollectionView registerClass:[HotTownCollectionViewCell class] forCellWithReuseIdentifier:@"HotTownCollectionViewCell"];
    self.myCollectionView.dataSource =self;
    self.myCollectionView.delegate = self;
    self.fakeColors = [[NSMutableArray alloc ] init];
    for (int i = 0; i<5; i++) {
        [self.fakeColors insertObject:RandomColor atIndex:0];
    }
    self.myCollectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.myCollectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(self.myCollectionView.frame.size.width, 230);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma CollectionView begin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5.0, 5.0, 5.0);
};
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width-16)/2,(collectionView.frame.size.width-16)/2 +50);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count si %lu",(unsigned long)[self.fakeColors count]);
    return [self.fakeColors count];//[self.hotTown.towns count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotTownCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotTownCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius =5;
    cell.HotTownCoverImage.backgroundColor = [self.fakeColors objectAtIndex:indexPath.row];
//    NSString * imageUrl = [[self.hotTown.towns objectAtIndex:indexPath.row] cover];
//    NSMutableString *pictureUrl = [[NSMutableString alloc] initWithString:@"http://xiaocheng.b0.upaiyun.com/"];
//    [pictureUrl appendString:imageUrl];
//    [pictureUrl appendString:@"!small"];
//    // NSLog(@"imageUrl = %@",pictureUrl);
//    [cell.HotTownCoverImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
//    
//    [cell.hotTownNameLabel setText:[[self.hotTown.towns objectAtIndex:indexPath.row] townname]];
//    NSMutableString *addr = [[NSMutableString alloc] initWithString:[[self.hotTown.towns objectAtIndex:indexPath.row] geoinfo].city];
//    [addr appendString:[[self.hotTown.towns objectAtIndex:indexPath.row] geoinfo].freeaddr];
//    [cell.addrLabel setText:addr];
//    [cell.goodLabel setText:[NSString stringWithFormat:@"%@", [[self.hotTown.towns objectAtIndex:indexPath.row] good]]];
    cell.icon1Image.image = [UIImage imageNamed:@"ic_location_small_light"];
    cell.icon2Image.image = [UIImage imageNamed:@"ic_list_thumb_small"];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  
    NSLog(@"header");
    if (kind == UICollectionElementKindSectionHeader){
          MyCollectionReusableView *header;
       header =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionReusableView" forIndexPath:indexPath];
        header.myCoverImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
        header.iconAddImage.image = [UIImage imageNamed:@"ic_plus"];
        header.iconMaleImage.image = [UIImage imageNamed:@"ic_sex_boy"];
        header.iconAddrImage.image = [UIImage imageNamed:@"ic_location_small"] ;
        header.iconSettingImage.image = [UIImage imageNamed:@"ic_account_setting"];
        header.iconMyImage.layer.masksToBounds=YES;
        header.iconMyImage.layer.cornerRadius=25.0;
        header.iconMyImage.layer.borderWidth=1.0;
        header.iconMyImage.backgroundColor = [UIColor whiteColor];
        header.iconLineImage.backgroundColor = [UIColor whiteColor];
        header.myNameLabel.text = @"wo" ;
        header.maleLabel.text = @"男";
        header.addrLabel.text = @"酉阳";
        
        header.myTownsLabel.text = @"0";
        header.myTownLabel.text = @"边城";
        
        header.myStorysLabel.text = @"0";
        header.myStoryLabel.text = @"故事";
        
        header.fansLabel.text = @"0";
        header.fanLabel.text = @"粉丝";
        header.checksLabel.text = @"0";
        header.checkLabel.text = @"订阅";
        header.storesLabel.text = @"0";
        header.storeLabel.text = @"收藏";
        header.goodsLabel.text = @"0";
        header.goodLabel.text = @"边城";
        return header;
    }
    return nil;
}

#pragma CollectionView End
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
