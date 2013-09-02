//
//  TopsAddMeViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsAddMeViewController.h"
#import "TopsPeoplesCell.h"
#import "getAddMe.h"
//#import "AgreeOrRefuse.h"
@interface TopsAddMeViewController ()

@end

@implementation TopsAddMeViewController
{
    NSInteger *index_row;
}

@synthesize companys,names,roles,macs,mid;
@synthesize aor;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    aor = [[AgreeOrRefuse alloc]init];
    getAddMe *addMe = [[getAddMe alloc] init];
    [addMe getAddMe];
    NSLog(@"addMeDic=%@",addMe.addMeDic);
    if (addMe.addMeDic) {
        companys = [[NSMutableArray alloc] init];
        names = [[NSMutableArray alloc] init];
        roles = [[NSMutableArray alloc] init];
        macs = [[NSMutableArray alloc] init];
        mid = [[NSMutableArray alloc] init];
        for (NSDictionary * s in addMe.addMeDic) {
            [self.names addObject:[s objectForKey:@"name"]];
            [self.companys addObject:[s objectForKey:@"title"]];
            [self.roles addObject:[s objectForKey:@"post"]];
            [self.macs addObject:[s objectForKey:@"mac"]];
            [self.mid addObject:[s objectForKey:@"mid"]];
        }
       
    }else{
        NSLog(@"加我的人列表为空");
    }
 [addMe release];
}

-(IBAction)Refresh:(id)sender
{
    companys =nil;
    names =nil;
    roles =nil;
    macs =nil;
    mid = nil;
    getAddMe *addMe = [[[getAddMe alloc] init] autorelease];
    [addMe getAddMe];
    NSLog(@"addMeDic=%@",addMe.addMeDic);
    if (addMe.addMeDic) {
        companys = [[NSMutableArray alloc] init];
        names = [[NSMutableArray alloc] init];
        roles = [[NSMutableArray alloc] init];
        macs = [[NSMutableArray alloc] init];
        mid = [[NSMutableArray alloc] init];
        for (NSDictionary * s in addMe.addMeDic) {
            [self.names addObject:[s objectForKey:@"name"]];
            [self.companys addObject:[s objectForKey:@"title"]];
            [self.roles addObject:[s objectForKey:@"post"]];
            [self.macs addObject:[s objectForKey:@"mac"]];
            [self.mid addObject:[s objectForKey:@"mid"]];
        }
    }else{
        NSLog(@"加我的人列表为空");
    }
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [companys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topsPeoplesCell";
    TopsPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //初始化自定义的单元格cell
    //loadNibNamed的属性值必须是子类xib的名称，大小写必须严格一致
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"topsPeoplesCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.companyLabel.text=[companys objectAtIndex:indexPath.row];
    cell.nameLabel.text=[names objectAtIndex:indexPath.row];
    cell.roleLabel.text=[roles objectAtIndex:indexPath.row];
    
    return cell;

}


//当划过一行时，会在表视图单元行上添加删除按钮，并实现删除功能
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //        AgreeOrRefuse *aor = [[AgreeOrRefuse alloc] init];
        if ([aor agreeOrRefuse:[mid objectAtIndex:index_row] Result:@"2"]) {
            [self removeByIndexRow:index_row];
        }
        //        [self removeByIndexRow:indexPath.row];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index_row = indexPath.row;
    
    //选择单元行，行最右侧图标的样式的设置
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    //设置单元行选中后为蓝色背景的效果，YES:表示蓝背景不被显示
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //管理操作弹出框
    UIAlertView *messageAlert=[[UIAlertView alloc]initWithTitle:@"行选择" message:[names objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", @"拒绝", @"忽略",nil];
    [messageAlert show];
    [messageAlert release];
}

//    NSLog(@"@@@@@@@@@@@%@",[alertView title]);
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
    
        case 0: // 取消事件
            break;
            
        case 1: //同意
            if ([aor agreeOrRefuse:[mid objectAtIndex:index_row] Result:@"1"]) {
                NSLog(@"操作的行数:服务器端ID:%@#@#$@#$#@@#$tableView行号:%d",[mid objectAtIndex:index_row],(int)index_row);
                [self removeByIndexRow:index_row];
            }
            break;
            
        case 2: //拒绝
            if ([aor agreeOrRefuse:[mid objectAtIndex:index_row] Result:@"2"]) {
                [self removeByIndexRow:index_row];
            }

            break;
            
        case 3: //忽略
            break;
    }
}

//移除单元格，并更新tableview列表
-(void)removeByIndexRow:(NSInteger *)index_
{
    [companys removeObjectAtIndex:index_row];
    [names removeObjectAtIndex:index_row];
    [macs removeObjectAtIndex:index_row];
    [roles removeObjectAtIndex:index_row];
    [mid removeObjectAtIndex:index_row];
    //数据操作后，刷新tableView表视图
    [self.tableView reloadData];
}

//-(void)dealloc
//{
//    [companys release];
//    [names release];
//    [roles release];
//    [macs release];
//    [mid release];
//    [aor release];
//    [super dealloc];
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
@end
