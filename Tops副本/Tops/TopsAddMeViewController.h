//
//  TopsAddMeViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-2.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgreeOrRefuse.h"

@interface TopsAddMeViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic,retain)NSMutableArray *companys,*names,*roles,*macs,*mid;

@property (nonatomic,retain)AgreeOrRefuse *aor;
//-(void)setArrayOfTable;

-(IBAction)Refresh:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
