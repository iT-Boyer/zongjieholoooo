//
//  SGMSettingConfig.h
//  Speech SDK
//
//  Created by rosschen on 12-12-28.
//  Copyright (c) 2012年 rosschen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGMSettingConfig : NSObject{
    NSInteger HTTP_PACKAGE_SIZE;
    NSInteger HTTP_RETRY_TIMES;
    NSInteger REPLY_LENGTH;
    NSInteger MAX_AUDIO_TIME;
    NSInteger MAX_RESULT_AMOUNT;
    BOOL USE_DENOISE_AGC;
    NSInteger API_VERSION;
}
@property(nonatomic) NSInteger HTTP_PACKAGE_SIZE;
@property(nonatomic) NSInteger HTTP_RETRY_TIMES;
@property(nonatomic) NSInteger REPLY_LENGTH;
@property(nonatomic) NSInteger MAX_AUDIO_TIME;
@property(nonatomic) NSInteger MAX_RESULT_AMOUNT;
@property(nonatomic) BOOL USE_DENOISE_AGC;
@property(nonatomic) NSInteger API_VERSION;
//获取设备MAC地址
+(NSString *)macAddress;

//给定信息进行MD5
+(NSString *)getMD5:(NSString *)paramStr;

//给设备MAC地址进行MD5加密
+(NSString *)macMD5;

//获取mac值
+(NSString *)getMac;
@end
