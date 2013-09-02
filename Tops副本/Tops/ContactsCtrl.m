//
//  ContactsCtrl.m
//  Phone
//
//  Created by angel li on 10-9-13.
//  Copyright 2010 Lixf. All rights reserved.
//

#import "ContactsCtrl.h"
#import "ContactData.h"
#import "TopsAppDelegate.h"
#import "pinyin.h"
#import "TopsFriendsCell.h"
#import "ABGroup.h"

#import "Friend_del.h"
#import "UsersDao.h"

#define SETCOLOR(RED,GREEN,BLUE) [UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]

#define BARBUTTON(TITLE, SELECTOR)		[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]//UIBarButtonItem
#define NUMBER(X) [NSNumber numberWithInt:X]

@implementation ContactsCtrl

@synthesize DataTable;
@synthesize contacts;
@synthesize filteredArray;
@synthesize contactNameArray;
@synthesize contactNameDic;
@synthesize sectionArray;
@synthesize searchBar;
@synthesize searchDC;
@synthesize aBPersonNav;
@synthesize aBNewPersonNav;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	isGroup = NO;
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.delegate = self;
	self.DataTable.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
	
	
	NSMutableArray *filterearray =  [[NSMutableArray alloc] init];
	self.filteredArray = filterearray;
	[filterearray release];
	
	NSMutableArray *namearray =  [[NSMutableArray alloc] init];
	self.contactNameArray = namearray;
	[namearray release];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	self.contactNameDic = dic;
	[dic release];

}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[DataTable reloadData];
}


- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


-(void)initData{
    //从Address Book里得到所有联系人
//    self.contacts = [ContactData contactsArray];
    //从Address Book里得到会议通分组的所有联系人
	self.contacts = [ABGroup membersOfGroup:KPHONEGROUPNAME];
	if([contacts count] <1)
	{
		[contactNameArray removeAllObjects];
		[contactNameDic removeAllObjects];
		for (int i = 0; i < 27; i++) [self.sectionArray replaceObjectAtIndex:i withObject:[NSMutableArray array]];
		return;
	}
	[contactNameArray removeAllObjects];
	[contactNameDic removeAllObjects];
	for(ABContact *contact in contacts)
	{
		NSString *phone;
		NSArray *phoneCount = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneCount count] > 0)
		{
			NSDictionary *PhoneDic = [phoneCount objectAtIndex:0];
			phone = [ContactData getPhoneNumberFromDic:PhoneDic];
		}
		if([contact.contactName length] > 0)
			[contactNameArray addObject:contact.contactName];
		else
			[contactNameArray addObject:phone];
	}
	
	self.sectionArray = [NSMutableArray array];
	for (int i = 0; i < 27; i++) [self.sectionArray addObject:[NSMutableArray array]];
	for (NSString *string in contactNameArray)
	{
		if([ContactData searchResult:string searchText:@"曾"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"解"])
			sectionName = @"X";
		else if([ContactData searchResult:string searchText:@"仇"])
			sectionName = @"Q";
		else if([ContactData searchResult:string searchText:@"朴"])
			sectionName = @"P";
		else if([ContactData searchResult:string searchText:@"查"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"能"])
			sectionName = @"N";
		else if([ContactData searchResult:string searchText:@"乐"])
			sectionName = @"Y";
		else if([ContactData searchResult:string searchText:@"单"])
			sectionName = @"S";
		else
			sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
		[self.contactNameDic setObject:string forKey:sectionName];
		NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
		if (firstLetter != NSNotFound) [[self.sectionArray objectAtIndex:firstLetter] addObject:string];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	if(aTableView == self.DataTable) return 27;
	return 1;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
	if (aTableView == self.DataTable)  // regular table
	{
		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
		for (int i = 0; i < 27; i++)
			if ([[self.sectionArray objectAtIndex:i] count])
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
		//[indices addObject:@"\ue057"]; // <-- using emoji
		return indices;
	}
	else return nil; // search table
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (title == UITableViewIndexSearch)
	{
		[self.DataTable scrollRectToVisible:self.searchBar.frame animated:NO];
		return -1;
	}
	return [ALPHA rangeOfString:title].location;
}



- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	if (aTableView == self.DataTable)
	{
		if ([[self.sectionArray objectAtIndex:section] count] == 0) return nil;
		return [NSString stringWithFormat:@"%@", [[ALPHA substringFromIndex:section] substringToIndex:1]];
	}
	else return nil;
}

