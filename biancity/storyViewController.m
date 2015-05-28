//
//  storyViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/13.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "storyViewController.h"
#import "storyheaderTableViewCell.h"
#import "ModelComment.h"
#import "ResponseComment.h"
#import "Refresh.h"
#import "CommentTableViewCell.h"
#import "UIView+KeyboardObserver.h"
#import "UserViewController.h"
#import "ModelFavorite.h"
#import "ResponseFavorite.h"
#import "ModelGood.h"
#import "ResponseGood.h"
#import "ModelDelete.h"
#import "ResponseSimple.h"
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
    NSInteger index_comment;
    BOOL isloading;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray* tapImages;
@property (nonatomic,strong) ModelComment *requestComment;
@property (nonatomic,strong) ResponseComment *responseComment;
@property (nonatomic,strong) UIImageView *placeholderImage;
@property (nonatomic,strong) UITextField * responseText;
@property (nonatomic,strong) UILabel * retrunLabel;
@property (nonatomic,strong) UIView *bgTextView;
@property (nonatomic,strong) ModelFavorite *requestFavorite;
@property (nonatomic,strong) ResponseFavorite* responseFavorite;
@property (nonatomic,strong) ModelGood *requestGood;
@property (nonatomic,strong) ResponseGood *responseGood;
@property (nonatomic,strong) ModelDelete *requestDelete;
@property (nonatomic,strong) ResponseSimple *responseDelete;

@end

