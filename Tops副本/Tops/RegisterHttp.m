//
//  RegisterHttp.m
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "RegisterHttp.h"
#import "JSONKit.h"
#import "SBJson.h"
#import "SGMSettingConfig.h"
@implementation RegisterHttp
{
    NSData *m_JsonData;
    BOOL finished;
}


//封装json对象，开始注册
//http://stephen830.iteye.com/blog/1703086
-(NSString *)registerUser:(ArchivingData *)data
{
    
    //     NSString *datastring = [NSString stringWithFormat:@"{\"username\":\"%@ %@\",\"imsi\":\"%@\",\"mac\":\"%@\",\"tel\":\"%@\",\"post\":\"%@\",\"cid\":\"%@\",\"cname\":\"%@\"}",self.nameTextField.text ,self.lastNameTextField.text ,@"myIMSI",@"myMAC", self.phoneTextField.text, self.roleTextField.text, @"6", @"cname"];
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    NSString *mac_imsi = [userDefaults objectForKey:BlueToothMACKEY];
    NSString *token = [userDefaults objectForKey:DeviceTokenStringKEY];
//    token = @"6ae422b42169e1e2ec876ba984146ba8a405d9ee2dcf94442daf45cb93fee31e";

    NSString *datastring=[NSString stringWithFormat:@"username=%@%@&post=%@&cname=%@&tel=%@&mac=%@&imsi=%@&cid=%d&aori=%d&number=%@&sex=%@",data.lastname,data.firstname, data.role,data.company,data.phone,mac_imsi,mac_imsi,0,1,token,data.gender];
    
    NSLog(@"组装json对象：http://192.168.1.222:8080/hz/register%@",datastring);
    
    NSURL *url = [NSURL URLWithString:registerUri];
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

    NSString * MyId;
    if (connection) {
//        receivedData = [[NSMutableData data] retain];
//        NSLog(@"获取到的返回值:%@",MyId);
        MyId = [[NSString alloc] initWithData:m_JsonData encoding:NSUTF8StringEncoding];
        if (![MyId isEqualToString:@"0"]) {
            return MyId;
        }

    }
    return nil;
}


//http://www.cnblogs.com/anmog/archive/2011/03/09/1978621.html
-(BOOL)registerUser2:(ArchivingData *)data
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:registerUri]];
    NSString *datastring = @"a test string";
    
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dlist = [[NSMutableDictionary alloc] init];
    [dlist setObject:[NSString stringWithFormat:@"%@%@",data.lastname,data.firstname] forKey:@"username"];
    [dlist setObject:data.role forKey:@"post"];
    [dlist setObject:data.company forKey:@"cname"];
    [dlist setObject:data.phone forKey:@"tel"];
    [dlist setObject:@"3212323123" forKey:@"mac"];
    [dlist setObject:@"1232222222" forKey:@"imsi"];
    [dlist setObject:@"21" forKey:@"cid"];
    [arrayData addObject:dlist];
    datastring = [arrayData JSONRepresentation];
    
    NSLog(@"组装的JSON值:%@",datastring);
    
    NSData *postData = [datastring dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    //
    NSURLResponse *reponse;
    NSError *error = nil;
    
    //连接服务器
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
    }else {
        if (responseData) {
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"get %@",responseString);
            
            NSMutableDictionary *dgetData = [responseString JSONValue];
            NSLog(@"dgetData: %@" , [dgetData description]);
        }
    }
    [dlist release];
    [arrayData release];
    return YES;
}


//http://stackoverflow.com/questions/4456966/how-to-send-json-data-in-the-http-request-using-nsurlrequest
-(BOOL)registerUser3:(ArchivingData *)data
{
    //     NSString *datastring = [NSString stringWithFormat:@"{\"username\":\"%@ %@\",\"imsi\":\"%@\",\"mac\":\"%@\",\"tel\":\"%@\",\"post\":\"%@\",\"cid\":\"%@\",\"cname\":\"%@\"}",self.nameTextField.text ,self.lastNameTextField.text ,@"myIMSI",@"myMAC", self.phoneTextField.text, self.roleTextField.text, @"6", @"cname"];
    
    
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",data.lastname,data.firstname], data.role, data.phone ,data.company,@"123fff1232",@"78686382738",@"22", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"username", @"post",@"tel",@"cname",@"mac",@"imsi",@"cid", nil];
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:registerUri];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        m_JsonData = [[NSMutableData data] retain];
        NSLog(@"返回结果:%@",m_JsonData);
    }
    return YES;
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
    NSString *jsonString = [[NSString alloc] initWithData:m_JsonData encoding:NSUTF8StringEncoding];
    [jsonString autorelease];
    NSLog(@"注册后，返回的值:%@",jsonString);
    m_JsonData=data;
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
