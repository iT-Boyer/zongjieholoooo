//
//  RecordDao.h
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"


@interface InfosDao : BaseDao {
}

-(NSMutableArray *)resultSet;
-(BOOL)insertWithTitle:(NSString *)title Time:(NSString *)time Content:(NSString *)content;
-(BOOL)updateAtIndex:(int)index Title:(NSString *)title Time:(NSString *)time Content:(NSString *)content;
-(BOOL)deleteAtIndex:(int)index;

@end