@implementation storyViewController
#pragma header and footer
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc loadCommentInfo:0];
        [vc loadfavoriteInfo:0 view:nil];
        [vc loadGoodInfo:0 tag:-1];
    }];
   // [self.tableView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        //[vc addInfo];
        [vc loadCommentInfo:1];
        
    }];
}
-(void)commitComment{
    [_responseText resignFirstResponder];
    NSString *comm;
    if(index_comment>=0){
      comm =[NSString stringWithFormat:@"%@//<font color='#1E90FF'>@%@</font>:%@", _responseText.text,[[_responseComment.comments objectAtIndex:index_comment] username],[[_responseComment.comments objectAtIndex:index_comment] content]];
    }
    else{
     comm =[NSString stringWithFormat:@"%@", _responseText.text];
    }
    _responseText.text = @"";
    _requestComment.townid = _story.townid;
    _requestComment.content = comm;
    _requestComment.putaoid = _story.putaoid;
    [self loadCommentInfo:2];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if([_story.userid isEqualToNumber:_story.ptuserid]){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  target:self action:@selector(selectRightAction:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    if(_isComeFromFavorite){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if(_notEditFlag){
    self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@•故事",_story.title];
     [_bgTextView addKeyboardObserver];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [_bgTextView removeKeyboardObserver];
}
#pragma header and footer end
- (void)viewDidLoad {
    [super viewDidLoad];
    _requestFavorite = [[ModelFavorite alloc] init];
    _requestFavorite.putaoid = _story.putaoid;
    _requestComment = [[ModelComment alloc] init];
    _requestComment.commentposition = 0;
    _requestComment .putaoid = _story.putaoid;
    _requestGood = [[ModelGood alloc] init];
    _requestGood.type = [NSNumber numberWithInt:1];
    _requestGood.targetid =  _story.putaoid;
    _requestDelete = [[ModelDelete alloc] init];
    _requestDelete.type =[NSNumber numberWithInt:1];
    _requestDelete.id = _story.putaoid;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    _placeholderImage = [[UIImageView alloc] init];
   
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _bgTextView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height-40, _tableView.frame.size.width, 40)];
      _bgTextView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _responseText = [[UITextField alloc] initWithFrame:CGRectMake(5, 4, _bgTextView.frame.size.width-80, _bgTextView.frame.size.height-8)];
    _responseText.layer.borderWidth =1.0;
    _responseText.layer.cornerRadius =3.0;
    _responseText.backgroundColor =[UIColor whiteColor];
    _responseText.layer.borderColor = [[UIColor grayColor] CGColor];
       _responseText.returnKeyType =UIReturnKeyDone;
    _responseText.placeholder = @"说点什么吧";
    _responseText.delegate = self;
    _retrunLabel = [[UILabel alloc] initWithFrame:CGRectMake(_responseText.frame.size.width+_responseText.frame.origin.x+10, _responseText.frame.origin.y, 55, _responseText.frame.size.height)];
    _retrunLabel.textAlignment = NSTextAlignmentCenter;
    _retrunLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    _retrunLabel.layer.borderWidth = 1.0;
    _retrunLabel.backgroundColor = [UIColor whiteColor];
    _retrunLabel.layer.cornerRadius = 3.0;
    _retrunLabel.text = @"评论";
    UITapGestureRecognizer *commitComments = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitComment)];
    _retrunLabel.userInteractionEnabled = YES;
    [_retrunLabel addGestureRecognizer:commitComments];
    [_bgTextView addSubview:_responseText];
    [_bgTextView addSubview:_retrunLabel];
    [_tableView registerClass:[storyheaderTableViewCell class] forCellReuseIdentifier:@"storyheaderTableViewCell"];
    [_tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
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
    [self addHeader];
    [self addFooter];
    [self loadCommentInfo:3];
    [self loadfavoriteInfo:0 view:nil];
    [self loadGoodInfo:0 tag:-1];
    isloading =NO;
    [self.view addSubview:_bgTextView];
    _bgTextView.alpha = 0;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectRightAction:(id)sender{
    [self showSheetSource:sender];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [_responseComment.comments count];
            break;
        default:
           return 0;
            break;
    }
 
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    int height = [UIScreen mainScreen].bounds.size.width*3/5+140;
    NSString*str;
    UILabel *label;
    switch (indexPath.section) {
            
        case 0://对应各自的分区
            label = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, [UIScreen mainScreen].bounds.size.width-8, 10)];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.font =[UIFont systemFontOfSize:14];
            label.text =_story.content;
            [label sizeToFit];
            NSLog(@"image count is %lu",(unsigned long)[_story.imagenames count]);
            if([_story.imagenames count]==0){
                return height+label.frame.size.height;
            }else if([_story.imagenames count]<=4&&[_story.imagenames count]>0){
                return height+self.view.frame.size.width/4+label.frame.size.height;
            }else if([_story.imagenames count]<=8&&[_story.imagenames count]>4){
                 return height+self.view.frame.size.width/2+label.frame.size.height;
            }
            break;
        case 1://对应各自的分区
               label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-45, 10)];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            str= [[[_responseComment.comments objectAtIndex:indexPath.row] content] stringByReplacingOccurrencesOfString:@"<font color='#1E90FF'>" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];

            label.text =str;
            [label sizeToFit];
            return 40 + ((label.frame.size.height+20)>45?(label.frame.size.height+20):45);
            break;
        default:
         return 0;
            break;
    }
     return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        [_responseText resignFirstResponder];
        break;
        case 1:
        _responseText.placeholder = [NSString stringWithFormat:@"回复: %@",[[_responseComment.comments objectAtIndex:indexPath.row] username]];
        [self textAppear:indexPath.row];
        break;
        default:
        break;
    }
}
-(void)textAppear{
    
    index_comment = -1;
    CGRect rect = _tableView.frame;
    
    if(_bgTextView.alpha ==0){
        rect.size.height = rect.size.height -40;
        _tableView.frame = rect;
        _bgTextView.alpha = 1;
         [_responseText becomeFirstResponder];
    }else {
        rect.size.height = rect.size.height +40;
        _tableView.frame = rect;
        _bgTextView.alpha = 0;
    }
    [_bgTextView setNeedsDisplay];
   
    NSLog(@"textTap");
}
-(void)textAppear:(NSInteger)index{
    index_comment = index;
    CGRect rect = _tableView.frame;
    
    if(_bgTextView.alpha ==0){
        rect.size.height = rect.size.height -40;
        _tableView.frame = rect;
        _bgTextView.alpha = 1;
    }
     [_responseText becomeFirstResponder];
    [_bgTextView setNeedsDisplay];
    NSLog(@"textTap");
}

