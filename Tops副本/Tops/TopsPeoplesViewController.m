//
//  TopsPeoplesViewController.m
//  Tops
//
//  Created by 鼎晟中天 on 13-3-18.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsPeoplesViewController.h"
#import "TopsPeoplesCell.h"
#import "ContactsCtrl.h"
#import "getPeoplesOnline.h"

#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"

#import "addPeopleToFriend.h"
#import "getCompanyDetail.h"

#import "TopsCompanyDetailViewController.h"
#import "TopsAppDelegate.h"
@implementation TopsPeoplesViewController
{
//    NSArray *companys;
//    NSArray *names;
//    NSArray *roles;
//    NSArray *state;
    //Timer的使用：
//    NSTimer *connectionTimer;  //timer对象
    BOOL done;
}
@synthesize companys,names,roles,macs,mid,states;

@synthesize companysDic = _companysDic;
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

    [self setArrayOfTable];
    
}

//表格数据组初始化
-(void)setArrayOfTable
{
    companys =nil;
    names =nil;
    roles =nil;
    macs =nil;
    mid = nil;
    states=nil;
    getPeoplesOnline *peopleOnline = [[[getPeoplesOnline alloc] init] autorelease];
    [peopleOnline getPeoplesOfOnline];
    NSLog(@"peopleOnline=%@",peopleOnline.peoplesOfOnline);
    if (peopleOnline.peoplesOfOnline) {
        companys = [[NSMutableArray alloc] init];
        names = [[NSMutableArray alloc] init];
        roles = [[NSMutableArray alloc] init];
        macs = [[NSMutableArray alloc] init];
        mid = [[NSMutableArray alloc] init];
        states = [[NSMutableArray alloc] init];
        for (NSDictionary * s in peopleOnline.peoplesOfOnline) {
            [self.names addObject:[s objectForKey:@"name"]];
            [self.companys addObject:[s objectForKey:@"title"]];
            [self.roles addObject:[s objectForKey:@"post"]];
            [self.macs addObject:[s objectForKey:@"mac"]];
            [self.mid addObject:[s objectForKey:@"mid"]];
            [self.states addObject:@"1"];
        }
        [self.tableView reloadData];
    }else{
        NSLog(@"%@",[NSString stringWithFormat:@"在线所有人列表为空"]);
    }

}


//搜索附近蓝牙
- (IBAction) connectionButtonTapped:(id) sender
{
    
    
    // allocate and setup the peer picker controller
	GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
    
    [self setArrayOfTable];
    
//++++++++++++++++++++++++++++++++++++++
    //定时操作 10s中，自动隐藏提示框
    //Timer的使用：
    NSTimer *connectionTimer;  //timer对象
    //实例化timer
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop]addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    //用timer作为延时的一种方法
    done = NO;
    do{
        //设置1秒之后
//       NSDate*pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
//       [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; 
    }while(!done);
//++++++++++++++++++++++++++++++++++++++    
    //隐藏提示窗口
   [picker dismiss];
    

}
//timer调用函数
-(void)timerFired:(NSTimer *)timer{
    done =YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

//UITableViewDelegate负责处理UITableView的表现，协议中的可选方法让你管理表行的高度，配置节点头部和底部，对表单重新排列等等.
//在配置UITableView时，需要强制实现两个方法:告诉表示图显示多少行数据和每一行中的数据值
//tableView:numberOfRowsInSection :返回数组中元素个数，告诉表示图选择了多少条数据行...
//tableView:cellForRowAtIndexPath :每一次数据行显示时，都会调用cellForRowAtIndexPath

//通知table表示图，选择了多少数据行，返回tableData数组中元素的个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [companys count];
}

//返回单元格的高度

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 78;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topsPeoplesCell";
    
//    TopsPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
    if ([[self.states objectAtIndex:indexPath.row]isEqualToString:@"1"]) {
        cell.sexImage.image = [UIImage imageNamed:@"default_shake.png"];
    }else{
        cell.sexImage.image = [UIImage imageNamed:@"request_shake.png"];
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

    UIAlertView *alertView = nil;
        
        addPeopleToFriend *peopleToFriend = [[addPeopleToFriend alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //获取数据
        NSString *mac_imsi = [userDefaults objectForKey:BlueToothMACKEY];
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = @"忽略";
        cancelItem.action = ^
        {
            //为NO时的处理
            
        };
        
        
        RIButtonItem *addPeopleToFriendItem = [RIButtonItem item];
        addPeopleToFriendItem.label = @"添加为好友";
        addPeopleToFriendItem.action = ^
        {
//                [alertView setHidden:TRUE];
                //state=0添加好友 1，别人添加我 2,
                [peopleToFriend addPeopleToFriend:mac_imsi FriendMac:[macs objectAtIndex:indexPath.row] State:@"0"];
                [self.states replaceObjectAtIndex:indexPath.row withObject:@"2"];

//            TopsAppDelegate *app = [[TopsAppDelegate alloc] init];
//            app.topsPeoplesCtlr = self;
                [self.tableView reloadData];
//                [alertView release];
        };
    
        getCompanyDetail *companyDetail = [[getCompanyDetail alloc] init];
        
        RIButtonItem *companyDetailItem = [RIButtonItem item];
        companyDetailItem.label = @"查看公司信息";
        companyDetailItem.action = ^
        {
            [alertView setHidden:TRUE];
//            [alertView release];
            [companyDetail getCompanyDetailDic:[companys objectAtIndex:indexPath.row]];
            self.companysDic = companyDetail.companyDetailDic;
            [self performSegueWithIdentifier:@"companyDetail" sender:self];
        };
    
    if ([[self.states objectAtIndex:indexPath.row]isEqualToString:@"2"]) {
        alertView = [[UIAlertView alloc] initWithTitle:@"查看公司详情"
                                               message:[NSString stringWithFormat:@"\n%@",[companys objectAtIndex:indexPath.row]]
                                      cancelButtonItem:cancelItem
                                      otherButtonItems:companyDetailItem, nil];
    }else{
        alertView = [[UIAlertView alloc] initWithTitle:@"对附近的人操作"
                                               message:[NSString stringWithFormat:@"\n%@",[names objectAtIndex:indexPath.row]]
                                      cancelButtonItem:cancelItem
                                      otherButtonItems:addPeopleToFriendItem,companyDetailItem, nil];
    }
    [alertView show];
    [alertView release];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"companyDetail"]) {
        TopsCompanyDetailViewController *companyDetailcontrl = segue.destinationViewController;
        companyDetailcontrl.title = [names objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        if (self.companysDic) {
            for (NSDictionary * s in self.companysDic) {
                companyDetailcontrl.companyname = [s objectForKey:@"title"];
                companyDetailcontrl.cphone = [s objectForKey:@"tel"];
                companyDetailcontrl.curl = [s objectForKey:@"wangzhi"];
                companyDetailcontrl.caddress = [s objectForKey:@"address"];
                companyDetailcontrl.cfax = [s objectForKey:@"chuanzhen"];
                companyDetailcontrl.cemail = [s objectForKey:@"email"];
                companyDetailcontrl.miaoshu = [s objectForKey:@"miaoshu"];
            }
        }else{
            NSLog(@"公司详情为空");
        }
    }
    
}
- (void)dealloc {
    
    [_searchButton release];
    [super dealloc];
}
@end
