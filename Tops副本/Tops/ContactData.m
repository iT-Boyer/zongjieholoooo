//
//  ContactData.m
//  Phone
//
//  Created by angel li on 10-9-20.
//  Copyright 2010 Lixf. All rights reserved.
//

#import "ContactData.h"
#import "TopsAppDelegate.h"
#import "Users.h"
#import "ABGroup.h"

#import "DownLoadPhoto.h"
@implementation ContactData

//从Address Book里得到所有联系人
+ (NSArray *) contactsArray
{
	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
	[thePeople release];
	return array;
}

//以号码来检测通讯录内是否已包含该联系人
+ (NSDictionary *) hasContactsExistInAddressBookByPhone:(NSString *)phone{
	NSString *PhoneNumber = nil;
	NSString *PhoneLabel = nil;
	NSString *PhoneName = nil;
	NSArray *contactarray = [ContactData contactsArray];
	for(int i=0; i<[contactarray count]; i++)
	{
		ABContact *contact = [contactarray objectAtIndex:i];
		NSArray *phoneCount = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneCount count] > 0)
		{
			NSDictionary *PhoneDic = [phoneCount objectAtIndex:0];
			PhoneNumber = [ContactData getPhoneNumberFromDic:PhoneDic];
			PhoneLabel = [ContactData getPhoneLabelFromDic:PhoneDic];
			PhoneName = contact.contactName;
			if([PhoneNumber isEqualToString:phone])
			{
				NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PhoneName,KPHONENAMEDICDEFINE,PhoneNumber,KPHONENUMBERDICDEFINE,PhoneLabel,KPHONELABELDICDEFINE,nil ];
				return dic;
			}
		}
	}
	return nil;
}


//通过号码得到该联系人
+(ABContact *) byPhoneNumberAndLabelToGetContact:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [aLabel isEqualToString:label])
				return (ABContact *)contast;
		}
	}
	return nil;
}

//通过姓名与号码得到该联系人
+(ABContact *) byPhoneNumberAndNameToGetContact:(NSString *)name withPhone:(NSString *)phone{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
		//	NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [name isEqualToString:contast.contactName])
				return (ABContact *)contast;
		}
	}
	return nil;
}

//通过姓名得到该联系人
+(ABContact *) byNameToGetContact:(NSString *)name{
    //获取所有联系人时
//    NSArray *array = [ContactData contactsArray];
    //获取会议通联系人时
	NSArray *array = [ABGroup membersOfGroup:KPHONEGROUPNAME];
//    NSLog(@"通过姓名，遍历所有联系人，得到某一联系人");
	for(ABContact * contast in array)
	{
		if([contast.contactName isEqualToString:name])
			return (ABContact *)contast;
	}
	return nil;
}

//通过号码得到该联系人
+(ABContact *) byPhoneNumberlToGetContact:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			//NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [label isEqualToString:@"未知"])
				return (ABContact *)contast;
		}
	}
	return nil;
}


//得到联系人的号码组与Label组
+(NSArray *) getPhoneNumberAndPhoneLabelArray:(ABContact *) contact
{
	NSMutableDictionary *phoneDic = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableArray *phoneArray = [[[NSMutableArray alloc] init] autorelease];
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(contact.record, kABPersonPhoneProperty);
	int i;
	for (i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
		NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
		NSString *label =  [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i) autorelease];
		phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:contact.contactName,KPHONENAMEDICDEFINE,phone,KPHONENUMBERDICDEFINE,label,KPHONELABELDICDEFINE,contact.organization,KPHONEJOBNAMEDICDEFINE,contact.jobtitle,KPHONEJOBTILTEDICDEFINE,nil];
		[phoneArray addObject:phoneDic];
	}
	return phoneArray;
	CFRelease(phoneMulti);
}

