//
//  ArchivingData.m
//  Tops
//
//  Created by Ding Sheng on 13-4-2.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "ArchivingData.h"

#define kPhotoKey @"PhotoKey"
#define KFirstnameKey @"FirstnameKey"
#define KLastnameKey @"LastnameKey"
#define KRoleKey @"RoleKey"
#define kPhoneKey @"PhoneKey"
#define KGenderKey @"GenderKey"
#define kCompanyKey @"CompanyKey"
#define kEmailKey @"EmailKey"
#define kQqKey @"QqKey"
@implementation ArchivingData

@synthesize photo;
@synthesize firstname;
@synthesize lastname;
@synthesize role;
@synthesize phone;
@synthesize gender;
@synthesize company;

@synthesize email,qq;

-(id)initWithFirstname:(NSString *)newFirstname Lastname:(NSString *)newLastname Role:(NSString *)newRole Phone:(NSString *)newPhone gender:(NSString *)newGender Company:(NSString *)newCompany
{
    if (self=[super init]) {
        self.firstname=newFirstname;
        self.lastname=newLastname;
        self.role=newRole;
        self.phone=newPhone;
        self.gender=newGender;
        self.company=newCompany;
    }
    return self;
}

-(id)initWithFirstname:(NSString *)newFirstname Lastname:(NSString *)newLastname Role:(NSString *)newRole Phone:(NSString *)newPhone gender:(NSString *)newGender Company:(NSString *)newCompany Email:(NSString *)newEmail Qq:(NSString *)newQq
{
    if (self=[super init]) {
        self.firstname=newFirstname;
        self.lastname=newLastname;
        self.role=newRole;
        self.phone=newPhone;
        self.gender=newGender;
        self.company=newCompany;
        self.email = newEmail;
        self.qq = newQq;
    }
    return self;
}
#pragma mark NSCoding 编码 
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:photo forKey:kPhotoKey];
    [aCoder encodeObject:firstname forKey:KFirstnameKey];
    [aCoder encodeObject:lastname forKey:KLastnameKey];
    [aCoder encodeObject:phone forKey:kPhoneKey];
    [aCoder encodeObject:role forKey:KRoleKey];
    [aCoder encodeObject:gender forKey:KGenderKey];
    [aCoder encodeObject:company forKey:kCompanyKey];
    [aCoder encodeObject:email forKey:kEmailKey];
    [aCoder encodeObject:qq forKey:kQqKey];

}

#pragma mark NSDecoding 解析
//不能将decodeObjectForKey错写为decodeBoolForKey...等都易出错
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        firstname=[aDecoder decodeObjectForKey:KFirstnameKey];
        lastname=[aDecoder decodeObjectForKey:KLastnameKey];
        phone=[aDecoder decodeObjectForKey:kPhoneKey];
        role=[aDecoder decodeObjectForKey:KRoleKey];
        gender=[aDecoder decodeObjectForKey:KGenderKey];
        company=[aDecoder decodeObjectForKey:kCompanyKey];
        email = [aDecoder decodeObjectForKey:kEmailKey];
        qq = [aDecoder decodeObjectForKey:kQqKey];
        photo=[aDecoder decodeObjectForKey:kPhotoKey];
         return self;
    }
    return nil;
}

#pragma mark NSCoping 复制
-(id)copyWithZone:(NSZone *)zone
{
    ArchivingData *copy=[[[self class]allocWithZone:zone] init];
    copy.photo=[self.photo copyWithZone:zone];
    copy.firstname=[self.firstname copyWithZone:zone];
    copy.lastname=[self.lastname copyWithZone:zone];
    copy.phone=[self.phone copyWithZone:zone];
    copy.role=[self.role copyWithZone:zone];
    copy.gender=[self.gender copyWithZone:zone];
    copy.company=[self.company copyWithZone:zone];
    copy.email=[self.email copyWithZone:zone];
    copy.qq= [self.qq copyWithZone:zone];
    return copy;
}

@end
