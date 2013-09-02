//
//  TopsFriendsViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-3-28.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsFriendsViewController.h"
#import "TopsFriendsCell.h"
@interface TopsFriendsViewController ()

@end

@implementation TopsFriendsViewController


@synthesize names,sex,companys,roles,phones;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setValueOfTableCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 20;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [companys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topsFriendsCell";
    TopsFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"topsFriendsCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.fnameLabel.text=[names objectAtIndex:indexPath.row];
    cell.fcompanyLabel.text=[companys objectAtIndex:indexPath.row];
    cell.froleLabel.text=[roles objectAtIndex:indexPath.row];
    cell.fphoneLabel.text=[phones objectAtIndex:indexPath.row];
    
 
    if ([[sex objectAtIndex:indexPath.row] isEqualToString:@"M"]) {
        cell.fsexImageLabel.image=[UIImage imageNamed:@"male.png"];
    }else{
        cell.fsexImageLabel.image=[UIImage imageNamed:@"female.png"];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    UIAlertView *messageAlert=[[UIAlertView alloc]initWithTitle:[names objectAtIndex:indexPath.row] message:[phones objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

    [messageAlert show];
    
    //设置单元格最右端显示的图标
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //当单元行被选中时，不显示蓝色背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - my code
//表格数据组初始化
-(void)setValueOfTableCell
{
    companys=[[NSMutableArray alloc] initWithObjects:@"鼎晟中天科技发展有限公司", @"瑞来森会展服务有限公司",@"百度",@"腾讯控股有限公司",@"中国建设银行", nil];
    
    names=[[NSMutableArray alloc] initWithObjects:@"杨坤",@"赵薇",@"李彦宏",@"马化腾",@"中国", nil];
    sex=[[NSMutableArray alloc] initWithObjects:@"M",@"F",@"M",@"F",@"F", nil];
    phones=[[NSMutableArray alloc] initWithObjects:@"13598405623",@"14533267821",@"13544274567",@"15623417621",@"16523476521", nil];
    roles=[[NSMutableArray alloc] initWithObjects:@"程序员",@"项目经理",@"创始人",@"董事长",@"大股东",nil];
}
- (void)dealloc {
    
    [super dealloc];
}
@end
