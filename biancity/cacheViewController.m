//
//  cacheViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/21.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "cacheViewController.h"
#import "townCache.h"
#import "CacheTableViewCell.h"
#import "upLoadImageViewController.h"
#import "addStoryViewController.h"
@interface cacheViewController ()
@property (nonatomic,strong) UITableView *cacheTableView;
@property (nonatomic,strong) NSMutableArray *cacheCount;
@property (nonatomic,strong) NSMutableArray *keys;
@end

@implementation cacheViewController
-(void)viewWillAppear:(BOOL)animated{
    [self readUserDeafultsOwn];
}
- (void) readUserDeafultsOwn
{
    [_keys removeAllObjects];
    [_cacheCount removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache = [[NSDictionary alloc] init];
    cache = [userDefaults objectForKey:@"cache"];
    townCache *item1 = [[townCache alloc] init];
    for(id key in cache){
        item1 = [[townCache alloc]initWithDictionary:[cache objectForKey:key] error:nil];
        [_keys addObject:key];
        [_cacheCount addObject:item1];
    }
    [_cacheTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
       self.navigationItem.title = @"草稿箱";
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

    self.view.frame = [UIScreen mainScreen].bounds;
    self.cacheCount = [[NSMutableArray alloc] init];
    self.keys = [[NSMutableArray alloc] init];
    _cacheTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _cacheTableView.delegate = self;
    _cacheTableView.dataSource = self;
    [_cacheTableView registerClass:[CacheTableViewCell class] forCellReuseIdentifier:@"CacheTableViewCell"];
    [self.view addSubview:_cacheTableView];
    [self readUserDeafultsOwn];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(((townCache*)[_cacheCount objectAtIndex:indexPath.row]).type==0){
    upLoadImageViewController *upload = [[upLoadImageViewController alloc] initWithNibName:@"upLoadImageViewController" bundle:nil];
//        [upload setCacheBegin:[_cacheCount objectAtIndex:indexPath.row] key:[_keys objectAtIndex:indexPath.row]];
        upload.cacheid =[_keys objectAtIndex:indexPath.row];
        upload.isComeFromCache = YES;
    [self.navigationController pushViewController:upload animated:YES];
    }else{
        addStoryViewController* story = [[addStoryViewController alloc] initWithNibName:@"addStoryViewController" bundle:nil];
        story.isComeFormCache = YES;
        story.cacheid = [_keys objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:story animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    log(@"cachecount is %lu",(unsigned long)[_cacheCount count]);
    return [_cacheCount count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CacheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CacheTableViewCell" forIndexPath:indexPath];
    townCache* tmp = [_cacheCount objectAtIndex:indexPath.row];
    cell.image.image = [self imageWithImage:[self readeIamge:tmp.coverName] scaledToSize:cell.image.frame.size];
    if(tmp.type ==0){
        cell.typeLabel.text=@"边城";
    }else{
         cell.typeLabel.text=@"故事";
    }
    cell.NameLabel.text = tmp.title;
    cell.deleteImage.tag = indexPath.row;
    cell.deleteImage.image = [UIImage imageNamed:@"delete"];
    UITapGestureRecognizer * tapdele = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
    cell.deleteImage.userInteractionEnabled = YES;
    [cell.deleteImage addGestureRecognizer:tapdele];
    return cell;
}
- (void)showSheetSource:(id)sender {
    NSInteger tag = ((UIImageView*)[sender view]).tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定删除？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"确定", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger   tag = actionSheet.tag;
    log(@"tag is %ld",(long)tag);
    if (buttonIndex == 0) {

        NSMutableDictionary * ca = [[NSMutableDictionary alloc] init];
        for(NSInteger i=0;i<[_cacheCount count];i++){
            if(i == tag){
                [self removeImageFile:[[_cacheCount objectAtIndex:i] coverName]];
                if([[_cacheCount objectAtIndex:i] mapIamgeName]!=nil){
                    [self removeImageFile:[[_cacheCount objectAtIndex:i] mapIamgeName]];
                }
                NSMutableArray *imagesName =[[_cacheCount objectAtIndex:i] imagesName];
                if(imagesName!=nil){
                    for(int i=0;i<[imagesName count];i++)
                        [self removeImageFile:[imagesName objectAtIndex:i]];
                }
            }else{
                [ca setObject:[[_cacheCount objectAtIndex:i
                               ] toDictionary] forKey:[_keys objectAtIndex:i]];
                log(@" ca is %@",ca);
            }
           }
        [self saveUserDefaults:ca];
        [self readUserDeafultsOwn];
        
    }else if (buttonIndex == 1) {
        return;
    }
}
-(UIImage*)readeIamge:(NSString*)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    UIImage * result;
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if(blHave){
        result = [UIImage imageWithData:[NSData dataWithContentsOfFile:uniquePath]];
    }
    return  result;
}
-(void)removeImageFile:(NSString*)imageName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        log(@"no  have");
        return ;
    }else {
        log(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            log(@"dele success");
        }else {
            log(@"dele fail");
        }
        
    }
}

- (void)saveUserDefaults:(NSDictionary*)cache{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    log(@"after delecache %@",cache);
    [userDefaults setObject:cache forKey:@"cache"];
    
    [userDefaults synchronize];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    NSData *imageData = UIImageJPEGRepresentation(image,0.3);
    image = [UIImage imageWithData:imageData];
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
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
