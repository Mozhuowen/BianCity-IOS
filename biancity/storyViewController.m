//
//  storyViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/13.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "storyViewController.h"
#import "storyheaderTableViewCell.h"

@interface storyViewController ()
{
    //  UITableView *myTable;
    UIScrollView *myScrollView;
    NSInteger currentIndex;
    
    UIView *markView;
    UIView *scrollPanel;
    //  UITableViewCell *tapCell;
    NSMutableArray * images;
    UIAlertView * progressAlert;
    ImgScrollView *lastImgScrollView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray* tapImages;
@end

@implementation storyViewController
-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.navigationItem.title = @"故事";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    [_tableView registerClass:[storyheaderTableViewCell class] forCellReuseIdentifier:@"storyheaderTableViewCell"];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tapImages =[[NSMutableArray alloc] init];
    images = _story.imagenames;
    scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;

    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = [UIScreen mainScreen].bounds.size.width*([_story.imagenames count]);
    myScrollView.contentSize = contentSize;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectRightAction:(id)sender{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        default:
            break;
    }
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case 0://对应各自的分区
            NSLog(@"image count is %lu",(unsigned long)[_story.imagenames count]);
            if([_story.imagenames count]==0){
                return 270;
            }else if([_story.imagenames count]<=4&&[_story.imagenames count]>0){
                return 270+self.view.frame.size.width/4;
            }else if([_story.imagenames count]<=8&&[_story.imagenames count]>4){
                 return 270+self.view.frame.size.width/2;
            }
            break;
        case 1://对应各自的分区
            return 90;
            break;
        default:
            break;
    }
    return 190;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    storyheaderTableViewCell * headerCell;
    switch (indexPath.section) {
        case 0://对应各自的分区
            headerCell = [tableView dequeueReusableCellWithIdentifier:@"storyheaderTableViewCell" forIndexPath:indexPath];
            //headerCell.bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
             [headerCell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_story.cover,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
                       headerCell.iconGoodImage.image = [UIImage imageNamed:@"ic_list_thumb"];
            [self setUserImage:_story.usercover imageView:headerCell.iconUserImage];
            headerCell.descrilabel.text = _story.content;
            headerCell.userNameLabel.text = _story.username;
            headerCell.dateLabel.text = _story.createtime;
            headerCell.goodLabel.text = [NSString stringWithFormat:@"%@",_story.goods];
            headerCell.subscrilabel.text = @"收藏";
            [self showImages:headerCell.imagesView];
            cell = headerCell;
           // return  headerCell;
            break;
        case 1:
            break;
        default:
            break;
    }
    return cell;
}
-(void)showImages:(UIView*)imagesView{
    CGRect tmpFrame = imagesView.frame;
    if([_story.imagenames count]==0){
        return;
    }else if([_story.imagenames count]>0&&[_story.imagenames count]<=4){
        tmpFrame.size.height = self.view.frame.size.width/4;
    }else if([_story.imagenames count]>4&&[_story.imagenames count]<=8){
     tmpFrame.size.height = self.view.frame.size.width/2;
    }
    imagesView.frame = tmpFrame;
    for(int i=0;i<[_story.imagenames count];i++){
        TapImageView *im;
        if(i<=3){
           im = [[TapImageView alloc] initWithFrame:CGRectMake(2+self.view.frame.size.width/4*i, 2, self.view.frame.size.width/4-4, self.view.frame.size.width/4-4)];
                   }
        else {
          im = [[TapImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*(i-4)+2, self.view.frame.size.width/4+2, self.view.frame.size.width/4-4, self.view.frame.size.width/4-4)];
            
        }
        im.clipsToBounds  = YES;
        im.contentMode = UIViewContentModeCenter;
        [im sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[_story.imagenames objectAtIndex:i] ,@"!small"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
        im.tag = 100+i;
        im.t_delegate =self;
        im.userInteractionEnabled = YES;
        [_tapImages addObject:im];
        [imagesView addSubview:im];
    }
    imagesView.userInteractionEnabled =YES;
}
-(void)setUserImage:(NSString *)imageName imageView:(UIImageView*)imView {
    NSString *myImgUrl = imageName;
    NSString *jap = @"http://";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(imageName){
        if(foundObj.length>0) {
            [imView  sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options: 0] ;
        }else {
            NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
            [temp appendString:imageName];
            [temp appendString:@"!small"];
            [imView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0] ;
        }
    }else {
        imView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    }

}

#pragma scrollImage

- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i <[images count]; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
//         TapImageView *temp= [[TapImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
//        TapImageView *tmpView = temp;

        //[temp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[images objectAtIndex:i] ,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0];
        
        //转换后的rect
        TapImageView *tmpView = [_tapImages objectAtIndex:i];
       CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
            ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
       // [tmpImgScrollView setImage:tmpView.image];
        [tmpImgScrollView loadImage:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[images objectAtIndex:i] ,@"!large"]];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
        [myScrollView addSubview:tmpImgScrollView];
        
    }
}
- (void) tapImageViewTappedWithObject:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
       
    }];
    
}
- (void) tappedWithObject:(id)sender
{
    
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmp = sender;
    currentIndex = tmp.tag - 100;
   // TapImageView *tmpView =[[TapImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
     //[tmpView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[images objectAtIndex:currentIndex] ,@"!large"]]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:0];
    
    //转换后的rect
     TapImageView *tmpView = [_tapImages objectAtIndex:currentIndex];
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*[UIScreen mainScreen].bounds.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    //   NSLog(@"size si %f",myScrollView.bounds.size.width);
    [tmpImgScrollView setContentWithFrame:convertRect];
   // [tmpImgScrollView setImage:tmpView.image];
    
     [tmpImgScrollView loadImage:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,[images objectAtIndex:currentIndex] ,@"!large"]];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
    [myScrollView addSubview:tmpImgScrollView];
   
}
- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }];
}
#pragma end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
