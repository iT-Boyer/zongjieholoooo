//
//  TopsTools.h
//  Tops
//
//  Created by Ding Sheng on 13-4-8.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopsTools : NSObject

//获取IMSI
+ (void)getIMSI;

//读取文件中的文本内容
+ (NSString *)readFileText:(NSString *)fileName Format:(NSString *)txt;

//读取.plist文件中的键值对，并返回NSMutableDictionary键值对字典
+(NSMutableDictionary *)readFilePlilst:(NSString *)fileName;

//获取documentsDirectory目录下文件的绝对路径
+(NSString *)getFilePathOfdocumentsDirectory:(NSString *)fileName;

//获取documentsDirectory目录下已存在的文件 的绝对路径 不新建文本
+(NSString *)getFilePathOfFileExists:(NSString *)fileName;

//删除documentsDirectory目录下的文件
+(BOOL)deleteFileExist:(NSString *)fileName;

//判断运行环境，区别（虚拟机【Simulator】，或真机）
+ (NSString *) platformString;

//访问网页时，路径中含有中文参数的解决方法
+(NSString *)encodingText:(NSString *)sourceText;

//如果想简单的知道网络连接情况，连接还是未连接，那么就可以用下面这个方法
+ (BOOL) isConnectionAvailable;

//加载Supporting Files 目录下图片
+(id)loadImages:(NSString *)imgName Format:(NSString *)format;
@end
