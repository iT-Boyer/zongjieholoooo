//
//  TopsRegisterViewController.m
//  Tops
//
//  Created by 鼎昇 on 13-3-13.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsUpdateMyInfoViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "CustomAutoCompleteCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchivingData.h"
#import "JSONKit.h"
#import "SBJson.h"
#import "TopsTools.h"
#import "TopsGetBlueMac.h"
#import "GetCompanysList.h"

#import "UpdateInfoHttp.h"
#import "UploadPhoto.h"
#import "TopsAppDelegate.h"

#import "ExitOrLoginHttp.h"
#import "TopsLoginViewController.h"
// Safe releases  安全释放所有对象的实例变量
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT            8
//#define BIRTHDAY_FIELD_TAG    5
#define GENDER_FIELD_TAG        5
#define COMPANY_FIELD_TAG       8


@implementation TopsUpdateMyInfoViewController
{
    NSData *m_JsonData;
    NSArray *CompanysList;
}

@synthesize nameTextField = nameTextField_;
@synthesize lastNameTextField = lastNameTextField_;
@synthesize roleTextField = roleTextField_;
@synthesize companyTextField = companyTextField_;
@synthesize genderTextField = genderTextField_;
@synthesize phoneTextField = phoneTextField_;
@synthesize photoButton = photoButton_;
@synthesize termsTextView = termsTextView_;

@synthesize emailField = emailTextField_;
@synthesize qqField = qqTextField_;

@synthesize roleLabel = roleLabel_;
@synthesize companyLabel = companyLabel_;
@synthesize genderLabel = genderLabel_;
@synthesize phoneLabel = phoneLabel_;

@synthesize emailLabel = emailLabel_;
@synthesize qqLabel = qqLabel_;

@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize genderPickerView = genderPickerView_;

//@synthesize companysList=companyList_;

@synthesize gender = gender_;
@synthesize photo = photo_;

@synthesize archivingFilePath;

@synthesize Exit = _Exit;


//该操作报错，需点击项目名-选择"Build Settings"标签页，关闭Objective-C Automatic Reference Counting，即将参数值设置为no

- (void) dealloc
{
    RELEASE_SAFELY(nameTextField_);
    RELEASE_SAFELY(lastNameTextField_);
    RELEASE_SAFELY(roleTextField_);
    RELEASE_SAFELY(companyTextField_);
    RELEASE_SAFELY(genderTextField_);
    RELEASE_SAFELY(phoneTextField_);
    RELEASE_SAFELY(photoButton_);
    RELEASE_SAFELY(termsTextView_);
    
    RELEASE_SAFELY(roleLabel_);
    RELEASE_SAFELY(companyLabel_);
    RELEASE_SAFELY(genderLabel_);
    RELEASE_SAFELY(phoneLabel_);
    
    RELEASE_SAFELY(keyboardToolbar_);
    RELEASE_SAFELY(genderPickerView_);
    
    RELEASE_SAFELY(gender_);
    RELEASE_SAFELY(photo_);
    
    RELEASE_SAFELY(emailTextField_);
    RELEASE_SAFELY(qqTextField_);
    RELEASE_SAFELY(qqLabel_);
    RELEASE_SAFELY(emailLabel_);
    //    RELEASE_SAFELY(companyList_);
    [_Exit release];
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Signup button 注册按钮初始化
    UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(signup:)];
    self.navigationItem.rightBarButtonItem = signupBarItem;
    [signupBarItem release];
    
    
    // Gender picker 性别下拉框
    if (self.genderPickerView == nil) {
        self.genderPickerView = [[UIPickerView alloc] init];
        self.genderPickerView.delegate = self;
        self.genderPickerView.showsSelectionIndicator = YES;
    }
    
    
    if (self.keyboardToolbar==nil) {
        self.keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle=UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"previous", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"next", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneBarItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem,nextBarItem,spaceBarItem,doneBarItem,nil]];
        
        
        self.nameTextField.inputAccessoryView=self.keyboardToolbar;
        self.lastNameTextField.inputAccessoryView=self.keyboardToolbar;
        self.roleTextField.inputAccessoryView=self.keyboardToolbar;
        self.phoneTextField.inputAccessoryView=self.keyboardToolbar;
        self.genderTextField.inputAccessoryView=self.keyboardToolbar;
        self.genderTextField.inputView=self.genderPickerView;
        self.companyTextField.inputAccessoryView=self.keyboardToolbar;
        
        self.emailField.inputAccessoryView=self.keyboardToolbar;
        self.qqField.inputAccessoryView=self.keyboardToolbar;//控制虚拟键盘是否可用，和toolbar是否有效...否则:工具条不显示，键盘无法输入文本域
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    
    //初始化Lable标签内容
    self.nameTextField.placeholder = NSLocalizedString(@"first_name", @"");
    self.lastNameTextField.placeholder = NSLocalizedString(@"last_name", @"");
    self.roleLabel.text = [NSLocalizedString(@"职称:", @"") uppercaseString];
    self.genderLabel.text = [NSLocalizedString(@"性别:", @"") uppercaseString];
    self.phoneLabel.text = [NSLocalizedString(@"电话:", @"") uppercaseString];
    self.emailLabel.text = [NSLocalizedString(@"邮箱:", @"") uppercaseString];
    self.qqLabel.text = [NSLocalizedString(@"QQ:", @"") uppercaseString];
    
    self.phoneTextField.placeholder = NSLocalizedString(@"optional", @"");
    self.termsTextView.text = NSLocalizedString(@"terms", @"");
    
    // Reset labels colors 重设字体颜色
    [self resetLabelsColors];
    
    //是否有注册存档
    [self checkArchivingExist];
    NSLog(@"头像加载:%@",photo_);
    UIImage *ImgOfPhoto = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",photo_]];
    NSLog(@"touxiang :%@",ImgOfPhoto);
    [self.photoButton setImage:ImgOfPhoto forState:UIControlStateNormal];
    //使用GCD，开一个线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // load your image here
