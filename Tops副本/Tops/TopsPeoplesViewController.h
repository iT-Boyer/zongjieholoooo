//
//  TopsPeoplesViewController.h
//  Tops
//
//  Created by 鼎晟中天 on 13-3-18.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface TopsPeoplesViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,GKPeerPickerControllerDelegate, GKSessionDelegate> {
	/*GKSession对象用于表现两个蓝牙设备之间连接的一个会话，你也可以使用它在两个设备之间发送和接收数据。*/

 }
@property (retain, nonatomic) IBOutlet UIBarButtonItem *searchButton;

@property (nonatomic,retain)NSMutableArray *companys,*names,*roles,*macs,*mid,*states;
@property(nonatomic,retain)NSDictionary *companysDic;
-(void)setArrayOfTable;

- (IBAction) connectionButtonTapped:(id) sender;
@end
