//
//  TopsLoginViewController.m
//  Tops
//
//  Created by Ding Sheng on 13-5-30.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsLoginViewController.h"

#import "TopsHuiYiViewController.h"
#import "ExitOrLoginHttp.h"
@interface TopsLoginViewController ()

@end

@implementation TopsLoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)loginApp:(id)sender
{
    ExitOrLoginHttp *login = [[[ExitOrLoginHttp alloc]init] autorelease];
    [login loginOrExit:@"0"];
    TopsHuiYiViewController *huiyiViewCtrl = [[TopsHuiYiViewController alloc] initWithNibName:@"TopsHuiYiViewController" bundle:nil];
    [self presentModalViewController:huiyiViewCtrl animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginBtn release];
    [super dealloc];
}
@end
