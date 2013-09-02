//
//  RecordDao.m
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import "Infos.h"
#import "InfosDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@implementation InfosDao


- (id)init{
	if(self = [super init])
	{
        //创建infos表
		[self createT_Info];
	}
	
	return self;
}
// SELECT
-(NSMutableArray *)resultSet
{
	NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@" inTable:TABLE_INFO]];
	while ([rs next]) {
        //[rs intForColumn:@"id"]
		Infos *tr = [[Infos alloc] initWithIndex:[rs intForColumn:@"Id"]
                                            Title:[rs stringForColumn:@"Title"]
                                            Time:[rs stringForColumn:@"Time"]
                                            Content:[rs stringForColumn:@"Content"]];
		[result addObject:tr];
		[tr release];
	}
	[rs close];
	return result;
}


// INSERT
-(BOOL)insertWithTitle:(NSString *)title Time:(NSString *)time Content:(NSString *)content
{
	[db executeUpdate:[self SQL:@"INSERT INTO %@ (Title, Time, Content) VALUES (?,?,?)" inTable:TABLE_INFO], title, time, content];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return NO;
	}
    return YES;
}


// UPDATE
-(BOOL)updateAtIndex:(int)index Title:(NSString *)title Time:(NSString *)time Content:(NSString *)content
{
	BOOL success = YES;
	[db executeUpdate:[self SQL:@"UPDATE %@ SET Title=?, Time=?, Content=? WHERE Id=?" inTable:TABLE_INFO],
	                                    title, time, content, [NSNumber numberWithInt:index]];
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
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE Id = ?" inTable:TABLE_INFO], [NSNumber numberWithInt:index]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

- (BOOL)deleteByInfos:(Infos *)infos
{
    return [self deleteAtIndex:[infos getIid]];
}

- (void)dealloc
{
	[super dealloc];
}

@end