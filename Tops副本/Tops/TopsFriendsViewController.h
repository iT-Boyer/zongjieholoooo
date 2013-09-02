//
//  TopsFriendsViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-3-28.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsFriendsViewController : UITableViewController


@property(nonatomic,strong)NSMutableArray *names,*sex,*companys,*roles,*phones;

-(void)setValueOfTableCell;
@end
