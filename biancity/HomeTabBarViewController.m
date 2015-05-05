//
//  HomeTabBarViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/5.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "HomeTabBarViewController.h"

@interface HomeTabBarViewController ()

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item1= [self.tabBar.items objectAtIndex:0];
     UITabBarItem *item2= [self.tabBar.items objectAtIndex:1];
     UITabBarItem *item3= [self.tabBar.items objectAtIndex:2];
    // Do any additional setup after loading the view.
    item1.title = @"Home";
    item1.titlePositionAdjustment =UIOffsetMake(0, -5) ;
[item1 setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}  forState:UIControlStateNormal];
    item1.image =  [self imageWithImageSimple:   [UIImage imageNamed:@"zhuye"] scaledToSize:CGSizeMake(40.0, 20.0)];
   
    item2.title = @"Nearby";
    item2.titlePositionAdjustment =UIOffsetMake(0, -5) ;
    [item2 setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}  forState:UIControlStateNormal];
    item2.image =  [self imageWithImageSimple:   [UIImage imageNamed:@"near"] scaledToSize:CGSizeMake(40.0, 20.0)];
    
    item3.title = @"Account";
    item3.titlePositionAdjustment =UIOffsetMake(0, -5) ;
    [item3 setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}  forState:UIControlStateNormal];
 
    item3.image = [self imageWithImageSimple:   [UIImage imageNamed:@"my"] scaledToSize:CGSizeMake(40.0, 20.0)];

}

-(UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize{
     //Create a graphics image context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // return the new image.
    return newImage;
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
