//
//  TopsInfosDetailViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-8.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTopAligningLabel.h"
#import "WKTextDemoView.h"
@interface TopsInfosDetailViewController : UIViewController
{
    WKTextDemoView *textDemoView;
}

@property(nonatomic,retain)NSString *infotitle;
@property(nonatomic,retain)NSString *infocontent;
@end
