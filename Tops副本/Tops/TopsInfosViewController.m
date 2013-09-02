//
//  TopsInfosViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-7.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsInfosViewController.h"
#import "InfosDao.h"
#import "Infos.h"
#import "TopsInfosDetail_webViewController.h"
@interface TopsInfosViewController ()

@end

@implementation TopsInfosViewController

@synthesize infos,titles,times;
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
    [self refresh:nil];
    
}

-(IBAction)refresh:(id)sender
{
    infos = nil;
    InfosDao *infosDao = [[InfosDao alloc]init];
    self.infos = [infosDao resultSet];
    NSLog(@"公告信息的条数:%d",[self.infos count]);
    [infosDao release];
    [self.tableView reloadData];
}

//-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
//{
//    self = [super initWithNibName:nibName bundle:nibBundle];
//    if (self)
//    {
//        self.title = @"Title";
//        self.tabBarItem.image = [UIImage imageNamed:@"image.png"];
//        self.tabBarItem.badgeValue=5;
//    }
//    return self;
//}


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
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.infos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoscell"];
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"infoscell"] autorelease];

//     static NSString *CellIdentifier = @"ContactCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    Infos *info = [[Infos alloc] init];
    Infos *info = [self.infos objectAtIndex:indexPath.row];
    cell.textLabel.text=info.title;
    cell.detailTextLabel.text = info.time;
//    [info release];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        InfosDao *infosDao = [[[InfosDao alloc] init] autorelease];
        Infos *info = [self.infos objectAtIndex:indexPath.row];
        int iid = [info getIid];
        if ([infosDao deleteAtIndex:iid]) {
            NSLog(@"公告信息，移除成功");
            [self.infos removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else
        {
        NSLog(@"公告信息，移除失败");
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Navigation logic may go here. Create and push another view controller.
//    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
//        [self performSegueWithIdentifier:@"infosDetail_segue_web" sender:self];
//    }
//}

//添加一个联线(Segue),连接原型单元格(Prototype Cell)和新添加的视图控制器。添加一个联线(Segue)对象是非常简单的，按住Control键，点击原型单元格(Prototype Cell),并拖拉到视图控制器，释放按钮,弹出窗口显示 3种类型的联线,分别为 Push、Modal 和 Custom。之前解释过,联线(Segue)定义了两个场景之间的过渡类型。对亍标准的导航, 我们使用 Push。一旦选择,Xcode 自劢使用 Push 联线连接两个场景。
//在联线的源视图控制器中，实现prepareForSegue:sender:方法、
//        1.首先验证segue的标示符，在本例中，识别符为 showRecipeDetail.
//        2.在获取选择的行:tableView:indexPathForSelectedRow
//        3.一旦获取到行将传递给segue.destinationViewController获取到的目的视图控制器:本例中即为:RecipeDetailViewController视图控制器
//        4。一个segue对象包含了需要在转换结束后在视图控制器中显示的内容

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"infosDetail_segue_web"]) {
        NSIndexPath *indexPath=nil;
//        TopsInfosDetailViewController *infosDetailcontrl = segue.destinationViewController;
//        indexPath = [self.tableView indexPathForSelectedRow];
//        Infos *info = [self.infos objectAtIndex:indexPath.row];
//        NSLog(@"查看公告详情的标题:%@",info.title);
//        infosDetailcontrl.infotitle=info.title;
//        infosDetailcontrl.infocontent=info.content;
        
        TopsInfosDetail_webViewController *infosDetailcontrl_web = segue.destinationViewController;
        indexPath = [self.tableView indexPathForSelectedRow];
        Infos *info = [self.infos objectAtIndex:indexPath.row];
        NSLog(@"查看公告详情的标题:%@",info.title);
        infosDetailcontrl_web.infotitle=info.title;
        infosDetailcontrl_web.infosId=info.content;
    }

}
@end
