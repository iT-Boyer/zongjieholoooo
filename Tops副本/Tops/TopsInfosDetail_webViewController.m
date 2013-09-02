//
//  TopsInfosDetail_webViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-24.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsInfosDetail_webViewController.h"

@interface TopsInfosDetail_webViewController ()

@end

@implementation TopsInfosDetail_webViewController
{
    NSData *JsonData;
    BOOL finished;
}

@synthesize infosDetailView=_infosDetailView,infosId = _infosId,infotitle=_infotitle;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _infotitle;
	// Do any additional setup after loading the view.
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",URL_OF_INFOS_BY_INFOSID,_infosId];
    NSLog(@"路径:%@",urlstr);
    // NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:urlstr ofType:nil]];
    NSURL *url=[NSURL URLWithString:urlstr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_infosDetailView loadRequest:request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"公告网页开始加载...");
}
//2、加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"公告网页加载完成！");
}
//3、加载出错的时候执行该
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    [alterview release];

}

- (void)dealloc {
    [_infosDetailView release];
    [super dealloc];
}
@end
