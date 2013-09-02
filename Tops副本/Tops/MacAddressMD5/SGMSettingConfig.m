//
//  SGMSettingConfig.m
//  Speech SDK
//
//  Created by rosschen on 12-12-28.
//  Copyright (c) 2012年 rosschen. All rights reserved.
//

#import "SGMSettingConfig.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation SGMSettingConfig
@synthesize HTTP_PACKAGE_SIZE;
@synthesize HTTP_RETRY_TIMES;
@synthesize REPLY_LENGTH;
@synthesize MAX_AUDIO_TIME;
@synthesize MAX_RESULT_AMOUNT;
@synthesize USE_DENOISE_AGC;
@synthesize API_VERSION;

-(id)init{
    if(self = [super init]){
        HTTP_PACKAGE_SIZE = 3000;
        HTTP_RETRY_TIMES = 2;
        REPLY_LENGTH = 2600;
        MAX_AUDIO_TIME = 30;
        MAX_RESULT_AMOUNT = 5;
        USE_DENOISE_AGC = false;
        API_VERSION = 1000;
    }
    return self;
}
//获取设备MAC地址
+(NSString *)macAddress{
    //Get MAC Address as unique identifier
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0)
        return nil;  //Error:if_nametoindex error
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
        return nil;  //Error:sysctl, take 1
    
    if((buf = malloc(len)) == NULL)
        return nil;  //Could not allocate memory. error!
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0){
        free(buf);
        return nil;  //Error:sysctl, take 2
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
//    NSString *outString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 6)];
    free(buf);
    return [outString uppercaseString];
}

//给定信息进行MD5
+(NSString *)getMD5:(NSString *)paramStr{
    const char *cStr = [paramStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    /*
    //获取全部加密MD5值
    NSString *md5Str = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
    return [md5Str substringFromIndex:12];//从第12个元素开始取值，取后4个值(12-15)
    */
    NSString *md5Str = [NSString stringWithFormat:@"%02X%02X%02X%02X",result[12],result[13],result[14],result[15]];
    return md5Str;
}

//给设备MAC地址进行MD5加密
+(NSString *)macMD5{
    NSString *paramStr = [self macAddress];
    NSLog(@"硬件的mac地址:%@",paramStr);
    return [self getMD5:paramStr];
}

+(NSString *)getMac{
   return [self macAddress];
}
- (void)dealloc
{
    [super dealloc];
}

@end
