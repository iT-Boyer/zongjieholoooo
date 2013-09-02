//
//  TopsHuiYiViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-27.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsHuiYiViewController.h"

#import "GetHuiYiList.h"
#import "HuiyiOfJionHttp.h"

#import "HuiyiName_Id.h"

@interface TopsHuiYiViewController ()

@end

@implementation TopsHuiYiViewController
{
    //存放搜索结果的数组
    NSArray *searchResults;
//    NSArray *searchResultsId;
}

@synthesize huiyiArray,huiyiId;


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

    GetHuiYiList *huiyiDao = [[GetHuiYiList alloc]init];
//    _huiyiDics = [[[NSMutableDictionary alloc] init] autorelease];
    [huiyiDao getHuiyilists];
    NSLog(@"解析会议列表:%d %@ ",[huiyiDao.huiyiDics count],huiyiDao.huiyiDics);
    if ([huiyiDao.huiyiDics count]>0) {
        huiyiArray =[[NSMutableArray alloc] init];
        huiyiId = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *s in huiyiDao.huiyiDics) {
            [huiyiArray addObject:[s objectForKey:@"title"]];
            [huiyiId addObject:[s objectForKey:@"id"]];
//            HuiyiName_Id *name_id = [[[HuiyiName_Id alloc] init] autorelease];
//            name_id._id = [s objectForKey:@"id"];
//            name_id.name = [s objectForKey:@"title"];
//            [huiyiArray addObject:name_id];
        }
        NSLog(@"huiyiArray 长度:%d 值%@",[huiyiArray count],[huiyiArray objectAtIndex:0]);
        [huiyiDao release];
    }
   
    
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
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if ([huiyiArray count] ==0) {
        return 1;
    }else{
    
        //判断是否是搜索结果的数据组
        if (tableView==self.searchDisplayController.searchResultsTableView) {
            [searchResults retain];
            return [searchResults count];
            
        }else{
            return [huiyiArray count];
        }
    
    }
    

    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([huiyiArray count] ==0) {
        cell.textLabel.text = @"离线登录";
    }else{
    // Configure the cell...
    //判断是否为搜索数组，在选择返回对象
        if (tableView==self.searchDisplayController.searchResultsTableView)
        {
            NSLog(@"searchResults的长度:%d",[searchResults count]);
            cell.textLabel.text=[searchResults objectAtIndex:indexPath.row];
        }else{
//          HuiyiName_Id *nameId = [huiyiArray objectAtIndex:indexPath.row];
//          cell.textLabel.text = nameId.name;
//          [nameId release];
            cell.textLabel.text = [huiyiArray objectAtIndex:indexPath.row];
        
        }
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
    
//    NSIndexPath *indexPath=nil;
    
    if ([self.searchDisplayController isActive]) {
        
        //indexPathForSelectedRow方法检索所选行的indePath属性值.
        //搜索结果显示在一个独立的表视图中...由于以上原因，必须做出相应的判断，获取到正确indexPath值
        indexPath=[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        [self submitHuiyiId:indexPath];
        
        //隐藏Tab bar只需要一句话
//        destViewController.hidesBottomBarWhenPushed=YES;
        
    }else{
        indexPath=[self.tableView indexPathForSelectedRow];
        [self submitHuiyiId:indexPath];

    }

}
-(void)submitHuiyiId:(NSIndexPath *)indexPath
{
    if([huiyiArray count]!=0){
        HuiyiOfJionHttp *huiyijoin = [[HuiyiOfJionHttp alloc] init];
        [huiyijoin submitHuiyiId:[huiyiId objectAtIndex:indexPath.row]];
    }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [self presentModalViewController:[storyboard instantiateInitialViewController] animated:YES];
        [storyboard release];

}



//实现搜索显示控制器(Search Display Controller)委托
//UISearchDisplayController类中提供了shouldReloadTableForSearchString:方法.该在搜索文本更改时，会自动被调用
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

//自定义搜索方法
//   1.Predicate是一个表达式，返回Boolean值...所以可以用NSPredicate格式指定查询条件，然后使用NSPredicate对象过滤数组中的数据
//   2.NSArray提供了filteredArrayUsingPredicat:方法，该方法返回一个新的数组，数组中包含了匹配指定的Predicate的对象
//   3.Predicate中的SELF关键字-SELF comtains[cd]%@ 指向比较对象(如菜单名称)。
//   4.操作符[cd]表示比较操作 -case 和 diacritic 不敏感
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate=[NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    searchResults=[huiyiArray filteredArrayUsingPredicate:resultPredicate];
}



@end