//        UIImage *largeImage = [UIImage imageNamed:@"YourLargeImage.png"];
//        NSLog(@"头像加载:%@",photo_);
//        UIImage *ImgOfPhoto = [UIImage imageNamed:photo_];
//         [self.photoButton setImage:ImgOfPhoto forState:UIControlStateHighlighted];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // use large image on main thread
////            UIImageView *largeImageView = [[[UIImageView alloc] initWithImage:largeImage] autorelease];
//            [self.photoButton setImage:ImgOfPhoto forState:UIControlStateHighlighted];
//
//        
//        });
    });
    //添加自动填充功能 companyTextField
    [self autoComplete];
    
    //给下拉列表赋值
    GetCompanysList *gg = [[GetCompanysList alloc]init];
    [gg getCompanys];
    CompanysList = gg.companys;
    [gg release];
    //公司列表显示设置
    //  [self.companyTextField registerAutoCompleteCellClass:[CustomAutoCompleteCell class] forCellReuseIdentifier:@"CustomCellId"];
    
    //    [TopsTools getIMSI];
    //    [TopsGetBlueMac doMacTest()];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setAlpha:0];
    [UIView animateWithDuration:0.2 delay:0.25 options:UIViewAnimationCurveEaseOut animations:^{[self.view setAlpha:1.0];} completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


#pragma mark - Others

-(IBAction)exitApp
{
    //退出操作
    ExitOrLoginHttp *login = [[[ExitOrLoginHttp alloc]init] autorelease];
    [login loginOrExit:@"1"];
    TopsLoginViewController *detailViewController = [[TopsLoginViewController alloc] initWithNibName:@"TopsLoginViewController" bundle:nil];
    [self presentModalViewController:detailViewController animated:YES];
    [detailViewController release];
}
- (void)signup:(id)sender
{
    //存档
    [self cundang];
    
    UpdateInfoHttp *rh = [[UpdateInfoHttp alloc] init];
    NSString * finished = [rh updateMyInfo:[[ArchivingData alloc]initWithFirstname:self.nameTextField.text Lastname:self.lastNameTextField.text Role:self.roleTextField.text Phone:self.phoneTextField.text gender:self.gender Company:self.companyTextField.text Email:self.emailField.text Qq:self.qqField.text]];
    [rh release];
    
    if ([finished isEqualToString:@"1"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新..." message:@"更新成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新失败！" message:@"请稍后再试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [finished release];
}


#pragma mark - 虚拟键盘的弹出控制
//虚拟键盘的工具棒上的done按钮的具体实现
-(void)resignKeyboard:(id)sender
{
    id firstResponder=[self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors];
    }
}

//通过Return关闭
-(IBAction)textFieldReturnEditing:(id)sender
{
    //    [sender resignFirstResponder];
    
    [self resignKeyboard:nil];
}

//通过点击屏幕关闭
-(IBAction)backgroundTap:(id)sender
{
    //    [nameTextField_ resignFirstResponder];
    //    [lastNameTextField_ resignFirstResponder];
    //    [phoneTextField_ resignFirstResponder];
    //    [roleTextField_ resignFirstResponder];
    //    [genderTextField_ resignFirstResponder];
    //    [companyTextField_ resignFirstResponder];
    [self resignKeyboard:nil];
}


//虚拟键盘的工具棒上的previous按钮的具体实现
-(void)previousField:(id)sender
{
    id firstResponder=[self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag=[firstResponder tag];
        NSUInteger previousTag=tag==1?1:tag-1;
        
        //        NSLog(@"点击previous按钮：%d", previousTag);
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField *previousField=(UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        UILabel *nextLabel=(UILabel *)[self.view viewWithTag:previousTag+10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[TopsUpdateMyInfoViewController labelSelectedColor]];
        }
        [self checkSpecialFields:previousTag];
    }
}

//虚拟键盘的工具棒上的next按钮的具体实现
-(void)nextField:(id)sender
{
    id firstResponder=[self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag=[firstResponder tag];
        NSUInteger nextTag=tag==FIELDS_COUNT?FIELDS_COUNT:tag+1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField=(UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        UILabel *nextLabel=(UILabel *)[self.view viewWithTag:nextTag+10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[TopsUpdateMyInfoViewController labelSelectedColor]];
        }
        [self checkSpecialFields:nextTag];
    }
}

//根据组件的Tag标签,获取当前光标所在的对象
-(id)getFirstResponder
{
    NSUInteger index=1;
    while (index <= FIELDS_COUNT) {
        id textField=[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    return NO;
}
//设置标签颜色
- (void)resetLabelsColors
{
    self.roleLabel.textColor = [TopsUpdateMyInfoViewController labelNormalColor];
    self.genderLabel.textColor = [TopsUpdateMyInfoViewController labelNormalColor];
    self.phoneLabel.textColor = [TopsUpdateMyInfoViewController labelNormalColor];
    self.companyLabel.textColor=[TopsUpdateMyInfoViewController labelNormalColor];
    self.emailLabel.textColor=[TopsUpdateMyInfoViewController labelNormalColor];
    self.qqLabel.textColor=[TopsUpdateMyInfoViewController labelNormalColor];
}

+ (UIColor *)labelNormalColor
{
    return [UIColor colorWithRed:0.016 green:0.216 blue:0.286 alpha:1.000];
}

+ (UIColor *)labelSelectedColor
{
    return [UIColor colorWithRed:0.114 green:0.600 blue:0.737 alpha:1.000];
}

//通过输入框焦点位置，上下移动整个屏幕...
-(void)animateView:(NSUInteger)tag
{
    CGRect rect=self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (tag>1) {    //tag控制页面输入焦点在第几个文本域时，整体上移
        rect.origin.y=-44.0f * (tag - 1);
    }else{
        rect.origin.y=0;
    }
    self.view.frame=rect;
    [UIView commitAnimations];
}

//通过焦点的所在的位置，判断虚拟键盘的previous 和 next按钮是否可用
-(void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem=(UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    
    UIBarButtonItem *nextBarItem=(UIBarButtonItem *)[[self.keyboardToolbar items]objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

//检查特殊的文本域即:下拉框
-(void)checkSpecialFields:(NSUInteger)tag
{
    if (tag == GENDER_FIELD_TAG && [self.genderTextField.text isEqualToString:@""]) {
        [self setGenderData];
    }
}

//选择下拉框并选择性别
-(void)setGenderData
{
    if ([self.genderPickerView selectedRowInComponent:0]==0) {
        self.genderTextField.text= NSLocalizedString(@"male", @"");
        self.gender=@"M";
    }else{
        self.genderTextField.text=NSLocalizedString(@"female", @"");
        self.gender=@"F";
    }
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}




#pragma mark - UIPickerViewDelegate
//性别下拉框的主要设置
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = row == 0 ?[UIImage imageNamed:@"male.png"]:[UIImage imageNamed:@"female.png"];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    imageView.frame=CGRectMake(0,0,32,32);
    UILabel *genderLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 32)];
    genderLabel.text=[row == 0 ? NSLocalizedString(@"male", @"") : NSLocalizedString(@"female", @"") uppercaseString];
    
    genderLabel.textAlignment=NSTextAlignmentLeft;
    genderLabel.backgroundColor=[UIColor clearColor];
    
    UIView *rowView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 32)] autorelease];
    [rowView insertSubview:imageView atIndex:0];
    [rowView insertSubview:genderLabel atIndex:1];
    
    [imageView release];
    [genderLabel release];
    
    return rowView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setGenderData];
}


