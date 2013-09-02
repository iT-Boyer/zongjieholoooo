//
//  UploadPhoto.h
//  Tops
//
//  Created by Ding Sheng on 13-5-21.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
@interface UploadPhoto : NSObject <MBProgressHUDDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    MBProgressHUD *HUD;
}


//缩放图片处理
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//保存图片
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

//上传图片
- (BOOL)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage Delegate:(id)selfd;

@end
