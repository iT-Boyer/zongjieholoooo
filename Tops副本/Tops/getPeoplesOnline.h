//
//  getPeoplesOnline.h
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getPeoplesOnline : NSObject

@property (nonatomic,retain)NSDictionary *peoplesOfOnline;
@property(nonatomic,retain)NSData *JsonData;
-(void)getPeoplesOfOnline;
@end