#pragma mark - UITextFieldDelegate
//触发TextFiled点击事件的入口
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    NSLog(@"当前文本域的tag值:%d",tag);
    [self animateView:tag];
    [self checkBarButton:tag];
    [self checkSpecialFields:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[TopsUpdateMyInfoViewController labelSelectedColor]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger tag = [textField tag];
    if (tag == GENDER_FIELD_TAG) {
        return NO;
    }
    //实现下拉效果，该方法仅适用于iPad浏览器...
    else if(tag==COMPANY_FIELD_TAG){
        NSLog(@"查询的值:%@",string);
        //    [companyList_ showCompanyListFor:textField ShouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}



#pragma mark 设置头像
-(IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""),NSLocalizedString(@"take_photo_from_library", @""), nil];
    }else{
        choosePhotoActionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"choose_photo", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"choose_photo_from_library", @""), nil];
    }
    [choosePhotoActionSheet showInView:self.view];
    [choosePhotoActionSheet release];
}

#pragma mark 设置头像时，必备的API方法

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType=0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType=UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    }else{
        if (buttonIndex==1) {
            return;
        }else{
            sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    imagePickerController.delegate=self;
    imagePickerController.allowsEditing=YES;
    imagePickerController.sourceType=sourceType;
    [self presentModalViewController:imagePickerController animated:YES ];
}

//获取到图片后，保存上传头像操作
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UploadPhoto *loadPhoto = [[UploadPhoto alloc]init];
    
    //缩放图片，返回UIImage
    UIImage *midImage = [loadPhoto imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
    
    //获取IMSI值，作为头像图片名
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    NSString *midImageName = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:BlueToothMACKEY],@".png"];
    [userDefaults release];
    
    //去掉IMSI中的冒号“:”
     midImageName = [midImageName stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    //保存图片到本地...并返回绝对路径
    NSString *midImagePath = [loadPhoto saveImage:midImage WithName:midImageName];
    NSLog(@"保存到本地的头像名:%@",midImagePath);
    
    //上传头像到服务器
    BOOL rr = [loadPhoto upLoadSalesBigImage:nil MidImage:midImagePath SmallImage:nil Delegate:self];
    
    if (rr) {
        UIImage *tt = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.photoButton setImage:tt forState:UIControlStateNormal];
    }
    [self dismissModalViewControllerAnimated:YES];
    //    [self refreshData];
    [picker release];
    [loadPhoto release];
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark 永久性存档注册数据

