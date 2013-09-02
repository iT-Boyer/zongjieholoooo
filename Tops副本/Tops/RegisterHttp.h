//
//  RegisterHttp.h
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchivingData.h"
@interface RegisterHttp : NSObject

-(NSString *)registerUser:(ArchivingData *)data;
-(BOOL)registerUser2:(ArchivingData *)data;
-(BOOL)registerUser3:(ArchivingData *)data;
@end
