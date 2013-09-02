//
//  Users.m
//  Tops
//
//  Created by Ding Sheng on 13-4-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "Users.h"

@implementation Users

@synthesize uid,fid,imsi,mac,sex,tel,username,role,address,email,msnqq,company,cphone,cfax,cemail,caddress,cweb,photo;
-(id)initWithIndex:(int)newId Uid:(NSString *)newUid Fid:(NSString *)newFid Imsi:(NSString *)newImsi Mac:(NSString *)newMac Sex:(NSString *)newSex Tel:(NSString *)newTel
{
    if (self=[super init]) {
        Id = newId;
        self.uid = newUid;
        self.fid = newFid;
        self.imsi = newImsi;
        self.sex = newSex;
        self.tel = newTel;
    }
    return self;
}

-(id)initwithUserName:(NSString *)newUsername Phone:(NSString *)newPhone Role:(NSString *)newRole Address:(NSString *)newAddress Email:(NSString *)newEmail MsnQq:(NSString *)newMsnQq Company:(NSString *)newCompany Cphone:(NSString *)newCphone Cfax:(NSString *)newCfax Cemail:(NSString *)newCemail Caddress:(NSString *)newCaddress Cweb:(NSString *)newCweb Photo:(NSString *)newPhoto
{
    if (self=[super init]) {
        self.username = newUsername;
        self.tel = newPhone;
        self.role = newRole;
        self.address = newAddress;
        self.email = newEmail;
        self.msnqq = newMsnQq;
        self.company = newCompany;
        self.cphone = newCphone;
        self.cweb = newCweb;
        self.cfax = newCfax;
        self.cemail = newCemail;
        self.caddress = newCaddress;
        self.photo = newPhoto;
    }
    return self;
}

-(id)initWithIndex:(int)newId Uid:(NSString *)newUid Fid:(NSString *)newFid Imsi:(NSString *)newImsi Mac:(NSString *)newMac Sex:(NSString *)newSex Tel:(NSString *)newTel UserName:(NSString *)newUsername Role:(NSString *)newRole Address:(NSString *)newAddress Email:(NSString *)newEmail MsnQq:(NSString *)newMsnQq Company:(NSString *)newCompany Cphone:(NSString *)newCphone Cfax:(NSString *)newCfax Cemail:(NSString *)newCemail Caddress:(NSString *)newCaddress Cweb:(NSString *)newCweb Photo:(NSString *)newPhoto
{
    if (self=[super init]) {
        Id = newId;
        self.uid = newUid;
        self.fid = newFid;
        self.imsi = newImsi;
        self.sex = newSex;
        self.tel = newTel;
        self.username = newUsername;
        self.role = newRole;
        self.address = newAddress;
        self.email = newEmail;
        self.msnqq = newMsnQq;
        self.company = newCompany;
        self.cphone = newCphone;
        self.cweb = newCweb;
        self.cfax = newCfax;
        self.cemail = newCemail;
        self.caddress = newCaddress;
        self.photo = newPhoto;
    }
    return self;

}
-(int)getId
{
    return Id;
}

- (void)dealloc {
    [uid release];
	[fid release];
    [mac release];
	[imsi release];
	[sex release];
    [tel release];
    [username release];
    [role release];
    [address release];
    [email release];
    [msnqq release];
    [company release];
    [cphone release];
    [cweb release];
    [cfax release];
    [cemail release];
    [caddress release];
    [photo release];
    [super dealloc];
}
@end