//通知表视图有多少行 
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	[self initData];
	// Normal table
   
	if (aTableView == self.DataTable)
        return [[self.sectionArray objectAtIndex:section] count];
	else
		[filteredArray removeAllObjects];
	// Search table
	for(NSString *string in contactNameArray)
	{
		NSString *name = @"";
		for (int i = 0; i < [string length]; i++)
		{
			if([name length] < 1)
				name = [NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:i])];
			else
				name = [NSString stringWithFormat:@"%@%c",name,pinyinFirstLetter([string characterAtIndex:i])];
		}
		if ([ContactData searchResult:name searchText:self.searchBar.text])
			[filteredArray addObject:string];
		else
		{
			if ([ContactData searchResult:string searchText:self.searchBar.text])
				[filteredArray addObject:string];
			else {
				ABContact *contact = [ContactData byNameToGetContact:string];
               
				NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
				NSString *phone = @"";
				
				if([phoneArray count] == 1)
				{
					NSDictionary *PhoneDic = [phoneArray objectAtIndex:0];
					phone = [ContactData getPhoneNumberFromDic:PhoneDic];
					if([ContactData searchResult:phone searchText:self.searchBar.text])
						[filteredArray addObject:string];
				}else  if([phoneArray count] > 1)
				{
					for(NSDictionary *dic in phoneArray)
					{
						phone = [ContactData getPhoneNumberFromDic:dic];
						if([ContactData searchResult:phone searchText:self.searchBar.text])
						{
							[filteredArray addObject:string];
							break;
						}
					}
				}
				
			}
		}
	}
	return self.filteredArray.count;
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar{
	self.searchBar.prompt = @"输入字母、汉字或电话号码搜索";
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar setText:@""];
	self.searchBar.prompt = nil;
	[self.searchBar setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.DataTable.tableHeaderView = self.searchBar;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Retrieve the crayon and its color
     //判断是否为搜索数组，在选择返回对象
	if (aTableView == self.DataTable)
    {
        static NSString *CellIdentifier = @"topsFriendsCell";
        TopsFriendsCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *contactName;
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"topsFriendsCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        //在特定的section里，找到对应的array,然后在array找到indexPath.row所在的内容 NSMutableArray
        NSMutableArray *array = [self.sectionArray objectAtIndex:indexPath.section];
		contactName = [array objectAtIndex:indexPath.row];
//        if ([contactName length]>0)
        cell.fnameLabel.text = [NSString stringWithCString:[contactName UTF8String] encoding:NSUTF8StringEncoding];
        ABContact *contact = [ContactData byNameToGetContact:contactName];
        if(contact)
        {
            NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
            if([phoneArray count] > 0)
            {
                NSDictionary *dic = [phoneArray objectAtIndex:0];
                NSString *phone = [ContactData getPhoneNumberFromDic:dic];
                cell.fphoneLabel.text = phone;
                //
                NSString *job = [ContactData getPhoneJobNameFromDic:dic];
                          NSLog(@"公司名称:%@",job);
                cell.fcompanyLabel.text = job;
                NSString *jobtitle=[ContactData getPhoneJobTitleFromDic:dic];
                cell.froleLabel.text = jobtitle;
                
                //通过uid删除数据库中的记录
                UsersDao *userDao = [[UsersDao alloc] init];
                NSString *contactId = [NSString stringWithFormat:@"%d",[contact recordID]];
                NSString *sex = [userDao selectSexByUid:contactId];
                if ([sex isEqualToString:@"F"]) {
                    cell.fsexImageLabel.image = [UIImage imageNamed:@"female.png"];
                }else if([sex isEqualToString:@"M"]){
                    cell.fsexImageLabel.image = [UIImage imageNamed:@"male.png"];
                }else{
                
                    cell.fsexImageLabel.image = [UIImage imageNamed:@"ic_launcher.png"];
                }
            }
        }
        else
            cell.detailTextLabel.text = @"";
        return cell;
    }
	else
    {
        NSString *contactName;
        UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"ContactCell"] autorelease];
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithCString:[contactName UTF8String] encoding:NSUTF8StringEncoding];
        ABContact *contact = [ContactData byNameToGetContact:contactName];
        if(contact)
        {
            //查询时，获取联系人的所有信息，和标签，打印出...
//            [contact emailDictionaries];
//            [contact urlDictionaries];
//            [contact phoneDictionaries];
//            [contact smsDictionaries];
//            [contact dateDictionaries];
            [contact addressDictionaries];
            NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
            if([phoneArray count] > 0)
            {
                NSDictionary *dic = [phoneArray objectAtIndex:0];
                NSString *phone = [ContactData getPhoneNumberFromDic:dic];
                cell.detailTextLabel.text = phone;
            }
        }
        else
            cell.detailTextLabel.text = @"";
        return cell;
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //显示一个具体联系人
	ABPersonViewController *pvc = [[[ABPersonViewController alloc] init] autorelease];

	
	NSString *contactName = @"";
	if (aTableView == self.DataTable)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	pvc.displayedPerson = contact.record;
    //支持编辑
	pvc.allowsEditing = YES;
    //设置导航条的标题
    pvc.title = contactName;
    //支持发短信，共享联系人，添加到个人收藏
    pvc.allowsActions = YES;
    
	pvc.personViewDelegate = self;
    
    //通讯录，自带导航条
    [self.navigationController pushViewController:pvc animated:YES];
    
    
    //自定义导航条
    //把联系人信息作为导航栏的根视图，才可以显示编辑按钮和 完成按钮，返回按钮
