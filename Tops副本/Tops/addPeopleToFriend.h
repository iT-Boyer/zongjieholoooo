//
//  addPeople.h
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addPeopleToFriend : NSObject

@property(nonatomic,assign) BOOL isTrue;

-(void)addPeopleToFriend:(NSString *)MyMac FriendMac:(NSString *)Fmac State:(NSString *)state;
@end
