//
//  GetCompanysList.h
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCompanysList : NSObject

@property(nonatomic,retain)NSArray *companys;
-(void)getCompanys;
-(void) jsonkitParseCompanysDic;
@end