//得到联系人的号码组与Label组
+(NSArray *) getPhoneNumberAndPhoneLabelArrayFromABRecodID:(ABRecordRef)person withABMultiValueIdentifier:(ABMultiValueIdentifier)identifierForValue
{
	NSString *nameStr = (NSString *)ABRecordCopyCompositeName(person);
	NSMutableDictionary *phoneDic = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableArray *phoneArray = [[[NSMutableArray alloc] init] autorelease];
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifierForValue) autorelease];
	NSString *label =  [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, identifierForValue) autorelease];
	phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,KPHONENAMEDICDEFINE,phone,KPHONENUMBERDICDEFINE,label,KPHONELABELDICDEFINE,nil];
	[phoneArray addObject:phoneDic];
	CFRelease(phoneMulti);
	return phoneArray;
}


//从所存的辞典中得到当前联系人的电话号码
+(NSString *) getPhoneNumberFromDic:(NSDictionary *) Phonedic
{
	NSString * phoneNumber = [Phonedic objectForKey:KPHONENUMBERDICDEFINE];
	return [ContactData getPhoneNumberFomat:phoneNumber];
}

//从所存的辞典中得到当前联系人的姓名
+(NSString *) getPhoneNameFromDic:(NSDictionary *) Phonedic
{
	NSString * phoneName = [Phonedic objectForKey:KPHONENAMEDICDEFINE];
	return phoneName;
}

//从所存词典中得到当前联系人的公司名称
+(NSString *)getPhoneJobNameFromDic:(NSDictionary *)Phonedic
{
    return [Phonedic objectForKey:KPHONEJOBNAMEDICDEFINE];
}

//从所存词典中得到当前联系人的职位名称
+(NSString *)getPhoneJobTitleFromDic:(NSDictionary *)Phonedic
{
    NSString * jobtitle = [Phonedic objectForKey:KPHONEJOBTILTEDICDEFINE];
    return jobtitle;
}
//从所存的辞典中得到当前联系人的Label
+(NSString *) getPhoneLabelFromDic:(NSDictionary *) Phonedic
{
	NSString * PhoneLabel = [Phonedic objectForKey:KPHONELABELDICDEFINE];
	if([PhoneLabel isEqualToString:@"_$!<Mobile>!$_"])
		PhoneLabel = @"移动电话";
	else if([PhoneLabel isEqualToString:@"_$!<Home>!$_"])
		PhoneLabel = @"住宅";
	else if([PhoneLabel isEqualToString:@"_$!<Work>!$_"])
		PhoneLabel = @"工作";
	else if([PhoneLabel isEqualToString:@"_$!<Main>!$_"])
		PhoneLabel = @"主要";
	else if([PhoneLabel isEqualToString:@"_$!<HomeFAX>!$_"])
		PhoneLabel = @"住宅传真";
	else if([PhoneLabel isEqualToString:@"_$!<WorkFAX>!$_"])
		PhoneLabel = @"工作传真";
	else if([PhoneLabel isEqualToString:@"_$!<Pager>!$_"])
		PhoneLabel = @"传呼";
	else if([PhoneLabel isEqualToString:@"_$!<Other>!$_"])
		PhoneLabel = @"其它";
	return PhoneLabel;
}

//向当前联系人表中插入一条电话记录
+ (BOOL)addPhone:(ABContact *)contact phone:(NSString*)phone{
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    CFErrorRef anError = NULL;
    
    // The multivalue identifier of the new value isn't used in this example,
    // multivalueIdentifier is just for illustration purposes.  Real-world
    // code can use this identifier to do additional work with this value.
    ABMultiValueIdentifier multivalueIdentifier;
    
    if (!ABMultiValueAddValueAndLabel(multi, (CFStringRef)phone, kABPersonPhoneMainLabel, &multivalueIdentifier)){
        CFRelease(multi);
        return NO;
    }
	
    if (!ABRecordSetValue(contact.record, kABPersonPhoneProperty, multi, &anError)){
        CFRelease(multi);
        return NO;
    }
    CFRelease(multi);
    return YES;
}

