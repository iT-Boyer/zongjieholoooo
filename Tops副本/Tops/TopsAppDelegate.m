//
//  TopsAppDelegate.m
//  Tops
//
//  Created by 鼎昇 on 13-3-13.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsAppDelegate.h"
#import "TopsRegisterViewController.h"
#import "TopsViewController.h"
#import "ContactsCtrl.h"
#import "SGMSettingConfig.h"
#import "InfosDao.h"
#import "UsersDao.h"
#import "TopsGetBlueMac.h"
#import "Users.h"
#import "ContactData.h"
#import "ArchivingData.h"
#import "JSONKit.h"
#import "SBJson.h"

#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "AgreeOrRefuse.h"
#import "GetInfoOfFrindByFid.h"

#import "TopsTools.h"

#import "TopsHuiYiViewController.h"

@implementation TopsAppDelegate
{
    BOOL isNotificationSetBadge;
    BOOL finished;
//    TopsPeoplesViewController *topsPeoplesCtlr;
}

@synthesize window=_window;

@synthesize navigationController=_navigationController;
@synthesize huiyiNavigationController = _huiyiNavigationController;
@synthesize deviceTokenConnetion;
-(void)dealloc
{
    [_window release];
    [_navigationController release];
    [_huiyiNavigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    UILocalNotification *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {
        [self remoteNotificationUserInfo:application UserInfo:remoteNotif.userInfo];
    }
    //APNs 请求设备令牌 用户许可
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(
                                                                       UIRemoteNotificationTypeAlert |      UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    //推送信息解析
    
  
    //电话本
    if(addressBook == nil)
		addressBook = ABAddressBookCreate();
    //将Mac地址写入userDefaults中
    doMacTest();
    
    if ([[TopsTools platformString] isEqualToString:@"Simulator"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //判断是否注册过
        if ([userDefaults boolForKey:DeviceTokenRegisteredKEY]) {
        //使用Storyboard初始化根界面
            NSLog(@"1已经注册过，直接进入主页面");
            //会议列表界面
            self.window.rootViewController = _huiyiNavigationController;
        }else{
            //注册界面
            self.window.rootViewController = self.navigationController;
        }

    }else{
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       //判断是否注册过
       if ([userDefaults boolForKey:DeviceTokenRegisteredKEY]) {
           //使用Storyboard初始化根界面
           NSLog(@"2已经注册过，直接进入主页面");
           self.window.rootViewController = _huiyiNavigationController;
        }else{
            //卸载后重新安装软件，先从服务器端检查曾经是否注册过
            NSLog(@"正在从服务器端获取个人资料");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
               [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                  (UIRemoteNotificationTypeNewsstandContentAvailability |
                  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
                  UIRemoteNotificationTypeSound)];
             });
           //开启一个runloop，使它始终处于运行状态
           UIApplication *app = [UIApplication sharedApplication];
           app.networkActivityIndicatorVisible = YES;
           finished = NO;
           while (!finished)
           {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
           }
        
           //检查后，根据DeviceTokenRegisteredKEY值，判断跳转界面
           if ([userDefaults boolForKey:DeviceTokenRegisteredKEY]) {
               //使用Storyboard初始化根界面
               NSLog(@"3已经注册过，直接进入主页面");
               self.window.rootViewController = _huiyiNavigationController;
            }else{
                self.window.rootViewController = self.navigationController;
            }
        
         }
     }
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 向APNs服务器请求令牌后，手机应用自动回调该方法,并将返回的token值,并将该值作为设备令牌，传递发送到通知提供者端(sendProviderDeviceToken)，实现获取推送的前提条件:必须在提供者服务器端注册本机信息
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    	    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    	    NSLog(@"My token is:%@", token);
    
    //将device token转换为字符串
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    
    //modify the token, remove the  "<, >"
    NSLog(@"    deviceTokenStr  lentgh:  %d  ->%@", [deviceTokenStr length], [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)]);
    
//    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    deviceTokenStr = [[[[deviceTokenStr
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
    
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    
    //将deviceToken保存在NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存 device token 令牌,并且去掉空格
    [userDefaults setObject:[deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:DeviceTokenStringKEY];
    [deviceTokenStr release];
    //send deviceToken to the service provider
    dispatch_async(dispatch_get_global_queue(0,0), ^{
    
        //没有在service provider注册Device Token, 需要发送令牌到服务器
        if (![userDefaults boolForKey:DeviceTokenRegisteredKEY] )
        {
            NSLog(@" 没有 注册Device Token");
            isNotificationSetBadge=NO;
            [self sendProviderDeviceToken:deviceTokenStr];
        }
    });
    
}

//发送token 与提供者服务器交互 method=savetoken&clientid=%@&token=%@
- (void)sendProviderDeviceToken: (NSString *)deviceTokenString
{
    
    // Establish the request
    NSLog(@"sendProviderDeviceToken = %@", deviceTokenString);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取当前系统的UDID值
//    NSString *UDIDString = [[UIDevice currentDevice] uniqueIdentifier];
//    NSLog(@"手机的UDID:%@",UDIDString);
    NSString *body = [NSString stringWithFormat:@"mac=%@&number=%@", [userDefaults objectForKey:BlueToothMACKEY], deviceTokenString];
    
    NSString *baseurl = [NSString stringWithFormat:@"%@",URL_OF_TOKEN_EXIST];  //服务器地址
    
    NSLog(@"send provider device token = %@%@", baseurl,body);
    
    NSURL *url = [NSURL URLWithString:baseurl];
    //设置请求超时时间为30s
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120.0];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *tConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.deviceTokenConnetion = [tConnection retain];
    [tConnection release];
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
}

