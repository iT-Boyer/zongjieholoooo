//
//  GetCompanysList.m
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "GetCompanysList.h"
#import "JSONKit.h"
#import "SBJson.h"
@implementation GetCompanysList{

    NSData *JsonData;
    BOOL finished;
}
@synthesize companys;

-(void)getCompanys
{
    //向开源的地址发送连接请求
    //这里使用的是异步的请求
    NSURL *url = [NSURL URLWithString:CompanysListUri];
    NSLog(@"获取公司名称列表:%@",CompanysListUri);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120.0];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    finished = NO;
//    [NSThread detachNewThreadSelector:@selector(httpresign)toTarget:self withObject:nil];
////    [progress setHidden:NO];
//    while (!finished) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [progress setHidden:YES];
    
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self jsonkitParseCompanysDic];
}

-(void)jsonkitParseCompanysDic {

    //此处是使用 JSONKit 解析，得到解析后存入字典：rootDic，并显示
    NSDictionary * CompanysDic = [[NSDictionary alloc] init];
    [CompanysDic autorelease];
    CompanysDic = [JsonData objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"josnKit解析出来的数据:%@",CompanysDic);
    NSMutableArray * companyArray = [[NSMutableArray alloc] init];

    //rootDic 来自与我们所用的各种方式将 JSON 解析后得到的字典
    //下面用于在 TextView 中显示解析成功的JSON实际内容
    if (CompanysDic) {
        for (NSDictionary * s in CompanysDic) {
            [companyArray addObject:[s objectForKey:@"title"]];
        }
        companys =  companyArray;
    }else{
        NSLog(@"公司列表为空！");
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
    NSLog(@"获取公司名称列表结束:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
    finished=YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:@"网络请求超时" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}
@end
