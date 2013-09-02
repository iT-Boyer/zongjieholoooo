//
//  TopsCompanyDetailViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-17.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsCompanyDetailViewController.h"

@interface TopsCompanyDetailViewController ()

@end

@implementation TopsCompanyDetailViewController
{

}

@synthesize caddress,cemail,cphone,cfax,curl,miaoshu;
@synthesize companynameField=_companynameField,
            ctelField = _ctelField,
            curlField = _curlField,
            cemailField = _cemailField,
            cfaxField = _cfaxField,
            caddressField = _caddressField,
            miaoshuField = _miaoshuField;
@synthesize companyname = _companyname;

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
    
    self.companynameField.text = self.companyname;
    self.ctelField.text = cphone;
    self.curlField.text = curl;
    self.cemailField.text = cemail;
    self.cfaxField.text = cfax;
    self.caddressField.text = caddress;
    self.miaoshuField.text = miaoshu;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_companynameField release];
    [_ctelField release];
    [_cfaxField release];
    [_cemailField release];
    [_curlField release];
    [_caddressField release];
    [_miaoshuField release];
    [super dealloc];
}
@end
