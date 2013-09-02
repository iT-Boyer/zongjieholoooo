//
//  ABGroup.m
//  Tops
//
//  Created by Ding Sheng on 13-4-23.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "ABGroup.h"
#import "ABContactsHelper.h"
#import "TopsAppDelegate.h"
@implementation ABGroup
@synthesize record;

// Thanks to Quentarez, Ciaran
- (id) initWithRecord: (ABRecordRef) aRecord
{
	if (self = [super init]) record = CFRetain(aRecord);
	return self;
}

+ (id) groupWithRecord: (ABRecordRef) grouprec
{
	return [[[ABGroup alloc] initWithRecord:grouprec] autorelease];
}

//通过recordID获取群组对象group
+ (id) groupWithRecordID: (ABRecordID) recordID
{
	ABRecordRef grouprec = ABAddressBookGetGroupWithRecordID(addressBook, recordID);
	ABGroup *group = [self groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

+(id)initGroupWithGroupName:(NSString *)groupName
{
    ABRecordRef grouprec = [self getGroupOf:groupName];
    ABGroup *group = [self groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}
// Thanks to Ciaran
+ (id) group
{
	ABRecordRef grouprec = ABGroupCreate();
	id group = [ABGroup groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

//新建联系人群组groupName，并保存到通讯录中
+ (ABRecordRef)addGroup:(NSString *)groupName
{
    CFErrorRef error;
    ABRecordRef group = ABGroupCreate();
    ABRecordSetValue(group, kABGroupNameProperty,groupName, &error);
    ABAddressBookAddRecord(addressBook, group, &error);
    ABAddressBookSave(addressBook, &error);
    [groupName release];
    return group;
    //CFRelease(group);
}

//获取指定的联系人群组：会议通,如果不存在将新建分组
+(ABRecordRef)getGroupOf:(NSString *)groupName
{
    NSArray *array = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
    if ([array count]==0) {
        return [self addGroup:groupName];
    }
    for (int i = 0 ; i < [array count]; i++)
    {
        ABRecordRef group = [array objectAtIndex:i];
        CFTypeRef groupName = ABRecordCopyValue(group, kABGroupNameProperty);
        NSString *groupNameStr = [NSString stringWithFormat:@"%@", (NSString *)groupName];
        if ([groupNameStr isEqualToString:groupName]) {
            return group;
        }else{
            return [self addGroup:groupName];
        }
    }
    return nil;
}


//获取所有群组的名称
+ (NSArray *)getGroups
{
    NSMutableArray *groupNames = [[[NSMutableArray alloc] init] autorelease];
    NSArray *array = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
    for (int i = 0 ; i < [array count]; i++)
    {
        ABRecordRef group = [array objectAtIndex:i];
        CFTypeRef groupName = ABRecordCopyValue(group, kABGroupNameProperty);
        NSString *groupNameStr = [NSString stringWithFormat:@"%@", (NSString *)groupName];
        NSLog(@"groupNames is %@", groupNameStr);
        [groupNames addObject:groupNameStr];
        CFRelease(groupName);
    }
    return groupNames;
}


- (void) dealloc
{
	if (record) CFRelease(record);
	[super dealloc];
}

//delete all groups
+ (void) DeleteGroups
{
    CFErrorRef error;
    //get all groups
    CFArrayRef groups=ABAddressBookCopyArrayOfAllGroups(addressBook);
    //groups' count
    CFIndex groupCount=ABAddressBookGetGroupCount(addressBook);
    for (int i=0; i< groupCount;i++){
        ABRecordRef group=CFArrayGetValueAtIndex(groups, i);
        //delete
        ABAddressBookRemoveRecord(addressBook, group, &error);
        ABAddressBookSave(addressBook, &error);
        CFRelease(groups);
    }
}


#pragma mark Record ID and Type
- (ABRecordID) recordID {return ABRecordGetRecordID(record);}
- (ABRecordType) recordType {return ABRecordGetRecordType(record);}
- (BOOL) isPerson {return self.recordType == kABPersonType;}


#pragma mark management
//从Address Book里得到 会议通组 中的所有联系人 ABGroupCopyArrayOfAllMembers
- (NSArray *) members
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembers(self.record);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}


//从Address Book里得到 会议通组 中的所有联系人 ABGroupCopyArrayOfAllMembers
+ (NSArray *) membersOfGroup:(NSString *)groupName
{
    //获取会议通分组中的联系人
    ABRecordRef group = [self getGroupOf:groupName];
    NSArray *thePeople = (NSArray *)ABGroupCopyArrayOfAllMembers(group);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
    for (id person in thePeople)
        [array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
     CFRelease(group);
    [thePeople release];
//    CFRelease(group);
//    NSLog(@"获取到会议通所有联系人");
    return array;
}

// kABPersonSortByFirstName = 0, kABPersonSortByLastName  = 1
- (NSArray *) membersWithSorting: (ABPersonSortOrdering) ordering
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembersWithSortOrdering(self.record, ordering);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}

- (BOOL) addMember: (ABContact *) contact withError: (NSError **) error
{
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBook, contact.record, NULL);
	return ABGroupAddMember(self.record, contact.record, (CFErrorRef *) error);
}

- (BOOL) removeMember: (ABContact *) contact withError: (NSError **) error
{
	return ABGroupRemoveMember(self.record, contact.record, (CFErrorRef *) error);
}

#pragma mark name

- (NSString *) getRecordString:(ABPropertyID) anID
{
	return [(NSString *) ABRecordCopyValue(record, anID) autorelease];
}

//获取分组名称
- (NSString *) name
{
	NSString *string = (NSString *)ABRecordCopyCompositeName(record);
	return [string autorelease];
}

//设置分组名称
- (void) setName: (NSString *) aString
{
	CFErrorRef error;
	ABRecordSetValue(record, kABGroupNameProperty, (CFStringRef) aString, &error);
	//if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}
@end