-(void)checkArchivingExist
{
    //检索本地目录文件 注意:若错将NSDocumentDirectory写成NSDocumentationDirectory时,相应的目录下不会新建存档文件的
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory=[paths objectAtIndex:0];
    self.archivingFilePath=[TopsTools getFilePathOfdocumentsDirectory:kArchivingFileKey];
    NSLog(@"存档名称:%@",self.archivingFilePath);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.archivingFilePath]){
        NSLog(@"进入前读档");
        //读文件数据
        NSData *data=[[[NSMutableData alloc]initWithContentsOfFile:self.archivingFilePath] autorelease];
        NSKeyedUnarchiver *unarchiver=[[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
        ArchivingData *archivingData=[unarchiver decodeObjectForKey:kArchivingDataKey];
        [unarchiver finishDecoding];
        photo_ =archivingData.photo;
        nameTextField_.text=archivingData.firstname;
        lastNameTextField_.text=archivingData.lastname;
        phoneTextField_.text=archivingData.phone;
        roleTextField_.text=archivingData.role;
        genderTextField_.text=archivingData.gender;
        if ([genderTextField_.text isEqualToString:@"female"]) {
            gender_=@"F";
        }else{
            gender_=@"M";
        }
        
        companyTextField_.text=archivingData.company;
        emailTextField_.text=archivingData.email;
        qqTextField_.text=archivingData.qq;
    }else{
        NSLog(@"第一次没有存档");
    }
    
    UIApplication *app=[UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification
                                              object:app];
}

//当界面进入后台运行时,存档数据操作
-(void)applicationWillResignActive:(NSNotification *)notification
{
    [self cundang];
}

-(void)cundang
{
    NSLog(@"开始存档");
    ArchivingData *archivingData=[[[ArchivingData alloc] init] autorelease];
//    archivingData.photo=self.photo;
    //获取IMSI值，作为头像图片名
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    NSString *midImageName = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:BlueToothMACKEY],@".png"];
    [userDefaults release];
    //去掉IMSI中的冒号“:”
    midImageName = [midImageName stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *imgPath = [TopsTools getFilePathOfdocumentsDirectory:midImageName];
    archivingData.photo=imgPath;
    
    archivingData.firstname=self.nameTextField.text;
    archivingData.lastname=self.lastNameTextField.text;
    archivingData.phone=self.phoneTextField.text;
    archivingData.role=self.roleTextField.text;
    archivingData.gender=self.genderTextField.text;
    archivingData.company=self.companyTextField.text;
    archivingData.email=self.emailField.text;
    archivingData.qq = self.qqField.text;
    NSMutableData *data=[[[NSMutableData alloc]init] autorelease];
    NSKeyedArchiver *archiver=[[[NSKeyedArchiver alloc]initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:archivingData forKey:kArchivingDataKey];
    [archiver finishEncoding];
    [data writeToFile:self.archivingFilePath atomically:YES];
    NSLog(@"存档成功:%@",archivingFilePath);
}


#pragma mark 自定义AutoCompleteTextField 公司名称自动填充功能 即:Google，百度,搜索功能
-(void)autoComplete
{
    //设置单元格的点击事件...显示下拉框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    //....隐藏下拉框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    //给输入框添加显示样式
//       [self.companyTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    //输入框和下拉框绑定
    [self.companyTextField registerAutoCompleteCellClass:[CustomAutoCompleteCell class] forCellReuseIdentifier:@"CustomCellId"];
    
}

//弹出虚拟键盘时，相关设置
-(void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    //    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^{CGPoint adjust;
    //        switch(self.interfaceOrientation)
    //        {
    //            case UIInterfaceOrientationLandscapeLeft:
    //                adjust=CGPointMake(-110, 0);
    //            break;
    //            case UIInterfaceOrientationLandscapeRight:
    //                adjust=CGPointMake(110, 0);
    //            break;
    //            default:
    //                adjust=CGPointMake(0, 0);
    //            break;
    //        }
    //     CGPoint newCenter=CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
    //     [self.view setCenter:newCenter];
    //
    //     } completion:nil];
    
}

//隐藏虚拟键盘时的相关设置
-(void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    //    [UIView animateWithDuration:0.3
    //                          delay:0
    //                        options:UIViewAnimationCurveEaseOut
    //                     animations:^{
    //                         CGPoint adjust;
    //                         switch (self.interfaceOrientation) {
    //                             case UIInterfaceOrientationLandscapeLeft:
    //                                 adjust = CGPointMake(110, 0);
    //                                 break;
    //                             case UIInterfaceOrientationLandscapeRight:
    //                                 adjust = CGPointMake(-110, 0);
    //                                 break;
    //                             default:
    //                                 adjust = CGPointMake(0, 120);
    //                                 break;
    //                         }
    //                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
    //                         [self.view setCenter:newCenter];
    ////                         [self.author setAlpha:1];
    ////                         [self.demoTitle setAlpha:1];
    //                     }
    //                     completion:nil];
    
    //点击下啦选项后，屏幕回复原位...实现虚拟键盘的Done按钮的效果
    //  [self resignKeyboard:nil];
    [self animateView:1];
    [self resetLabelsColors];
    
    
    //控制第二次查询时，是否再次打开下拉框
    [self.companyTextField setAutoCompleteTableViewHidden:NO];
    
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}


#pragma mark - MLPAutoCompleteTextField DataSource
-(NSArray *)possibleAutoCompleteSuggestionsForString:(NSString *)string
{
    return CompanysList;
    
}



#pragma mark - MLPAutoCompleteTextField Delegate
-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField shouldConfigureCell:(UITableViewCell *)cell withAutoCompleteString:(NSString *)autocompleteString withAttributedString:(NSAttributedString *)boldedString forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置下拉单元格的图标
    //    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    //    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    //    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    //    [cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
    
}


//#pragma mark UIPopverController 只能用于Ipad浏览器才能显示下拉效果
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    //    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        NSArray *array=[NSArray arrayWithObjects:@"123",
//                        @"abandon vt.丢弃；放弃，抛弃",
//                        @"ability n.能力；能耐，本领",
//                        @"able a.有能力的；出色的",
//                        @"abnormal a.不正常的；变态的",
//                        @"aboard ad.在船(车)上；上船",
//                        @"about prep.关于；在…周围",
//                        @"above prep.在…上面；高于",
//                        @"abroad ad.(在)国外；到处",
//                        @"absence n.缺席，不在场；缺乏",nil];
//        
////        self.companysList=[[[CompanyList alloc]initWithArray:array]autorelease];
//    }
//    return self;
//}


























@end
