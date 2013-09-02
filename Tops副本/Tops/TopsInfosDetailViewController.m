//
//  TopsInfosDetailViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-8.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsInfosDetailViewController.h"

@interface TopsInfosDetailViewController ()

@end

@implementation TopsInfosDetailViewController

@synthesize infocontent,infotitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    //试图控制器动态加载视图
    textDemoView = [[WKTextDemoView alloc] initWithFrame:CGRectZero];
    [self setView:textDemoView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置公告标题，在标题栏显示
    self.title = self.infotitle;
    //设置滚动的文本框，显示公告正文
    [[textDemoView textLabel] setText:self.infocontent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)dealloc {
    [textDemoView release];
    [super dealloc];
}
@end
