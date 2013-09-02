//
//  Users.h
//  Tops
//
//  Created by Ding Sheng on 13-4-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject{
    int Id;
    NSString *uid;
    NSString *fid;
//    NSString *cid;
//    NSString *mid;
    NSString *imsi;
    NSString *mac;
    NSString *sex;
    NSString *tel;
    
    //电话薄信息
    NSString *username;
    NSString *role;
    NSString *address;
    NSString *email;
    NSString *msnqq;
    NSString *company;
    NSString *cphone;
    NSString *cfax;
    NSString *cemail;
    NSString *caddress;
    NSString *cweb;
    NSString *photo;
}

@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)NSString *fid;
//@property (nonatomic,retain)NSString *cid;
//@property (nonatomic,retain)NSString *mid;
@property (nonatomic,retain)NSString *imsi;
@property (nonatomic,retain)NSString *mac;
@property (nonatomic,retain)NSString *sex;
@property (nonatomic,retain)NSString *tel;

@property (nonatomic,retain)NSString *username;
@property (nonatomic,retain)NSString *role;
@property (nonatomic,retain)NSString *address;
@property (nonatomic,retain)NSString *email;
@property (nonatomic,retain)NSString *msnqq;
@property (nonatomic,retain)NSString *company;
@property (nonatomic,retain)NSString *cphone;
@property (nonatomic,retain)NSString *cfax;
@property (nonatomic,retain)NSString *cemail;
@property (nonatomic,retain)NSString *caddress;
@property (nonatomic,retain)NSString *cweb;
@property (nonatomic,retain)NSString *photo;

-(id)initWithIndex:(int)newId Uid:(NSString *)newUid Fid:(NSString *)newFid Imsi:(NSString *)newImsi Mac:(NSString *)newMac Sex:(NSString *)newSex Tel:(NSString *)newTel;

-(id)initwithUserName:(NSString *)newUsername Phone:(NSString *)newPhone Role:(NSString *)newRole Address:(NSString *)newAddress Email:(NSString *)newEmail MsnQq:(NSString *)newMsnQq Company:(NSString *)newCompany Cphone:(NSString *)newCphone Cfax:(NSString *)newCfax Cemail:(NSString *)newCemail Caddress:(NSString *)newCaddress Cweb:(NSString *)newCweb Photo:(NSString *)newPhoto;

- (int)getId;

-(id)initWithIndex:(int)newId Uid:(NSString *)newUid Fid:(NSString *)newFid Imsi:(NSString *)newImsi Mac:(NSString *)newMac Sex:(NSString *)newSex Tel:(NSString *)newTel UserName:(NSString *)newUsername  Role:(NSString *)newRole Address:(NSString *)newAddress Email:(NSString *)newEmail MsnQq:(NSString *)newMsnQq Company:(NSString *)newCompany Cphone:(NSString *)newCphone Cfax:(NSString *)newCfax Cemail:(NSString *)newCemail Caddress:(NSString *)newCaddress Cweb:(NSString *)newCweb Photo:(NSString *)newPhoto;
@end
