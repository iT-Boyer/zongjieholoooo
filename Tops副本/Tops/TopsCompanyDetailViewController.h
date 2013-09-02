//
//  TopsCompanyDetailViewController.h
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsCompanyDetailViewController : UIViewController

@property(nonatomic,retain)NSString *companyname;
@property(nonatomic,retain)NSString *cphone,*caddress,*cfax,*cemail,*miaoshu,*curl;
@property (retain, nonatomic) IBOutlet UILabel *companynameField;

@property (retain, nonatomic) IBOutlet UILabel *ctelField;
@property (retain, nonatomic) IBOutlet UILabel *cfaxField;
@property (retain, nonatomic) IBOutlet UILabel *cemailField;
@property (retain, nonatomic) IBOutlet UILabel *curlField;
@property (retain, nonatomic) IBOutlet UILabel *caddressField;

@property (retain, nonatomic) IBOutlet UITextView *miaoshuField;
//@property (retain, nonatomic) IBOutlet UILabel *miaoshuField;
@end
