//
//  UpdateInfoHttp.m
//  Tops
//
//  Created by Ding Sheng on 13-5-21.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "UpdateInfoHttp.h"
#import "JSONKit.h"

@implementation UpdateInfoHttp
{
    NSString *JsonData;
    BOOL finished;
}


-(NSString *)updateMyInfo:(ArchivingData *)data
{
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    NSString *mac_imsi = [userDefaults objectForKey:BlueToothMACKEY];
//    NSString *token = [userDefaults objectForKey:DeviceTokenStringKEY];
    //    token = @"6ae422b42169e1e2ec876ba984146ba8a405d9ee2dcf94442daf45cb93fee31e";
    
    NSString *datastring=[NSString stringWithFormat:@"name=%@%@&post=%@&title=%@&tel=%@&mac=%@&cid=%d&sex=%@&fax=%@&email=%@",data.lastname,data.firstname, data.role,data.company,data.phone,mac_imsi,0,data.gender,data.qq,data.email];
    
    NSLog(@"组装json对象：http://192.168.1.222:8080/hz/updateuser%@",datastring);
    
    NSURL *url = [NSURL URLWithString:updateInfoUri];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60.0];
    
    //    NSData *requestData = [NSData dataWithBytes:[datastring UTF8String] length:[datastring length]];
    //    NSLog(@"JSON对象的长度:%d yyyy %d",[requestData length],[datastring length]);
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[datastring dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%d", [datastring length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSLog(@"%@",request);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    return JsonData;
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
    JsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
