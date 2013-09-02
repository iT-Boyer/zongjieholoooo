//
//  UsersDao.m
//  Tops
//
//  Created by Ding Sheng on 13-4-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "UsersDao.h"
#import "Users.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation UsersDao


- (id)init{
	if(self = [super init])
	{
        //创建user表
		[self createT_User];
	}
	
	return self;
}


///


// SELECT
-(NSMutableArray *)resultSet
{
	NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@" inTable:TABLE_USER]];
	while ([rs next]) {
        //[rs intForColumn:@"id"]
		Users *tr = [[Users alloc] initWithIndex:[rs intForColumn:@"Id"] Uid:[rs stringForColumn:@"Uid"] Fid:[rs stringForColumn:@"Fid"] Imsi:[rs stringForColumn:@"Imsi"] Mac:[rs stringForColumn:@"Mac"] Sex:[rs stringForColumn:@"Sex"] Tel:[rs stringForColumn:@"Tel"]];
		[result addObject:tr];
		[tr release];
	}
	
	[rs close];
	
	return result;
}

//根据字段名获取字段的所有值
-(NSMutableArray *)selectValueByFieldName:(NSString *)fieldName
{
    NSMutableArray * result = [[NSMutableArray alloc]init];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT Uid FROM %@" inTable:TABLE_USER]];
	while ([rs next]) {
        //[rs intForColumn:@"id"]
        [result addObject:[rs stringForColumn:fieldName]];
	}
	[rs close];
	return result;


}

// INSERT
-(BOOL)insertWithMac:(NSString *)mac Uid:(NSString *)uid Fid:(NSString *)fid Imsi:(NSString *)imsi Sex:(NSString *)sex Tel:(NSString *)tel
{
    [db executeUpdate:[self SQL:@"INSERT INTO %@ (Uid, Fid, Sex,  Mac, Imsi, Tel) VALUES (?,?,?,?,?,?)" inTable:TABLE_USER], uid, fid, sex, mac, imsi,tel];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
    return YES;
}

// UPDATE
-(BOOL)updateAtIndex:(int)index Mac:(NSString *)mac Uid:(NSString *)uid Fid:(NSString *)fid Imsi:(NSString *)imsi Sex:(NSString *)sex Tel:(NSString *)tel
{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"UPDATE %@ SET Mac=?,Uid=?, Fid=?, Imsi=?, Sex=?, Tel=? WHERE Uid=?" inTable:TABLE_USER],
     mac, uid,fid, imsi, sex, tel, [NSNumber numberWithInt:index]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	
	return success;
}
// DELETE
- (BOOL)deleteAtIndex:(int)index
{
	BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE Id = ?" inTable:TABLE_USER], [NSNumber numberWithInt:index]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
//DELETE by uid
- (BOOL)deleteAtUid:(NSString *)Uid
{
	BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE Uid = ?" inTable:TABLE_USER], Uid];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

//查询users对象
-(Users *)selectByUid:(NSString *)Uid
{

    FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_users WHERE Uid = ?",[NSString stringWithFormat:@"%@",Uid]];
//                      [db executeQuery:@"SELECT * FROM User WHERE Age = ?",@"20"]
	while ([rs next]) {
        //[rs intForColumn:@"id"]
		Users *tr = [[Users alloc] initWithIndex:[rs intForColumn:@"Id"] Uid:[rs stringForColumn:@"Uid"] Fid:[rs stringForColumn:@"Fid"] Imsi:[rs stringForColumn:@"Imsi"] Mac:[rs stringForColumn:@"Mac"] Sex:[rs stringForColumn:@"Sex"] Tel:[rs stringForColumn:@"Tel"]];
        [rs close];
        return tr;
	}
	[rs close];
	return nil;
}


//查询Fid对象
-(NSString *)selectFidByUid:(NSString *)Uid
{
    NSString *result = nil;
    FMResultSet *rs = [db executeQuery:@"SELECT Fid FROM t_users WHERE Uid = ?",Uid];
	while ([rs next]) {
        //[rs intForColumn:@"id"]
		result = [rs stringForColumn:@"Fid"];
	}
	[rs close];
	return result;
    
}

//查询Sex字段值
-(NSString *)selectSexByUid:(NSString *)Uid
{
    NSString *result = nil;
    FMResultSet *rs = [db executeQuery:@"SELECT Sex FROM t_users WHERE Uid = ?",Uid];
	while ([rs next]) {
        //[rs intForColumn:@"id"]
		result = [rs stringForColumn:@"Sex"];
	}
	[rs close];
	return result;
}


//清空表
-(BOOL)clearTabel
{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@" inTable:TABLE_USER]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;

}

- (void)dealloc
{
	[super dealloc];
}
@end
