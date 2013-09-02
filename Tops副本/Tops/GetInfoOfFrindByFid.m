//
//  GetInfoOfFrindByFid.m
//  Tops
//
//  Created by Ding Sheng on 13-5-24.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "GetInfoOfFrindByFid.h"
#import "JSONKit.h"
#import "SBJson.h"
#import "Users.h"
#import "UsersDao.h"
#import "ContactData.h"

@implementation GetInfoOfFrindByFid
{
    NSData *JsonData;
    BOOL finished;
    NSString * gg;
    NSString *backValue;
    NSString *YN;
}
@synthesize InfoFrindDics = _InfoFrindDics;

-(NSString *)getInfoOfFrindByFid:(NSString *)fid
{
    NSString *datastring=[NSString stringWithFormat:@"id=%@",fid];
    
    NSLog(@"同意添加操作：%@?%@",URL_OF_DETAILINFO_FRIEND,datastring);
    
    NSURL *url = [NSURL URLWithString:URL_OF_DETAILINFO_FRIEND];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[datastring dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%d", [datastring length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];
    
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
    gg = nil;
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return gg;
}


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
    backValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"同意或拒绝加我的人...结束:%@",backValue);
    
    if ([backValue isEqualToString:@"0"]) {
        gg =  @"t";
    }
    if ([backValue length]>20) {
        _InfoFrindDics = [data objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode];
        NSLog(@"Jsonkit解析：%@",_InfoFrindDics);
        Users *user = nil;
        for (NSDictionary *agreedic in _InfoFrindDics) {
            //            _agreeDics = [_agreeDics ob:0];
            user = [[[Users alloc] initWithIndex:@"" Uid:[agreedic objectForKey:@""] Fid:[agreedic objectForKey:@"id"] Imsi:[agreedic objectForKey:@"imsi"] Mac:[agreedic objectForKey:@"mac"] Sex:[agreedic objectForKey:@"sex"] Tel:[agreedic objectForKey:@"tel"] UserName:[agreedic objectForKey:@"username"] Role:[agreedic objectForKey:@"post"] Address:[agreedic objectForKey:@"address"] Email:[agreedic objectForKey:@"email"]  MsnQq:[agreedic objectForKey:@"fax"] Company:[agreedic objectForKey:@"cname"] Cphone:[agreedic objectForKey:@"ctel"] Cfax:[agreedic objectForKey:@"cfax"] Cemail:[agreedic objectForKey:@"cemail"] Caddress:[agreedic objectForKey:@"caddress"] Cweb:[agreedic objectForKey:@"cweb"] Photo:[agreedic objectForKey:@"pic"]] autorelease];
        }
        
        //检查本地通讯录是否已经添加过该联系人
        if ([ContactData byPhoneNumberAndLabelToGetContact:user.tel withLabel:@"iPhone"]) {
            NSLog(@"该联系人已存在，不能再次添加");
        }else{
            NSString * uid = [ContactData addABContactToGroup:user];
            if (uid) {
                NSLog(@"将名片添加到本地通讯录中，成功%@",uid);
                //存入数据库中
                UsersDao *userDao = [[[UsersDao alloc]init] autorelease];
                
                if ([userDao insertWithMac:user.mac Uid:uid Fid:user.fid Imsi:user.imsi Sex:user.sex Tel:user.tel]) {
                    //删除表
                    //                        [userDao clearTabel];
                    NSLog(@"名片交换信息，成功插入本地数据库");
                    gg = uid;
                    [gg retain];
                    
                    
                }else{
                    NSLog(@"将名片添加到本地通讯录中,失败");
                }
            }else{
                NSLog(@"名片交换信息，失败");
            }
        }
    }
}

//下载完成，可以对一些数据进行处理，将文件保存到沙盒中
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"connection    3  Did Finish Loading ");
    finished=YES;
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
