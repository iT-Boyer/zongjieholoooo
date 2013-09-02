//
//  TopsHuiYiViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-27.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsHuiYiViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>


//@property(nonatomic,retain)NSMutableDictionary *huiyiDics;
@property(nonatomic,retain) NSMutableArray *huiyiArray,*huiyiId;

//@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
