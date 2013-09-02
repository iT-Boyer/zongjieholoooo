//
//  TopsInfosDetail_webViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-24.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsInfosDetail_webViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIWebView *infosDetailView;
@property(retain,nonatomic)NSString *infotitle;
@property (retain, nonatomic)NSString *infosId;

//UIWebView主要有下面几个委托方法：
//
//1、- (void)webViewDidStartLoad:(UIWebView *)webView;开始加载的时候执行该方法。
//2、- (void)webViewDidFinishLoad:(UIWebView *)webView;加载完成的时候执行该方法。
//3、- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;加载出错的时候执行该方法。
@end
