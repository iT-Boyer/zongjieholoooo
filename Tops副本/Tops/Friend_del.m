//
//  Friend_del.m
//  Tops
//
//  Created by Ding Sheng on 13-5-15.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "Friend_del.h"

@implementation Friend_del
{
    BOOL finished;
    NSString *JsonData;
}


-(BOOL)deleteByFid:(NSString *)fId MyId:(NSString *)myId
{
    //向开源的地址发送连接请求
    //这里使用的是异步的请求

    NSString *datastring=[NSString stringWithFormat:@"%@?id=%@&oid=%@",URL_OF_DELETE_FRIEND,myId,fId];
    
    NSURL *url = [NSURL URLWithString:datastring];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
    
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return YES;
}

-(void)dealloc
{
    //    [JsonData release];
    [super dealloc];
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
   
    JsonData=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"删除好友，返回值:%@",JsonData);
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
