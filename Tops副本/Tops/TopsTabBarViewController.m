//
//  TopsTabBarViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-6-28.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsTabBarViewController.h"

@interface TopsTabBarViewController ()

@end

@implementation TopsTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"tabitemslist" ofType:@"plist"];
    NSMutableDictionary *tabdic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSArray *itemnames = [tabdic objectForKey:@"itemnames"];
    NSArray *itemimages = [tabdic objectForKey:@"itemimages"];
    NSUInteger index1=0;
    NSLog(@"选项卡的个数:%d",[self.tabBar.items count]);
    while (index1 < [self.tabBar.items count]) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:index1];
        item.imageInsets = UIEdgeInsetsMake(4, 0, 4, 0);
        [item setFinishedSelectedImage:[UIImage imageNamed:[itemimages objectAtIndex:index1]] withFinishedUnselectedImage:[UIImage imageNamed:[itemimages objectAtIndex:index1]]];
        [item setTitle:[itemnames objectAtIndex:index1]];
        //    [item setBadgeValue:@"4"];
        index1 ++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
