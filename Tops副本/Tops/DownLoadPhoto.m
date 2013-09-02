//
//  DownLoadPhoto.m
//  Tops
//
//  Created by Ding Sheng on 13-5-22.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "DownLoadPhoto.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"


// Private stuff
@interface DownLoadPhoto ()
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageFetchFailed:(ASIHTTPRequest *)request;

@end

@implementation DownLoadPhoto

@synthesize photo;


-(BOOL)downLoadPhoto:(NSString *)imgHttpPath ImgPath:(NSString *)imgpath
{
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}
	failed = NO;
	[networkQueue reset];
	[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
//	[networkQueue setShowAccurateProgress:[accurateProgress isOn]];
	[networkQueue setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:imgHttpPath];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDownloadDestinationPath:imgpath];
//	[request setDownloadProgressDelegate:imageProgressIndicator1];
//    [request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
	[networkQueue addOperation:request];
    
    [networkQueue go];
    //开启一个runloop，使它始终处于运行状态
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    while (!self.photo)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return YES;
}


- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	UIImage *img = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
    
	if (img) {
		self.photo = img;
	}
}


- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
	if (!failed) {
		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to download images" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];
		}
		failed = YES;
	}
}

- (void)dealloc {
	[progressIndicator release];
	[networkQueue reset];
	[networkQueue release];
    [super dealloc];
}


@end
