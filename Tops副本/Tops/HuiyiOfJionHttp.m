//
//  HuiyiOfJionHttp.m
//  Tops
//
//  Created by Ding Sheng on 13-5-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "HuiyiOfJionHttp.h"

@implementation HuiyiOfJionHttp
{
    BOOL finished;
    NSData *JsonData;
}

-(NSString *)submitHuiyiId:(NSString *)huiyiId
{
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    NSString *myId = [userDefaults objectForKey:kMYID];
    NSString *datastring=[NSString stringWithFormat:@"id=%@&showid=%@",myId,huiyiId];
    NSLog(@"提交会议Id的URL:%@?%@",URL_OF_HUIYI_JION,datastring);
    //向开源的地址发送连接请求
    //这里使用的是异步的请求
    NSURL *url = [NSURL URLWithString:URL_OF_HUIYI_JION];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60.0];
    
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
    return [[NSString alloc] initWithData:JsonData encoding:NSUTF8StringEncoding];
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
    JsonData = data;
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
