//
//  UsersDao.h
//  Tops
//
//  Created by Ding Sheng on 13-4-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "Users.h"
@interface UsersDao : BaseDao
{

}

-(NSMutableArray *)resultSet;
-(BOOL)insertWithMac:(NSString *)mac Uid:(NSString *)uid Fid:(NSString *)fid Imsi:(NSString *)imsi Sex:(NSString *)sex Tel:(NSString *)tel;

-(BOOL)updateAtIndex:(int)index Mac:(NSString *)mac Uid:(NSString *)uid Fid:(NSString *)fid Imsi:(NSString *)imsi Sex:(NSString *)sex Tel:(NSString *)tel;

-(BOOL)deleteAtIndex:(int)index;

-(BOOL)deleteAtUid:(NSString *)Uid;

-(Users *)selectByUid:(NSString *)Uid;

//根据字段名获取字段的所有值
-(NSMutableArray *)selectValueByFieldName:(NSString *)fieldName;

//清空表
-(BOOL)clearTabel;

//查询Fid对象
-(NSString *)selectFidByUid:(NSString *)Uid;

//查询Sex字段值
-(NSString *)selectSexByUid:(NSString *)Uid;
@end