-(void)tapfavorite:(UITapGestureRecognizer*)sender{
    ((UILabel *)[sender view]).userInteractionEnabled = NO;
    [self loadfavoriteInfo:1 view:(UILabel *)[sender view]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    storyheaderTableViewCell * headerCell;
    CommentTableViewCell *commentCell;
    ModelComment *tmp ;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-45, 10)];
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_story.cover,@"!small"]];
    UITapGestureRecognizer *tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textAppear)];
    UITapGestureRecognizer * tapfav =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapfavorite:)];
    CGRect rect;
    UITapGestureRecognizer* tapGood = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doGoodCommit:)];
    
    switch (indexPath.section) {
        case 0://对应各自的分区
            headerCell = [tableView dequeueReusableCellWithIdentifier:@"storyheaderTableViewCell" forIndexPath:indexPath];
        if(url){
            [_placeholderImage sd_setImageWithURL:url
                             placeholderImage:[UIImage imageNamed:@"placeholder"]
                                      options:SDWebImageProgressiveDownload
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         //add some ting
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        NSLog(@"loadbgImage complete");
                                        [self loadBgimage:headerCell.bgImageView image:image];
                                    }];
             }
            if(_responseGood.good.dogood){
                headerCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumbup"];
            }else{
                headerCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumb"];
            }
            headerCell.iconGoodImage.tag = -1;
             headerCell.iconGoodImage.userInteractionEnabled = YES;
            [ headerCell.iconGoodImage addGestureRecognizer:tapGood];
            
            [self setUserImage:_story.usercover imageView:headerCell.iconUserImage row:indexPath.row];
            headerCell.iconUserImage.tag =-1;
            
            label.frame =headerCell.descrilabel.frame ;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.text = _story.content;
            label.font =[UIFont systemFontOfSize:14];
            [label sizeToFit];
            headerCell.descrilabel.frame = label.frame;
            headerCell.descrilabel.text = _story.content;
             rect = headerCell.imagesView.frame;
            rect.origin.y = headerCell.descrilabel.frame.origin.y+headerCell.descrilabel.frame.size.height+10;
            headerCell.imagesView.frame =rect;
            rect = headerCell.comment.frame;
            rect.origin.y = headerCell.imagesView.frame.origin.y + headerCell.imagesView.frame.size.height ;
             headerCell.comment.frame =rect;
            NSLog(@"headerCell.descrilabel width %f,headerCell.descrilabel height %f",headerCell.descrilabel.frame.size.width,headerCell.descrilabel.frame.size.height);
            headerCell.userNameLabel.text = _story.username;
            headerCell.dateLabel.text = _story.createtime;
            headerCell.goodLabel.text = [NSString stringWithFormat:@"%@",(_responseGood.good.goods==nil)?@"0":_responseGood.good.goods];
        headerCell.titleLabel.text = _story.title;
            if(_responseFavorite.favori.dofavori){
                CGRect re=headerCell.subscrilabel.frame;
                re.origin.x = [UIScreen mainScreen].bounds.size.width-160;
                re.size.width = 90;
                headerCell.subscrilabel.frame = re;
                headerCell.subscrilabel.text = @"取消收藏";
                _requestFavorite.action = [NSNumber numberWithInt:1];
            }else{
                CGRect re=headerCell.subscrilabel.frame;
                re.origin.x = [UIScreen mainScreen].bounds.size.width-130;
                re.size.width = 60;
                headerCell.subscrilabel.frame = re;
                headerCell.subscrilabel.text = @"收藏";
                _requestFavorite.action = [NSNumber numberWithInt:0];
            }
           
            headerCell.subscrilabel.userInteractionEnabled =YES;
            [headerCell.subscrilabel addGestureRecognizer:tapfav];
        headerCell.comment.text = @"评论";
        [headerCell.comment addGestureRecognizer:tapComment];
            if([_story.imagenames count]>0)
            [self showImages:headerCell];
        headerCell.comment.userInteractionEnabled = YES;
        headerCell.userInteractionEnabled = YES;
            cell = headerCell;
           // return  headerCell;
            break;
        case 1:
            commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
            if([((ModelComment*)[_responseComment.comments objectAtIndex:indexPath.row]).dogood boolValue]){
                commentCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumbup"];
            }else{
                commentCell.iconGoodImage.image =[UIImage imageNamed:@"ic_list_thumb"];
            }
            commentCell.iconGoodImage.tag = indexPath.row;
            commentCell.iconGoodImage.userInteractionEnabled = YES;
            [ commentCell.iconGoodImage addGestureRecognizer:tapGood];

        NSLog(@"index.row is %ld",(long)indexPath.row);
            tmp =[_responseComment.comments objectAtIndex:indexPath.row];
             [self setUserImage:tmp.cover imageView:commentCell.iconUserImage row:indexPath.row];
           NSString*str= [tmp.content stringByReplacingOccurrencesOfString:@"<font color='#1E90FF'>" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.text =str;
            [label sizeToFit];
            rect = commentCell.commentlabel.frame;
            rect.size.height = label.frame.size.height>35?label.frame.size.height:35;
            rect.size.width = label.frame.size.width >=275?label.frame.size.width:275;
            rect.size.height +=10;
           
            NSString *myImgUrl = tmp.content;
            NSString *jap = @"</font>";
            NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(foundObj.length>0){
            commentCell.commentRTlabel.hidden =NO;
            commentCell.commentRTlabel.frame =rect;
            commentCell.commentRTlabel.text =tmp.content;
                commentCell.commentlabel.hidden = YES;
            }else{
                commentCell.commentlabel.hidden = NO;
                commentCell.commentlabel.frame = rect;
                commentCell.commentlabel.text = tmp.content;
                commentCell.commentRTlabel.hidden =YES;
            }
             log(@"commentCell width %f,commentCell height %f",commentCell.commentlabel.frame.size.width,commentCell.commentlabel.frame.size.height);
           // [commentCell.commentlabel setNeedsDisplay];
            commentCell.userNameLabel.text = tmp.username;
            commentCell.dateLabel.text =tmp.time;
            commentCell.goodLabel.text = [NSString stringWithFormat:@"%@",(tmp.goods==nil)?@"0":tmp.goods];
            cell = commentCell;
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // [cell sizeToFit];
    
    return cell;
}
-(void)doGoodCommit:(UITapGestureRecognizer*)sender{
    if(!isloading){
    NSInteger tag = ((UIImageView*)[sender view]).tag;
      if(tag<0){
        if(_responseGood.good.dogood){
            _requestGood.action = [NSNumber numberWithInt:1];
        }else{
            _requestGood.action = [NSNumber numberWithInt:0];

        }
              _requestGood.type = [NSNumber numberWithInt:1];
        _requestGood.targetid = _story.putaoid;
    }else{
        if([((ModelComment*)[_responseComment.comments objectAtIndex:tag]).dogood boolValue]){
            _requestGood.action = [NSNumber numberWithInt:1];
        }else{
            _requestGood.action = [NSNumber numberWithInt:0];
        }
        _requestGood.type = [NSNumber numberWithInt:2];
        _requestGood.targetid =((ModelComment*)[_responseComment.comments objectAtIndex:tag]).commentid;
        
    }
        [self loadGoodInfo:1 tag:tag];
        isloading = YES;
  }
}
-(void)loadBgimage:(UIImageView*)imgView image:(UIImage*)image{
   [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getPictureUrl,_story.cover,@"!large"]]  placeholderImage:image options:0] ;
}
-(void)showImages:(storyheaderTableViewCell*)cell{
    CGRect tmpFrame = cell.imagesView.frame;
    if([_story.imagenames count]==0){
        return;
    }else if([_story.imagenames count]>0&&[_story.imagenames count]<=4){
        tmpFrame.size.height = self.view.frame.size.width/4;
    }else if([_story.imagenames count]>4&&[_story.imagenames count]<=8){
     tmpFrame.size.height = self.view.frame.size.width/2;
    }
     cell.imagesView.frame = tmpFrame;
    tmpFrame = cell.comment.frame;
    tmpFrame.origin.y =  cell.imagesView.frame.origin.y+ cell.imagesView.frame.size.height+15;
    cell.comment.frame = tmpFrame;
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
        [cell.imagesView addSubview:im];
    }
    cell.imagesView.userInteractionEnabled =YES;
}
-(void)setUserImage:(NSString *)imageName imageView:(UIImageView*)imView row:(NSInteger)index_row{
    NSString *myImgUrl = imageName;
    NSString *jap = @"http://";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(imageName){
        if(foundObj.length>0) {
            [imView  sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options: index_row == 0 ? SDWebImageRefreshCached : 0] ;
        }else {
            NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
            [temp appendString:imageName];
            [temp appendString:@"!small"];
            [imView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:index_row == 0 ? SDWebImageRefreshCached : 0] ;
        }
    }else {
        imView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    }
    imView.tag = index_row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
    [imView addGestureRecognizer:tap];
    imView.userInteractionEnabled =YES;
}
-(void)tapUser:(UITapGestureRecognizer*)sender{
    UIImageView *vi =( UIImageView *) [sender view];
    NSInteger idx_user = vi.tag;
    NSLog(@"tag %ld",(long)idx_user);
    UserViewController * user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    if(idx_user<0){
        user.userid = _story.userid;
        user.UserCover = _story.usercover;
        user.UserName = _story.username;
    }else{
    user.userid = [[_responseComment.comments objectAtIndex:idx_user] userid];
    user.UserCover = [[_responseComment.comments objectAtIndex:idx_user] cover];
        user.UserName = [[_responseComment.comments objectAtIndex:idx_user] username];
    }
    user.via = YES;
    [self.navigationController pushViewController:user animated:YES];
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
        //转换后的rect
        TapImageView *tmpView = [_tapImages objectAtIndex:i];
       CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        [tmpView setNeedsDisplay];
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
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
    
    TapImageView *tmpView =  sender;
    currentIndex = tmpView.tag - 100;
    //转换后的rect
    [tmpView setNeedsDisplay];
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*[UIScreen mainScreen].bounds.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    //   NSLog(@"size si %f",myScrollView.bounds.size.width);
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    
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

#pragma loadinfo
-(void)loadCommentInfo:(int )check{
    if(check==0||check==2){
        _requestComment.commentposition = 0;
    }
    NSDictionary *parameters = [_requestComment toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    if(check==2){
       url=[NSString stringWithString:submitCommentUrl];
    }else{
     url =[NSString stringWithString:getCommentUrl];
    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadCommentInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check == 0){
        _responseComment = [[ResponseComment alloc] initWithDictionary:data error:nil];
            [_tableView headerEndRefreshing];
            if([_responseComment.comments count]<10){
                _tableView.footerHidden =YES;
            }else{
                _tableView.footerHidden =NO;
            }
        }else if(check ==1){
            ResponseComment *ad = [[ResponseComment alloc] initWithDictionary:data error:nil];
        
             [_tableView footerEndRefreshing];
            if([ad.comments count]>0){
            [_responseComment.comments addObjectsFromArray:ad.comments];
            _responseComment.stat =ad.stat;
                _responseComment.errcode = ad.errcode;
                if([ad.comments count]<10){
                    _tableView.footerHidden = YES;
                }else{
                _tableView.footerHidden =NO;
                }
            }else{
                _tableView.footerHidden = YES;
            }
        }
        else{
             _responseComment = [[ResponseComment alloc] initWithDictionary:data error:nil];
            if([_responseComment.comments count]<10){
                _tableView.footerHidden =YES;
            }
        }
        _requestComment.commentposition = [NSNumber numberWithInteger:[_responseComment.comments count]];
     log(@"loadSubscriInfo stat is %d,errcode is %d,%@",_responseComment.stat,_responseComment.errcode,_responseComment);
        [_tableView reloadData];
        if(check ==2){
           NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(check==0)
        [_tableView headerEndRefreshing];
        else if(check ==1)
            [_tableView footerEndRefreshing];
    }];
}

-(void)loadfavoriteInfo:(NSInteger)check view:(UILabel*)label{
    
    NSDictionary *parameters = [_requestFavorite toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    if(check == 0){
        url=[NSString stringWithString:getfavoriteUrl];
    }else{
         url=[NSString stringWithString:dofavoriteUrl];
    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadfavoriteInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseFavorite = [[ResponseFavorite alloc] initWithDictionary:data error:nil];
        // [self.bgScrollView headerEndRefreshing];
        log(@"loadfavoriteInfo stat is %d,errcode is %d",_responseFavorite.stat,_responseFavorite.errcode);
        if(check==1){
            if(_responseFavorite.favori.dofavori){
                CGRect re=label.frame;
                re.origin.x = [UIScreen mainScreen].bounds.size.width-160;
                re.size.width = 90;
                label.frame = re;
                label.text = @"取消收藏";
            }else{
                CGRect re=label.frame;
                re.origin.x = [UIScreen mainScreen].bounds.size.width-130;
                re.size.width = 60;
                label.frame = re;
                label.text = @"收藏";
            }
        }
        [_tableView reloadData];
        label.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // [self.bgScrollView headerEndRefreshing];
    }];
}

-(void)loadGoodInfo:(NSInteger)check tag:(NSInteger)tag{
    
    NSDictionary *parameters = [_requestGood toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url;
    if(check ==0){
        url=[NSString stringWithString:getGoodsUrl];
    }else {
        url=[NSString stringWithString:doGoodUrl];
        
    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"loadGoodInfo Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             // [self.bgScrollView headerEndRefreshing];
        if(tag>=0){
            ResponseGood * ad;
            ad = [[ResponseGood alloc] initWithDictionary:data error:nil];
            ((ModelComment*) [_responseComment.comments objectAtIndex:tag]).dogood=[NSNumber numberWithBool: ad.good.dogood];
            ((ModelComment*) [_responseComment.comments objectAtIndex:tag]).goods = ad.good.goods;
        }else {
         _responseGood = [[ResponseGood alloc] initWithDictionary:data error:nil];
        }
        [_tableView reloadData];
        isloading =NO;
        log(@"loadGoodInfo stat is %d,errcode is %d",_responseGood.stat,_responseGood.errcode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[self.bgScrollView headerEndRefreshing];
    }];
}
- (void)showSheetSource:(id)sender {
    // NSLog(@"showSheet");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确认删除"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"确定",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [self deleteInfo];
    }else if (buttonIndex == 1) {
        //   [self showAlert:@"第一项"];
        return;
    }
}

-(void)deleteInfo{
    
    NSDictionary *parameters = [_requestDelete toDictionary];
    //NSLog(@"%@",parameters);
    NSString *url =[NSString stringWithString:deleteUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Delete Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseDelete = [[ResponseSimple alloc] initWithDictionary:data error:nil];
        
        log(@"responseDelete stat is %d,errcode is %d",_responseDelete.stat,_responseDelete.errcode);
        if(_responseDelete.stat){
            [self.navigationController popViewControllerAnimated:YES];
             }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // [self.bgScrollView headerEndRefreshing];
    }];
}
#pragma endload
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