//号码显示格式
+ (NSString *)getPhoneNumberFomat:(NSString *)phone{
	if([phone length] <1)
		return nil;
	NSString* telNumber = @"";
	for (int i=0; i<[phone length]; i++) {
		NSString* chr = [phone substringWithRange:NSMakeRange(i, 1)];
		if([ContactData doesStringContain:@"0123456789" Withstr:chr]) {
			/*if([telNumber length] == 3 || [telNumber length] == 8)
			 telNumber = [telNumber stringByAppendingFormat:@"-%@", chr];
			 else
			 telNumber = [telNumber stringByAppendingFormat:@"%@", chr];*/
			telNumber = [telNumber stringByAppendingFormat:@"%@", chr];
		}
	}
	return telNumber;
}

//检测字符
+ (BOOL)doesStringContain:(NSString* )string Withstr:(NSString*)charcter{
	if([string length] < 1)
		return FALSE;
	for (int i=0; i<[string length]; i++) {
		NSString* chr = [string substringWithRange:NSMakeRange(i, 1)];
		if([chr isEqualToString:charcter])
			return TRUE;
	}
	return FALSE;
}


+(NSString *)equalContactByAddressBookContacts:(NSString *)name withPhone:(NSString *)phone withLabel:(NSString *)label PhoneOrLabel:(BOOL)isPhone withFavorite:(BOOL)isFavorite
{
	ABContact *contact = nil;
	NSArray *array;
	NSString *phoneNumber = @"";
	NSString *phoneLabel = @"";
	if(isFavorite)
		contact = [ContactData byNameToGetContact:name];
	if(!contact)
		contact = [ContactData byPhoneNumberAndLabelToGetContact:phone withLabel:label];
	if(!contact)
		contact = [ContactData byPhoneNumberAndNameToGetContact:name withPhone:phone];
	if([label isEqualToString:@"未知"] && contact == nil)
		contact = [ContactData byPhoneNumberlToGetContact:phone withLabel:label];
	if(contact)
	{
		array = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
	}
	if(contact == nil)
		return nil;
	if([array count] == 1)
	{
		NSDictionary *PhoneDic = [array objectAtIndex:0];
		phoneNumber = [ContactData getPhoneNumberFromDic:PhoneDic];
		phoneLabel = [ContactData getPhoneLabelFromDic:PhoneDic];
	}else  if([array count] > 1)
	{
		for(NSDictionary *dic in array)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([phone isEqualToString:aPhone] && [label isEqualToString:aLabel])
			{
				phoneNumber = aPhone;
				phoneLabel = aLabel;
				break;
			}
		}
	}
	if(isPhone)
		return phoneNumber;
	else
		return phoneLabel;
}


+(NSString *)getContactsNameByPhoneNumberAndLabel:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [aLabel isEqualToString:label])
				return contast.contactName;
		}
	}
	return nil;	
}


