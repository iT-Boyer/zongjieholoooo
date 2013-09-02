//
//  AgreeOrRefuse.h
//  Tops
//
//  Created by Ding Sheng on 13-5-6.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgreeOrRefuse : NSObject

@property(nonatomic,copy)NSDictionary *agreeDics;

-(BOOL)agreeOrRefuse:(NSString *)mid Result:(NSString *)YorN;

//@property (nonatomic,copy)NSData *JsonData;
//@property (nonatomic)BOOL finished;
@end
