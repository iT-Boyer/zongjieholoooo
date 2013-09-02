//
//  TopsUpdateMyInfoViewController.h
//  Tops
//
//  Created by 鼎昇 on 13-3-13.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "CompanyList.h"

@class MLPAutoCompleteTextField;
@interface TopsUpdateMyInfoViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate ,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate> {
    UITextField *nameTextField_;
    UITextField *lastNameTextField_;
    UITextField *phoneTextField_;
    UITextField *roleTextField_;
    UITextField *genderTextField_;
    MLPAutoCompleteTextField *companyTextField_;
    UITextField *emailTextField_;
    UITextField *qqTextField_;
    
    
    //头像按钮
    UIButton *photoButton_;
    UITextView *termsTextView_;
    
    
    UILabel *roleLabel_;
    UILabel *companyLabel_;
    UILabel *genderLabel_;
    UILabel *phoneLabel_;
    
    UILabel *emailLabel_;
    UILabel *qqLabel_;
    
    UIToolbar *keyboardToolbar_;
    UIPickerView *genderPickerView_;
    
    NSString *gender_;
    NSString *photo_;
}

@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property(nonatomic, retain) IBOutlet UITextField *roleTextField;
@property(nonatomic, retain) IBOutlet UITextField *genderTextField;
@property(nonatomic, retain) IBOutlet UITextField *phoneTextField;
@property(weak) IBOutlet MLPAutoCompleteTextField *companyTextField;

@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UITextField *qqField;

//@property(assign) IBOutlet UITextField *companyTextField;
//@property(retain) CompanyList *companysList;


@property(nonatomic, retain) IBOutlet UIButton *photoButton;
@property(nonatomic, retain) IBOutlet UITextView *termsTextView;

@property(nonatomic, retain) IBOutlet UILabel *roleLabel;
@property(nonatomic, retain) IBOutlet UILabel *companyLabel;
@property(nonatomic, retain) IBOutlet UILabel *genderLabel;
@property(nonatomic, retain) IBOutlet UILabel *phoneLabel;

@property (retain, nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UILabel *qqLabel;

@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property(nonatomic, retain) UIPickerView *genderPickerView;

@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *photo;

@property(copy,nonatomic) NSString *archivingFilePath;

- (IBAction)choosePhoto:(id)sender;

- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;
- (void)setGenderData;
- (void)signup:(id)sender;
- (void)resetLabelsColors;

+ (UIColor *)labelNormalColor;
+ (UIColor *)labelSelectedColor;

//点击虚拟键盘中的Return键,关闭键盘
-(IBAction)textFieldReturnEditing:(id)sender;
//点击屏幕时,直接关闭键盘
-(IBAction)backgroundTap:(id)sender;

-(void)applicationWillResignActive:(NSNotification *)notification;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *Exit;

-(IBAction)exitApp;
@end