#pragma mark - 向APNS服务器请求令牌失败时，手机应用自动调用该方法，作出失败提醒
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    	    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    	    NSLog(@"Failed to get token, error:%@", error_str);
    	}

#pragma mark - 处理本地通知的系统方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"本地通知");
}

#pragma mark - 获取远程通知,通过解析推送的信息类型，执行:公告，好友申请等相应的方法...同时将在启动程序后,重置提供者和客户端的通知状态badge值, resetBadgeNumberOnProviderWithDeviceToken
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self remoteNotificationUserInfo:application UserInfo:userInfo];
}


//程序桌面启动图标，和状态栏启动程序   处理推送信息的公用部分
-(void)remoteNotificationUserInfo:(UIApplication *)application UserInfo:(NSDictionary *)userInfo
{
    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSLog(@"the badge number is  %d",  [[UIApplication sharedApplication] applicationIconBadgeNumber]);
    NSLog(@"the application  badge number is  %d",  application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber -= 1;
    
    //将推送公告信息  保存到本地数据库中
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"infos"]) {
        InfosDao *infosDao = [[InfosDao alloc]init];
        if ([infosDao insertWithTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"] Time:[userInfo objectForKey:@"time"] Content:[userInfo objectForKey:@"info"]]) {
            NSLog(@"将推送的公告信息插入到本地数据库,成功");
        }else{
            NSLog(@"将推送的公告信息插入到本地数据库,失败");
        }
        [infosDao release];
    }
    
    //当用户打开程序时候收到远程通知后执行
    if (application.applicationState == UIApplicationStateActive) {
    
    }else if(application.applicationState == UIApplicationStateInactive){
        //若为UIApplicationStateInactive就是用户点击通知框按钮进来的。
        //若为UIApplicationStateActive，就是前台正跑着呢。
    }
    
    UIAlertView *alertView = nil;
    
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"request"]) { //推送邀请
        
        AgreeOrRefuse *aor = [[AgreeOrRefuse alloc] init];
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = @"忽略";
        cancelItem.action = ^
        {
         //为NO时的处理  
        };
        
        
        RIButtonItem *agreeItem = [RIButtonItem item];
        agreeItem.label = @"同意";
        agreeItem.action = ^
        {
            [alertView setHidden:TRUE];
            if ([aor agreeOrRefuse:[userInfo objectForKey:@"mid"] Result:@"1"]) {
                NSLog(@"同意添加，成功");
            }else{
                NSLog(@"同意添加，失败");
            }
            //[aor autorelease];
        };
        
        RIButtonItem *refuseItem = [RIButtonItem item];
        refuseItem.label = @"拒绝";
        refuseItem.action = ^
        {
            [alertView setHidden:TRUE];
            if ([aor agreeOrRefuse:[userInfo objectForKey:@"mid"] Result:@"2"]) {
                NSLog(@"拒绝添加，成功");
            }else{
                NSLog(@"拒绝添加，失败");
            }
            //                [aor autorelease];
        };
        
        alertView = [[UIAlertView alloc] initWithTitle:@"附近人的邀请"
                                               message:[NSString stringWithFormat:@"\n%@",
                                                        [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]objectForKey:@"body"]]
                                      cancelButtonItem:cancelItem
                                      otherButtonItems:agreeItem,refuseItem, nil];
        
    }else if([[userInfo objectForKey:@"type"] isEqualToString:@"response"]){ //被同意后，到服务器端获取对方信息
        
        GetInfoOfFrindByFid *infoOfFriend = [[[GetInfoOfFrindByFid alloc] init] autorelease];
        RIButtonItem *getFriendInfoItem = [RIButtonItem item];
        getFriendInfoItem.label = @"获取好友信息";
        getFriendInfoItem.action = ^
        {
            [alertView setHidden:TRUE];
            //为NO时的处理
            NSString * resultUid = [infoOfFriend getInfoOfFrindByFid:[userInfo objectForKey:@"id"]];
            if (resultUid!=nil && ![resultUid isEqualToString:@"t"]) {
                NSLog(@"获取好友信息，成功");
                //显示一个具体联系人
                int contactId =[resultUid intValue];
                ABPersonViewController *pvc = [[ABPersonViewController alloc] init];
                ABContact *contact = [ABContact contactWithRecordID:contactId];
                pvc.displayedPerson = contact.record;
                //支持编辑
                pvc.allowsEditing = YES;
                //设置导航条的标题
                pvc.title = [contact contactName];
                //支持发短信，共享联系人，添加到个人收藏
                pvc.allowsActions = YES;
                
                pvc.personViewDelegate = self;
                
                //通讯录，自带导航条
                [self.window.rootViewController.navigationController pushViewController:pvc animated:YES];
//                [self.navigationController pushViewController:pvc animated:YES];
                ////                    [_topsPeoplesCtlr.navigationController pushViewController:pvc animated:nil];
                //                    [_topsPeoplesCtlr presentModalViewController:pvc animated:YES];
                //                    [pvc release];
            }else{
                NSLog(@"获取好友信息，失败");
            }
        };
        
        alertView = [[UIAlertView alloc] initWithTitle:@"通过对方同意,获取好友详情"
                                               message:[NSString stringWithFormat:@"\n%@",
                                                        [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]objectForKey:@"body"]]
                                      cancelButtonItem:getFriendInfoItem
                                      otherButtonItems: nil];
    }else{
        //推送公告
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        alertView = [[UIAlertView alloc] initWithTitle:@"公告信息"
                                               message:[NSString stringWithFormat:@"\n%@",
                                                        [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]objectForKey:@"body"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        
    }
    
    if (application.applicationIconBadgeNumber == 0) {
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
//            application.applicationIconBadgeNumber = 0;
            
            //ask the provider to set the BadgeNumber to zero
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
            [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
        });

    }
    
    [alertView show];
    [alertView release];

}
//点击电话号码内容时 事件处理...返回YES，拨打电话，返回NO,不操作...
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