// 从通讯录中删除联联人
+(BOOL) removeSelfFromAddressBook:(ABContact *)contact withErrow:(NSError **) error
{
	if (!ABAddressBookRemoveRecord(addressBook, contact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook,  (CFErrorRef *) error);
}

//搜索返回结果
+(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

//删除所有联系人
//+(BOOL)deleteAll
//{
//    CFArrayRef people=ABAddressBookCopyArrayOfAllPeople(addressBook);
//    CFIndex contactsCount=ABAddressBookGetPersonCount(addressBook);
//    for (int i=0; i<contactsCount;i++)
//    {
//        ABRecordRef person1=CFArrayGetValueAtIndex(people, i);
//        ABAddressBookRemoveRecord(addressBook, person1, nil);
//        ABAddressBookSave(addressBook, nil);
//    }
//    return NO;
//}


//使用封装好的类ABContact添加联系人
//    NSArray *aa = [[NSArray alloc] initWithObjects:<#(id), ...#>, nil];
//    NSDictionary dic = [[NSDictionary alloc]initWithObjectsAndKeys:<#(id), ...#>, nil];
//    CFStringRef a = CFSTR("a");
//    [ABContact smsWithService:CFSTR("QQ") andUser:user.msnqq];
+(NSString *)addABContactToGroup:(Users*)user
{
    //新建联系人
    ABContact *person = [ABContact contact];

    [person setFirstname:user.username];
//    [person setLastname:user.username];
    [person setJobtitle:user.role];
    [person setOrganization:user.company];
    
    NSMutableArray *arrayOfDic = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //添加邮箱信息
    // kABWorkLabel, kABHomeLabel, kABOtherLabel
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.email andLabel:CFSTR("_$!<Home>!$_")]];
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.cemail andLabel:CFSTR("_$!<Work>!$_")]];
    [person setEmailDictionaries:arrayOfDic];
    [arrayOfDic removeAllObjects];

    //添加手机号信息
    // kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonPhoneMobileLabel, kABPersonPhoneIPhoneLabel, kABPersonPhoneMainLabel
	// kABPersonPhoneHomeFAXLabel, kABPersonPhoneWorkFAXLabel, kABPersonPhonePagerLabel
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.tel andLabel:CFSTR("iPhone")]];
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.cphone andLabel:CFSTR("_$!<Work>!$_")]];
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.cfax andLabel:CFSTR("_$!<WorkFAX>!$_")]];
    [person setPhoneDictionaries:arrayOfDic];
    [arrayOfDic removeAllObjects];

    //msnqq
    // kABWorkLabel, kABHomeLabel, kABOtherLabel,
	// kABPersonInstantMessageServiceKey, kABPersonInstantMessageUsernameKey
	// kABPersonInstantMessageServiceYahoo, kABPersonInstantMessageServiceJabber
	// kABPersonInstantMessageServiceMSN, kABPersonInstantMessageServiceICQ
	// kABPersonInstantMessageServiceAIM,
     BOOL msn = [user.msnqq hasSuffix:@".com"] == 1 ?  YES : NO;
    if (!msn) {
        [arrayOfDic addObject:[ABContact dictionaryWithValue:[ABContact smsWithService:CFSTR("QQ") andUser:user.msnqq] andLabel:CFSTR("_$!<Work>!$_")]];
    }else{
        [arrayOfDic addObject:[ABContact dictionaryWithValue:[ABContact smsWithService:CFSTR(" MSN") andUser:user.msnqq] andLabel:CFSTR("_$!<Work>!$_")]];
    }
    [person setSmsDictionaries:arrayOfDic];
    [arrayOfDic removeAllObjects];

    //添加公司地址
    // kABPersonAddressStreetKey, kABPersonAddressCityKey, kABPersonAddressStateKey
	// kABPersonAddressZIPKey, kABPersonAddressCountryKey, kABPersonAddressCountryCodeKey
    [arrayOfDic addObject:[ABContact dictionaryWithValue:[ABContact addressWithStreet:user.caddress withCity:@"" withState:@"" withZip:@"" withCountry:@"" withCode:@""] andLabel:CFSTR("_$!<Work>!$_")]];
    [person setAddressDictionaries:arrayOfDic];
    [arrayOfDic removeAllObjects];


    //添加公司主页
    // kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonHomePageLabel
    [arrayOfDic addObject:[ABContact dictionaryWithValue:user.cweb andLabel:CFSTR("_$!<HomePage>!$_")]];
    [person setUrlDictionaries:arrayOfDic];

    
    //添加头像
    if (![user.photo isEqualToString:@"pic"]) {
        
        NSString *urlHttpPath = [NSString stringWithFormat:@"%@%@",URL_,user.photo];
        NSLog(@"好友的头像图片：%@",urlHttpPath);
        NSString *imgName = [user.photo stringByReplacingOccurrencesOfString:@"ClientPic/" withString:@""];
        
        NSString *urlPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgName];
        NSLog(@"好友头像本地路径:%@",urlPath);
        DownLoadPhoto *downPhoto = [[DownLoadPhoto alloc] init];
        [downPhoto downLoadPhoto:urlHttpPath ImgPath:urlPath];
        [person setImage:downPhoto.photo];
        
        [downPhoto release];

    }
       // 将新建的联系人添加到通讯录中
//    ABAddressBookAddRecord(addressBook, person, NULL);

    ABGroup *groupOfTop = [ABGroup initGroupWithGroupName:KPHONEGROUPNAME];
    NSLog(@"分组的名称:%@",[groupOfTop name]);
    
