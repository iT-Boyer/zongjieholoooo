//
//  TopsTools.m
//  Tops
//
//  Created by Ding Sheng on 13-4-8.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsTools.h"
#import "sys/sysctl.h"
//#include <sys/sysctl.h>
//判断网络连接
#import <SystemConfiguration/SystemConfiguration.h>

#define PRIVATE_PATH  "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"
#define RTLD_LAZY "RTLD_LAZY"

@implementation TopsTools



+ (void)getIMSI {

#if !TARGET_IPHONE_SIMULATOR
    void *kit = dlopen(PRIVATE_PATH,RTLD_LAZY);
    NSString *imsi = nil;
    int (*CTSIMSupportCopyMobileSubscriberIdentity)() = dlsym(kit, "CTSIMSupportCopyMobileSubscriberIdentity");
    imsi = (NSString*)CTSIMSupportCopyMobileSubscriberIdentity(nil);
    dlclose(kit);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IMSI"
                                                    message:imsi
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
#endif
}

//这是使用SpringBoardServices.framework来设置飞行模式开关

#ifdef SUPPORTS_UNDOCUMENTED_API
#define SBSERVPATH  "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"
// Don't use this code in real life, boys and girls. It is not App Store friendly.
// It is, however, really nice for testing callbacks
+ (void) setAirplaneMode: (BOOL)status;
{
    mach_port_t *thePort;
    void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() = dlsym(uikit, "SBSSpringBoardServerPort");
    thePort = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);
    
    // Link to SBSetAirplaneModeEnabled
    void *sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
    int (*setAPMode)(mach_port_t* port, BOOL status) = dlsym(sbserv, "SBSetAirplaneModeEnabled");
    setAPMode(thePort, status);
    dlclose(sbserv);
}
#endif


#pragma mark 获取Supporting Files 目录下文件中的内容
+(NSString *)readFileText:(NSString *)fileName Format:(NSString *)txt
{
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:txt];
    NSString *text = [NSString stringWithContentsOfFile:fullPath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    return text;
}

#pragma mark 读取plist格式的文件，并返回NSMutableDictionary键值对字典
+(NSMutableDictionary *)readFilePlilst:(NSString *)fileName
{
    //使用NSMutableArray提供对数组添加，删除等操作
    NSString *path=[[[NSBundle mainBundle]pathForResource:fileName ofType:@"plist"] autorelease];
    NSMutableDictionary *nsmuDict=[[[NSMutableDictionary alloc]initWithContentsOfFile:path] autorelease];
    if (nsmuDict) {
        return  nsmuDict;
    }
    return nil;
}

//访问网页时，路径中含有中文参数的解决方法
+(NSString *)encodingText:(NSString *)sourceText
{
    return [sourceText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//加载Supporting Files 目录下图片
+(id)loadImages:(NSString *)imgName Format:(NSString *)format
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:format];
    UIImage * img = [UIImage imageWithContentsOfFile:path];
    return img;
}

#pragma mark 获取沙盒中的文件绝对路径
+(NSString *)getFilePathOfdocumentsDirectory:(NSString *)fileName
{
    //获取保存路径 注意:若错将参数NSDocumentDirectory误写成NSDocumentationDirectory时,相应的目录下不会新建存档文件的
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return fullPathToFile;
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark 获取已经存在的文件路径
+(NSString *)getFilePathOfFileExists:(NSString *)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];

    BOOL isDirectory = NO;
	BOOL fileExists = [[[[NSFileManager alloc] init] autorelease] fileExistsAtPath:fullPathToFile isDirectory:&isDirectory];
    if (!fileExists || isDirectory) {
		return fullPathToFile;
	}
    return nil;
}

//删除本地文件
+(BOOL)deleteFileExist:(NSString *)fileName
{
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取数据库文件路径
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) {
        NSLog(@"成功，删除数据库:%@",writableDBPath);
        [fileManager removeItemAtPath:writableDBPath error:nil];
        return YES;
    }
    NSLog(@"删除失败，数据库不存在%@",writableDBPath);
    return NO;
    
}

//使用系统的一个函数sysctlbyname 来获取设备名称
//http://hi.baidu.com/yyy_yunyuya/item/79257a5c348aa601e6c4a5c1
+ (NSString *) platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    //NSString *platform = [NSString stringWithCString:machine];
//    NSString* []'i9platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    NSLog(@"不同平台(platformString)的代表值:%@",platform);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //虚拟机
    if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"])         return @"Simulator";
    
    return @"";
}


//如果想简单的知道网络连接情况，连接还是未连接，那么就可以用下面这个方法
+ (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}

//界面跳转常用的方法

/**
 /使用Storyboard初始化根界面
 //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
 //    self.window.rootViewController = [storyBoard instantiateInitialViewController];
 
 //启动后首先进入登陆界面
 TopsRegisterViewController *topsRegisterViewController = [[TopsRegisterViewController alloc] initWithNibName:@"TopsRegisterViewController" bundle:nil];
 self.window.rootViewController = topsRegisterViewController;
 
 self.window.backgroundColor = [UIColor whiteColor];
 [self.window makeKeyAndVisible];
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 TopsHuiYiViewController *detailViewController = [[TopsHuiYiViewController alloc] initWithNibName:@"TopsHuiYiViewController" bundle:nil];

 [self.navigationController pushViewController:detailViewController animated:YES];
 [detailViewController release];
 
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 [self presentModalViewController:aBPersonNav animated:YES];
 
 **/

-(void)CallApplication
{
    //1、调用 自带mail
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];
    
    
    
    //2、调用 电话phone
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
    
    
    
    //3、调用 SMS
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://800888"]];
    
    
    
    //4、调用自带 浏览器 safari
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.hzlzh.com"]];

}

@end
