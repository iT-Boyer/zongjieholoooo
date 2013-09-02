//
//  TopsAppDelegate.h
//  Tops
//
//  Created by 鼎昇 on 13-3-13.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"
#import "TopsPeoplesViewController.h"
//Address Book contact
#define KPHONELABELDICDEFINE		@"KPhoneLabelDicDefine"
#define KPHONENUMBERDICDEFINE	    @"KPhoneNumberDicDefine"
#define KPHONENAMEDICDEFINE	        @"KPhoneNameDicDefine"
#define KPHONEJOBNAMEDICDEFINE      @"kPhoneJobNameDicDefine"
#define KPHONEJOBTILTEDICDEFINE     @"kPhoneJobtitleDicDefine"




//@class ContactsCtrl;

ABAddressBookRef addressBook;
@interface TopsAppDelegate : UIResponder <UIApplicationDelegate , 
ABPersonViewControllerDelegate>
{
}
//@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (retain, nonatomic) IBOutlet UINavigationController *huiyiNavigationController;

@property(nonatomic,retain)NSURLConnection *deviceTokenConnetion;

-(void)resetBadgeNumberOnProviderWithDeviceToken:(id)sender;

-(void)registerForRemoteNotificationToGetToken;

-(void)sendProviderDeviceToken:(id)sender;
@end
