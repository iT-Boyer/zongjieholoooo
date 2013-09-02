//
//  DownLoadPhoto.h
//  Tops
//
//  Created by Ding Sheng on 13-5-22.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue;
@interface DownLoadPhoto : NSObject
{
    ASINetworkQueue *networkQueue;
//    UIImage *photo;
    BOOL failed;
    
    UIProgressView *progressIndicator;
	UISwitch *accurateProgress;
	UIProgressView *imageProgressIndicator1;
	UIProgressView *imageProgressIndicator2;
	UIProgressView *imageProgressIndicator3;
}
@property (nonatomic,retain)UIImage *photo;

-(BOOL)downLoadPhoto:(NSString *)imgHttpPath ImgPath:(NSString *)imgpath;
@end