//    if ([groupOfTop addMember:person withError:nil]) {
//        // 保存通讯录数据
//          ABAddressBookSave(addressBook, NULL);
//          return YES;
//    }
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBook, person.record, NULL);
    ABGroupAddMember(groupOfTop.record, person.record, NULL);
    
    NSString * UID =nil;
    // 保存通讯录数据
    ABAddressBookSave(addressBook, NULL);
    UID = [NSString stringWithFormat:@"%d",[person recordID]];
    NSLog(@"返回 ABRecordID ，代表了 记录在底层数据库中的ID号。具有唯一性%@",UID);
    [arrayOfDic release];
    return UID;
}



+(BOOL)addPhoneToGroupOfTops:(Users *)user
{
    ABRecordRef person = ABPersonCreate();
    // 保存到联系人对象中，每个属性都对应一个宏，例如：kABPersonFirstNameProperty
    // 设置firstName属性
    ABRecordSetValue(person, kABPersonFirstNameProperty,(CFStringRef)user.username, NULL);
    // 设置lastName属性
    ABRecordSetValue(person, kABPersonLastNameProperty, (CFStringRef)user.username, NULL);
    //设置organization公司
     ABRecordSetValue(person, kABPersonOrganizationProperty, (CFStringRef)user.company, NULL);
    //设置jobtitle工作
     ABRecordSetValue(person, kABPersonJobTitleProperty, (CFStringRef)user.role, NULL);
    //设置department部门
     ABRecordSetValue(person, kABPersonDepartmentProperty, (CFStringRef)user.role, NULL);

    
    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
    ABMultiValueRef mv =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    // 电话号码数组
    NSArray *phones = [NSArray arrayWithObjects:user.tel,user.cphone,nil];
    // 电话号码对应的名称
    NSArray *labels = [NSArray arrayWithObjects:@"iphone",@"home",nil];
    // 添加电话号码与其对应的名称内容
    for (int i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(CFStringRef)[phones objectAtIndex:i], (CFStringRef)[labels objectAtIndex:i], &mi);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
    // 释放该数组
    if (mv) {
        CFRelease(mv);
    }
    
    //设置email
    // kABWorkLabel, kABHomeLabel, kABOtherLabel
    ABMultiValueRef mv1 =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSArray *email = [NSArray arrayWithObjects:user.email,user.cemail,nil];
    NSArray *elabels = [NSArray arrayWithObjects:@"kABHomeLabel",@"kABWorkLabel",nil];
    for (int i = 0; i < [email count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(CFStringRef)[email objectAtIndex:i], (CFStringRef)[elabels objectAtIndex:i], &mi);
    }
    ABRecordSetValue(person, kABPersonEmailProperty, mv1, NULL);
    // 释放该数组
    if (mv1) {
        CFRelease(mv1);
    }
    //设置地址
    //添加公司地址
    // kABPersonAddressStreetKey, kABPersonAddressCityKey, kABPersonAddressStateKey
	// kABPersonAddressZIPKey, kABPersonAddressCountryKey, kABPersonAddressCountryCodeKey
    ABMultiValueRef mv2 =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSArray *address = [NSArray arrayWithObjects:user.address,user.caddress,nil];
    NSArray *alabels = [NSArray arrayWithObjects:@"kABPersonAddressStreetKey",@"kABPersonAddressStateKey",nil];
    for (int i = 0; i < [address count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv2,(CFStringRef)[address objectAtIndex:i], (CFStringRef)[alabels objectAtIndex:i], &mi);
    }
    ABRecordSetValue(person, kABPersonAddressProperty, mv2, NULL);
    // 释放该数组
    if (mv2) {
        CFRelease(mv2);
    }
    
    //添加公司主页
    // kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonHomePageLabel
    ABMultiValueRef mv3 =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSArray *urls = [NSArray arrayWithObjects:user.cweb,nil];
    NSArray *ulabels = [NSArray arrayWithObjects:@"kABWorkLabel",nil];
    for (int i = 0; i < [urls count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv3,(CFStringRef)[urls objectAtIndex:i], (CFStringRef)[ulabels objectAtIndex:i], &mi);
    }
    ABRecordSetValue(person, kABPersonURLProperty, mv3, NULL);
    // 释放该数组
    if (mv3) {
        CFRelease(mv3);
    }
    
    //msnqq
    // kABWorkLabel, kABHomeLabel, kABOtherLabel,
	// kABPersonInstantMessageServiceKey, kABPersonInstantMessageUsernameKey
	// kABPersonInstantMessageServiceYahoo, kABPersonInstantMessageServiceJabber
	// kABPersonInstantMessageServiceMSN, kABPersonInstantMessageServiceICQ
	// kABPersonInstantMessageServiceAIM
    ABMultiValueRef mv4 =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSArray *Msnqq = [NSArray arrayWithObjects:user.msnqq,nil];
    NSArray *mlabels = [NSArray arrayWithObjects:@"kABPersonInstantMessageServiceMSN",nil];
    for (int i = 0; i < [Msnqq count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(CFStringRef)[Msnqq objectAtIndex:i], (CFStringRef)[mlabels objectAtIndex:i], &mi);
    }
    ABRecordSetValue(person, kABPersonInstantMessageProperty, mv4, NULL);
    // 释放该数组
    if (mv4) {
        CFRelease(mv4);
    }
    
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBook, person, NULL);
    
    //将联系人添加到会议通分组中
    ABRecordRef group = [ABGroup getGroupOf:KPHONEGROUPNAME];
    ABGroupAddMember(group, person, NULL);
    // 保存通讯录数据
    ABAddressBookSave(addressBook, NULL);
    NSLog(@"#########添加成功");
    // 释放通讯录对象的引用
    //    if (addressBook) {
    //        CFRelease(addressBook);
    //    }
    
    if (group) {
        CFRelease(group);
    }
    
    return YES;

}



