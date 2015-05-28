//
//  settingTableViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/8.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "settingTableViewController.h"
#import "settingTableViewCell.h"
#import "configureViewController.h"
#import "ResponseUser.h"
#import "cacheViewController.h"
#import "ResponseLogin.h"
#import "ResponseRegiste.h"
#import "AboutUsViewController.h"
#import "issueViewController.h"

@interface settingTableViewController ()
@property (nonatomic,strong) NSMutableArray *section1;
@property (nonatomic,strong) NSMutableArray *section2;
//@property (nonatomic,strong) ResponseUser * responseUser;
@property (nonatomic,strong) ResponseRegiste* registe;
@property (nonatomic,strong) ResponseLogin *login;
@end

@implementation settingTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [self readUserDeafultsOwn];
    [self.tableView reloadData];
}
- (void) readUserDeafultsOwn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    cache = [userDefaults dictionaryForKey:LOGIN_INFO];
    if([(NSNumber*)[cache objectForKey:@"needregiste"] boolValue]){
        cache = [userDefaults dictionaryForKey:REGISTE_INFO];
       _registe =[[ResponseRegiste alloc] initWithDictionary:cache error:nil];
        return;
    }
   _login=[[ResponseLogin alloc] initWithDictionary:cache error:nil];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    self.navigationItem.title = @"设置";
    [self.tableView registerClass:[settingTableViewCell class] forCellReuseIdentifier:@"settingTableViewCell"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    _section1 = [[NSMutableArray alloc] initWithObjects:@"wo", nil];
    _section2 = [[NSMutableArray alloc] initWithObjects:@"退出登录",@"草稿箱",@"检查更新",@"关于我们",@"常见意见", nil];
    [self readUserDeafultsOwn];
}
-(void)selectLeftAction:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    switch (section) {
        
        case 0:
        
        return  [_section1 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
        break;
        case 1:
        return  [_section2 count];
        break;
        default:
        return 0;
        break;
        
    }
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 50;
            break;
        default:
            break;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    settingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTableViewCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        
    case 0://对应各自的分区
        if(_login){
        [[cell textLabel]  setText:_login.name];//给cell添加数据
          // cell.imageView.frame = CGRectMake(0, 0, 40, 40);
//            cell.imageView.layer.masksToBounds = YES;
//            [cell imageView].layer.cornerRadius = 20;
//            NSLog(@"w %f,h %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
           
            NSString *myImgUrl =_login.cover;
            NSString *jap = @"http://";
            NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(_login.cover){
                if(foundObj.length>0) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }else {
                    NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
                    [temp appendString:_login.cover];
                    [temp appendString:@"!small"];
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }
            }else {
                cell.imageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
            
            }
            
        }else  if(_registe){
            [[cell textLabel]  setText:_registe.name];//给cell添加数据
//            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
//            cell.imageView.layer.masksToBounds = YES;
//            [cell imageView].layer.cornerRadius = 20;
            NSLog(@"w %f,h %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
            
            NSString *myImgUrl =_registe.cover;
            NSString *jap = @"http://";
            NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(_registe.cover){
                if(foundObj.length>0) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }else {
                    NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
                    [temp appendString:_registe.cover];
                    [temp appendString:@"!small"];
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                }
            }else {
                cell.imageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
                
            }
            
        }
          cell.imageView.layer.masksToBounds = YES;
          [cell imageView].layer.cornerRadius = 30;
        break;
        
    case 1:
        
    [[cell textLabel]  setText:[_section2 objectAtIndex:indexPath.row]];
        
    break;
        default:
        [[cell textLabel]  setText:@"Unknown"];
            break;
        
    }
    // Configure the cell...
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [self configure];
            return;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showExit];
                    return;
                    break;
                case 1:
                    [self showCache];
                    return;
                    break;
                case 2:
                    return;
                    break;
                case 3:
                    [self showAbout];
                    return;
                    break;
                case 4:
                    [self showIssue];
                    return;
                    break;
            }
            return;
            break;
        default:
            break;
    }
}
-(void)showIssue{
    issueViewController *issue =[[issueViewController alloc] initWithNibName:@"issueViewController" bundle:nil];
     [self.navigationController pushViewController:issue animated:YES];
}
-(void)showAbout{
    AboutUsViewController *about = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
     [self.navigationController pushViewController:about animated:YES];
}
-(void)showCache{
    cacheViewController* cache =[[cacheViewController alloc] initWithNibName:@"cacheViewController" bundle:nil];
    
    [self.navigationController pushViewController:cache animated:YES];
}
-(void)configure{
    configureViewController *conf = [[configureViewController alloc] initWithNibName:@"configureViewController" bundle:nil];
//    conf.user = _responseUser.user;
    [self.navigationController pushViewController:conf animated:YES];

}
- (void)showExit {
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确认退出"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"退出",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self exitApplication];
    }else if (buttonIndex == 1) {
        return;
    }
}
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        [self saveUserDefaultsOwn];
        exit(0);
        
    }
    
}

//-(void)loadUserInfo{
//    NSDictionary *parameters=[_user toDictionary];
//    NSString *url =[NSString stringWithString:getUserInfoUrl];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
//    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
//    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
//    log(@"User Info is %@",info);
//    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
//    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
//    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
//    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//       _responseUser = [[ResponseUser alloc] initWithDictionary:data error:nil];
//        
//        [self.tableView reloadData];
//            // NSLog(@"USer is %@",_User);
//    log(@"User stat is %d,errcode is %@",_responseUser.stat,_responseUser.errcode);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
// }];
//}
- (void)saveUserDefaultsOwn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    [userDefaults setObject:cache forKey:LOGIN_INFO];
    [userDefaults setObject:cache forKey:REGISTE_INFO];
     [userDefaults setObject:cache forKey:@"cache"];
    [userDefaults synchronize];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
