//
//  BaseDao.m
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import "DB.h"
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"



@implementation BaseDao

@synthesize db;

- (id)init{
	if(self = [super init])
	{
		db = [[[DB alloc] getDatabase] retain];
	}
	
	return self;
}

-(NSString *)SQL:(NSString *)sql inTable:(NSString *)table {
	return [NSString stringWithFormat:sql, table];
}

//判断指定的表名是否存在
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %d", count);
        
        if (0 == count)
        {
            NSLog(@"数据表，不存在，需新建");
            return NO;
        }
        else
        {
            NSLog(@"数据表，已存在");
            return YES;
        }
    }
    
    return NO;
}
//建立table

//如果是新建的资料库档，一开始是没有table的。建立table的方式很简单：
-(BOOL)createT_User
{
    if (![db tableExists:TABLE_USER]) {
        
        [db executeUpdate:@"CREATE TABLE t_users (Id INTEGER PRIMARY KEY AUTOINCREMENT,Uid text,Fid text, Sex text, Mac text, Imsi text, Tel text)"];
        NSLog(@"%@ 表创建成功！",TABLE_USER);
        return YES;
    }
    NSLog(@"%@ 表创建失败！",TABLE_USER);
    return NO;
}

//公告表
-(BOOL)createT_Info
{
    if (![db tableExists:TABLE_INFO]) {
        [db executeUpdate:@"CREATE TABLE t_infos (Id INTEGER PRIMARY KEY,Title text,Time text,Content text)"];
        NSLog(@"%@ 表创建成功！",TABLE_INFO);
        return YES;
    }
    NSLog(@"%@ 表创建失败！",TABLE_INFO);
    return NO;
}


//删除表
-(BOOL)deleteByTableName:(NSString *)tableName
{
    if ([db tableExists:tableName]) {
        [db executeUpdate:@"drop table ?",@"t_users"];
        NSLog(@"删除 %@ 表成功！再新建",tableName);
        [db close];
        return YES;
    }else{
         NSLog(@"想删除的 %@ 表不存在！",tableName);
    }
    return NO;
}

- (void)dealloc {
	[db release];
	[super dealloc];
}
@end