// 根据姓氏、名字以及手机号码修改联系人的昵称和生日
+ (void) updateAddressBookPersonWithFirstName:(NSString *)firstName
                                     lastName:(NSString *)lastName
                                       mobile:(NSString *)mobile
                                     nickname:(NSString *)nickname
                                     birthday:(NSDate *)birthday {
    
    // 初始化并创建通讯录对象，记得释放内存
//    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    NSArray *array = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并修改指定的联系人
    for (id obj in array) {
        ABRecordRef people = (ABRecordRef)obj;
        NSString *fn = (NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        NSString *ln = (NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        ABMultiValueRef mv = ABRecordCopyValue(people, kABPersonPhoneProperty);
        NSArray *phones = (NSArray *)ABMultiValueCopyArrayOfAllValues(mv);
        // firstName同时为空或者firstName相等
        BOOL ff = ([fn length] == 0 && [firstName length] == 0) || ([fn isEqualToString:firstName]);
        // lastName同时为空或者lastName相等
        BOOL lf = ([ln length] == 0 && [lastName length] == 0) || ([ln isEqualToString:lastName]);
        // 由于获得到的电话号码不符合标准，所以要先将其格式化再比较是否存在
        BOOL is = NO;
        for (NSString *p in phones) {
            // 红色代码处，我添加了一个类别（给NSString扩展了一个方法），该类别的这个方法主要是用于将电话号码中的"("、")"、" "、"-"过滤掉
            NSString *p1 = [p stringByReplacingOccurrencesOfString:@"、" withString:@""];
            NSString *p2 = [p1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([p2 isEqualToString:mobile]) {
                is = YES;
                break;
            }
        }
        // firstName、lastName、mobile 同时存在进行修改
        if (ff && lf && is) {
            if ([nickname length] > 0) {
                ABRecordSetValue(people, kABPersonNicknameProperty, (CFStringRef)nickname, NULL);
            }
            if (birthday != nil) {
                ABRecordSetValue(people, kABPersonBirthdayProperty, (CFDataRef)birthday, NULL);
            }
            //将联系人添加到会议通分组中
            ABRecordRef group = [self getGroupOf];
            ABGroupAddMember(group, people, NULL);
        }
        
    }
    
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
    
}
@end