//	self.aBPersonNav = [[[UINavigationController alloc] initWithRootViewController:pvc] autorelease];
//    [self presentModalViewController:aBPersonNav animated:YES];
//	self.aBPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
//	pvc.navigationItem.leftBarButtonItem = BARBUTTON(@"返回", @selector(cancelBtnAction:));
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(aTableView == self.DataTable)
		// Return NO if you do not want the specified item to be editable.
		return YES;
	else
		return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *contactName = @"";
	if (aTableView == self.DataTable)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	
	if ([ModalAlert ask:@"真的要删除 %@?", contact.compositeName])
	{
		/*CATransition *animation = [CATransition animation];
         animation.delegate = self;
         animation.duration = 0.2;
         animation.timingFunction = UIViewAnimationCurveEaseInOut;
         animation.fillMode = kCAFillModeForwards;
         animation.removedOnCompletion = NO;
         animation.type = @"suckEffect";//110
         [DataTable.layer addAnimation:animation forKey:@"animation"];*/
		[[self.sectionArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        
        // 从通讯录中删除联联人
		[ContactData removeSelfFromAddressBook:contact withErrow:nil];
        
        //通过uid删除数据库中的记录
        UsersDao *userDao = [[UsersDao alloc] init];
        NSString *contactId = [NSString stringWithFormat:@"%d",[contact recordID]];
        NSLog(@"好友在通讯录中的唯一标识Id:%@",contactId);
        
        //获取好友的Uid 集合
        NSMutableArray * uids = [userDao selectValueByFieldName:@"Uid"];
        for (int i=0; i<[uids count]; i++) {
            NSLog(@"Uid%d:%@",i,[uids objectAtIndex:i]);
        }
        
        //获取数据库中好友的数据，赋值给user对象
        NSString *fid = [userDao selectFidByUid:contactId];
        NSLog(@"从数据库中获取到好友的Fid:%@",fid);
        
        //删除数据库中好友的数据
        if ([userDao deleteAtUid:contactId]) {
//            [userDao autorelease];
            NSLog(@"从数据库中删除联系人信息，成功 Id:%@",[NSString stringWithFormat:@"%@",contactId]);
        }
        
        //到服务器端解除好友关系
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"本人的MyID : %@",[userDefaults objectForKey:kMYID]);
        Friend_del *del = [[[Friend_del alloc] init] autorelease];
        if ([fid length]>0&&[[userDefaults objectForKey:kMYID] length]>0) {
            [del deleteByFid:fid MyId:[userDefaults objectForKey:kMYID]];
        }else{
            NSLog(@"本人Id或对方Id有误");
        }
        //刷新UI
		[DataTable reloadData];
	}
	[DataTable  setEditing:NO];
	editBtn.title = @"编辑";
	isEdit = NO;
}

/*
 -(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
 [DataTable.layer removeAllAnimations];
 [super.view.layer removeAllAnimations];
 }
 */

//点击电话号码内容时 事件处理...返回YES，拨打电话，返回NO,不操作...
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    //    if (property == 3)
    //    {
    //        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //电话号码
    //        NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifierForValue) autorelease];
    //    }
    
//	[self dismissModalViewControllerAnimated:YES];
	return YES;
}

- (void)cancelBtnAction:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


//全部联系人视图中 左上角加号按钮功能的实现
-(IBAction)addContactItemBtn:(id)sender{
	// create a new view controller
	ABNewPersonViewController *npvc = [[[ABNewPersonViewController alloc] init] autorelease];
	
	self.aBNewPersonNav = [[[UINavigationController alloc] initWithRootViewController:npvc] autorelease];
	self.aBNewPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
	ABContact *contact = [ABContact contact];
	npvc.displayedPerson = contact.record;
	npvc.newPersonViewDelegate = self;
	[self presentModalViewController:aBNewPersonNav animated:YES];
//    npvc.navigationItem.leftBarButtonItem = BARBUTTON(@"返回", @selector(addNewBackAction:));
}


- (void)addNewBackAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark NEW PERSON DELEGATE METHODS
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	if (person)
	{
		ABContact *contact = [ABContact contactWithRecord:person];
		//self.title = [NSString stringWithFormat:@"Added %@", contact.compositeName];
		if (![ABContactsHelper addContact:contact withError:nil])
		{
			// may already exist so remove and add again to replace existing with new
			[ContactData removeSelfFromAddressBook:contact withErrow:nil];
			[ABContactsHelper addContact:contact withError:nil];
		}
	}
	else
	{
	}
	[DataTable reloadData];
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)editContactItemBtn:(id)sender
{
	if(isEdit == NO)
	{
		[DataTable setEditing:YES];
		editBtn.title = @"完成";
	}else {
		[DataTable  setEditing:NO];
		editBtn.title = @"编辑";
	}
	isEdit = !isEdit;
}

//- (void)cancelEdit:(id)sender
//{
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//
//- (void)okEdit:(id)sender
//{
//    [[self editButtonItem].target performSelector:[personViewVC editButtonItem].action];
//    NSLog(@"okedit");
//    [self cancelEdit:nil];
//}


-(IBAction)groupBtnAction:(id)sender{
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
	[sectionArray release];
    [super dealloc];
}
@end

