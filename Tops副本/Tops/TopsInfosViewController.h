//
//  TopsInfosViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-7.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsInfosViewController : UITableViewController

@property (nonatomic,retain)NSMutableArray *infos;
@property (nonatomic,retain)NSMutableArray *titles;
@property (nonatomic,retain)NSMutableArray *times;

-(IBAction)refresh:(id)sender;
@end
