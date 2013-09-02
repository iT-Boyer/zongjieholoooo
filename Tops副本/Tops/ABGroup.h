//
//  ABGroup.h
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

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABContact.h"

@interface ABGroup : NSObject
{
	ABRecordRef record;
}

+ (id) group;
+ (id) groupWithRecord: (ABRecordRef) record;
+ (id) groupWithRecordID: (ABRecordID) recordID;
+(id)initGroupWithGroupName:(NSString *)groupName;

@property (nonatomic, readonly) ABRecordRef record;
@property (nonatomic, readonly) ABRecordID recordID;
@property (nonatomic, readonly) ABRecordType recordType;
@property (nonatomic, readonly) BOOL isPerson;

- (NSArray *) membersWithSorting: (ABPersonSortOrdering) ordering;
- (BOOL) addMember: (ABContact *) contact withError: (NSError **) error;
- (BOOL) removeMember: (ABContact *) contact withError: (NSError **) error;

//获取指定的联系人群组：会议通,如果不存在将新建分组
+(ABRecordRef)getGroupOf:(NSString *)groupName;
//新建联系人群组groupName，并保存到通讯录中
+ (ABRecordRef)addGroup:(NSString *)groupName;
//获取所有群组的名称
+ (NSArray *)getGroups;
//删除所有分组
+ (void) DeleteGroups;
//获取分组中的所有成员
+ (NSArray *) membersOfGroup:(NSString *)groupName;

//获取分组名称
- (NSString *) name;
//设置分组名称
- (void) setName: (NSString *) aString;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, readonly) NSArray *members;

@end
