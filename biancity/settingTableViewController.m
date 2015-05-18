//
//  settingTableViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/8.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "settingTableViewController.h"
#import "settingTableViewCell.h"

@interface settingTableViewController ()
@property (nonatomic,strong) NSMutableArray *section1;
@property (nonatomic,strong) NSMutableArray *section2;

@end

@implementation settingTableViewController
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTableViewCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        
    case 0://对应各自的分区
        
        [[cell textLabel]  setText:_user.name];//给cell添加数据
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            cell.imageView.layer.masksToBounds = YES;
            [cell imageView].layer.cornerRadius = 20;
            NSLog(@"w %f,h %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
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
            return;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showExit];
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
                default:
                    break;
            }
            return;
            break;
        default:
            break;
    }
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
        
        exit(0);
        
    }
    
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