//重置应用的推送通知的显示并重置提供者服务器  method=setbadge&token=%@
- (void)resetBadgeNumberOnProviderWithDeviceToken: (NSString *)deviceTokenString
{
    NSLog(@"  reset Provider DeviceToken %@", deviceTokenString);
    isNotificationSetBadge = YES;
    
    //ask the provider to set the BadgeNumber to zero
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *MAC = [userDefaults objectForKey:BlueToothMACKEY];
    // Establish the request 提交token的接口
    NSString *body = [NSString stringWithFormat:@"mac=%@", MAC];
    
    NSString *baseurl = [NSString stringWithFormat:@"%@",URL_OF_BADGE_ZERO];  //服务器地址
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120.0];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *tConnection = [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    self.deviceTokenConnetion = [tConnection retain];
    [tConnection release];
    
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark - 每次醒来都需要去判断是否得到device token
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //每次醒来都需要去判断是否得到device token
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    //hide the badge
//    application.applicationIconBadgeNumber = 0;
}

//向服务器申请发送token 判断事前有没有发送过
- (void)registerForRemoteNotificationToGetToken
{
    NSLog(@"Registering for push notifications...");
    
    //注册Device Token, 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"判断是否注册过：%d",[userDefaults boolForKey:DeviceTokenRegisteredKEY]);
    
    if (![userDefaults boolForKey:DeviceTokenRegisteredKEY])   //如果没有注册到令牌 则重新发送注册请求
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeNewsstandContentAvailability |
              UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
              UIRemoteNotificationTypeSound)];
        });
    }
    
    //将远程通知的数量置零
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //1 hide the local badge
        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
            return;
        }
        // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //2 ask the provider to set the BadgeNumber to zero
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
        [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
    });
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//很少用这个方法，只有在应用程序进入后台，并且系统处于某种原因决定跳过暂停状态并终止应用程序时，才会真正调用它。
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //释放电话本空间
    CFRelease(addressBook);
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark - NSURLConnection delegate function
//接受完http协议头，开始真正结束数据时调用此方法  
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSLog(@"Response statusCode:    %d", resp.statusCode);
}

