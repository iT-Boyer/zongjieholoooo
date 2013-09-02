//
//  CompanyList.h
//  Tops
//
//  Created by Ding Sheng on 13-4-11.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyList : UITableViewController

-(id)initWithArray:(NSArray *)array;
-(void)showCompanyListFor:(UITextField *)textField ShouldChangeCharactersInRange:(NSRange)rang replacementString:(NSString *)string;

@property(retain)NSArray *stringsArray;
@property(retain)NSArray *matchedStrings;
@property(retain)UIPopoverController *popOver;

@property(assign)UITextField *activeTextField;
@end
