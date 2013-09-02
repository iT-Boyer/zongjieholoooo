//
//  getCompanyDetail.h
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getCompanyDetail : NSObject


@property(nonatomic,retain)NSDictionary *companyDetailDic;


-(void)getCompanyDetailDic:(NSString *)companyName;


@end