//网络请求时，每接受一段数据就会调用此函数方法 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"connection    2  Received data = %@  ", rsp);
    
    if (isNotificationSetBadge == NO) {
        if([rsp length]>20)
        {
            NSDictionary * MyInfoDic = [[NSDictionary alloc] init];
            [MyInfoDic autorelease];
            MyInfoDic = [data objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode];
            NSLog(@"josnKit解析出来的数据:%@",MyInfoDic);
            //rootDic 来自与我们所用的各种方式将 JSON 解析后得到的字典
            //下面用于在 TextView 中显示解析成功的JSON实际内容
            if (MyInfoDic) {
                for (NSDictionary * s in MyInfoDic) {
                    //检索本地目录文件 注意:若错将NSDocumentDirectory写成NSDocumentationDirectory时,相应的目录下不会新建存档文件的
                    NSString * archivingFilePath;
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory=[paths objectAtIndex:0];
                    archivingFilePath=[documentsDirectory stringByAppendingPathComponent:kArchivingFileKey];

                       NSLog(@"开始存档");
                       ArchivingData *archivingData=[[ArchivingData alloc] init];
                       archivingData.photo=[s objectForKey:@"pic"];
                       archivingData.firstname=[s objectForKey:@"username"];
                       archivingData.lastname=[s objectForKey:@""];
                       archivingData.phone=[s objectForKey:@"tel"];
                       archivingData.role=[s objectForKey:@"post"];
                       archivingData.gender=[s objectForKey:@"sex"];
                       archivingData.company=[s objectForKey:@"title"];
                       NSMutableData *data1=[[NSMutableData alloc]init];
                       NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data1];
                       [archiver encodeObject:archivingData forKey:kArchivingDataKey];
                       [archiver finishEncoding];
                       [data1 writeToFile:archivingFilePath atomically:YES];
//                        NSLog(@"存档成功:%@",archivingFilePath);
                       [archiver release];
                       [data1 release];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        //将服务器端注册Id存入NSUserDefaults中
                        NSLog(@"将服务器端注册Id存入NSUserDefaults中,ID：%@",[s objectForKey:@"id"]);
                        [userDefaults setObject:[s objectForKey:@"id"] forKey:kMYID];
                        //将注册状态设置为YES
                        [userDefaults setBool:YES forKey:DeviceTokenRegisteredKEY];
                }
            }else{
                NSLog(@"没有注册信息！！！");
            }
        }
        
    }else{//isNotificationSetBadge == YES;
        NSLog(@"connection    2  reset");
        //重置图标显示的数字
        isNotificationSetBadge = NO;
    }
    
    [rsp release];
}

//下载完成，可以对一些数据进行处理，将文件保存到沙盒中
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"connection  3  Did Finish Loading ");
    finished=YES;
    [self.deviceTokenConnetion cancel];
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

//请求失败时调用此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"load error:%@",[error description]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:@"网络请求超时" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}
@end
