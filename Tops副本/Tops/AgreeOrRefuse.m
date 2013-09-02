//
//  AgreeOrRefuse.m
//  Tops
//
//  Created by Ding Sheng on 13-5-6.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "AgreeOrRefuse.h"
#import "JSONKit.h"
#import "SBJson.h"
#import "Users.h"
#import "UsersDao.h"
#import "ContactData.h"

@implementation AgreeOrRefuse
{
    NSData *JsonData;
    BOOL finished;
    BOOL gg;
    NSString *backValue;
    NSString *YN;
}

@synthesize agreeDics=_agreeDics;

-(BOOL)agreeOrRefuse:(NSString *)mid Result:(NSString *)YorN
{
    YN = YorN;
    NSString *datastring=[NSString stringWithFormat:@"mid=%@&result=%@",mid,YorN];
    
    NSLog(@"同意添加操作：http://192.168.1.222:8080/hz/allow?%@",datastring);
    
    NSURL *url = [NSURL URLWithString:URL_OF_AGREE_OR_REFUSE];
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
    gg = NO;
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
    
    if ([YN isEqualToString:@"2"]&&[backValue isEqualToString:@"0"]) {
        gg =  YES;
    }
    if ([YN isEqualToString:@"1"]&&[backValue length]>20) {
        _agreeDics = [data objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode];
        NSLog(@"Jsonkit解析：%@",_agreeDics);
        Users *user = nil;
        for (NSDictionary *agreedic in _agreeDics) {
//            _agreeDics = [_agreeDics ob:0];
            user = [[Users alloc] initWithIndex:@"" Uid:[agreedic objectForKey:@""] Fid:[agreedic objectForKey:@"id"] Imsi:[agreedic objectForKey:@"imsi"] Mac:[agreedic objectForKey:@"mac"] Sex:[agreedic objectForKey:@"sex"] Tel:[agreedic objectForKey:@"tel"] UserName:[agreedic objectForKey:@"name"] Role:[agreedic objectForKey:@"post"] Address:[agreedic objectForKey:@"address"] Email:[agreedic objectForKey:@"email"]  MsnQq:[agreedic objectForKey:@"fax"] Company:[agreedic objectForKey:@"title"] Cphone:[agreedic objectForKey:@"ctel"] Cfax:[agreedic objectForKey:@"cchuanzhen"] Cemail:[agreedic objectForKey:@"cemail"] Caddress:[agreedic objectForKey:@"caddress"] Cweb:[agreedic objectForKey:@"cweb"] Photo:[agreedic objectForKey:@"pic"]];
        }
        
        //检查本地通讯录是否已经添加过该联系人
            if ([ContactData byPhoneNumberAndLabelToGetContact:user.tel withLabel:@"iPhone"]) {
                NSLog(@"该联系人已存在，不能再次添加");
            }else{
             NSString * uid = [ContactData addABContactToGroup:user];
                if (uid) {
                    NSLog(@"将名片添加到本地通讯录中，成功%@",uid);
                    //存入数据库中
                    UsersDao *userDao = [[UsersDao alloc]init];
                    
                    if ([userDao insertWithMac:user.mac Uid:uid Fid:user.fid Imsi:user.imsi Sex:user.sex Tel:user.tel]) {
                        //删除表
                        //                        [userDao clearTabel];
                        NSLog(@"名片交换信息，成功插入本地数据库");
                        gg = YES;
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


-(void)dealloc
{
    [_agreeDics release];
    [self release];
    [super dealloc];
}
@end
