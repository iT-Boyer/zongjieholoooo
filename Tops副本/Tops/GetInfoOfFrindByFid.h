//
//  GetInfoOfFrindByFid.h
//  Tops
//
//  Created by Ding Sheng on 13-5-24.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetInfoOfFrindByFid : NSObject


@property(nonatomic,copy)NSDictionary *InfoFrindDics;

-(NSString *)getInfoOfFrindByFid:(NSString *)fid;
@end
