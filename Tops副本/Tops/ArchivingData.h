//
//  ArchivingData.h
//  Tops
//
//  Created by Ding Sheng on 13-4-2.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchivingData : NSObject


@property(copy,nonatomic)NSString *photo;
@property(copy,nonatomic)NSString *firstname;
@property(copy,nonatomic)NSString *lastname;
@property(copy,nonatomic)NSString *role;
@property(copy,nonatomic)NSString *phone;
@property(copy,nonatomic)NSString *gender;
@property(copy,nonatomic)NSString *company;
@property(copy,nonatomic)NSString *email;
@property(copy,nonatomic)NSString *qq;


-(id)initWithFirstname:(NSString *)newFirstname Lastname:(NSString *)newLastname Role:(NSString *)newRole Phone:(NSString *)newPhone gender:(NSString *)newGender Company:(NSString *)newCompany;


-(id)initWithFirstname:(NSString *)newFirstname Lastname:(NSString *)newLastname Role:(NSString *)newRole Phone:(NSString *)newPhone gender:(NSString *)newGender Company:(NSString *)newCompany Email:(NSString *)newEmail Qq:(NSString *)newQq;
@end
