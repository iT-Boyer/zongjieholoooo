//
//  addPeople.m
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "addPeopleToFriend.h"

@implementation addPeopleToFriend
{
    NSData *JsonData;
    BOOL finished;
}

@synthesize isTrue;

-(void)addPeopleToFriend:(NSString *)MyMac FriendMac:(NSString *)Fmac State:(NSString *)state
{
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    //获取数据
//    NSString *mac_imsi = [userDefaults objectForKey:BlueToothMACKEY];
    NSString *datastring=[NSString stringWithFormat:@"mac1=%@&mac2=%@&state=%@",MyMac,Fmac,state];
    
    NSLog(@"添加附近的人：http://192.168.1.222:8080/hz/apply?%@",datastring);
    
    NSURL *url = [NSURL URLWithString:URL_OF_ADDPEOPLE];
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
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

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
    NSLog(@"添加附近的人...结束:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    JsonData=data;
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
