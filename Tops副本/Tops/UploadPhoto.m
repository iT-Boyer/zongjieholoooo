//
//  UploadPhoto.m
//  Tops
//
//  Created by Ding Sheng on 13-5-21.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "UploadPhoto.h"
#import"HJManagedImageV.h"  //HJManagedImageV是图片缓存类，可以用其它异步加载图片类取代
#import "JSONKit.h"
#import "TopsTools.h"
@implementation UploadPhoto


//缩放图片处理
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // 创建一个bitmap的context 并把它设置成为当前正在使用的context
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // 绘制改变大小的图片 
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // 从当前context中创建一个改变大小后的图片 
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈  
    // End the context
    UIGraphicsEndImageContext();
    
    //返回新的改变大小后的图片
    // Return the new image.
    return newImage;
}

#pragma mark 保存图片到document
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    //获取保存路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    //如果文件已存在，先做删除操作
    [TopsTools deleteFileExist:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

- (BOOL)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage Delegate:(id)selfd
{
    NSURL *url = [NSURL URLWithString:UPLOAD_SERVER_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    NSString *imsi = [userDefaults objectForKey:BlueToothMACKEY];
    [request setPostValue:imsi forKey:@"imsi"];
    [request setFile:midImage forKey:@"file"];
//    [Request setData:UIImagePNGRepresentation(img)forKey:@"file"];
    [request buildPostBody];
    [request setDelegate:selfd];
    [request setTimeOutSeconds:120.0];
    //设置获取到返回值时，客户端的提示信息
    [self checkRequestString2:request];
    //发出请求
    [request startSynchronous];
    [userDefaults release];
    return YES;
}

//当以普通形式请求时...
-(void)checkRequestString2:(id)request
{
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        if([responseString isEqualToString:@"1"]){
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:@"图片上传成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
            [av show];
//            [av release];
        }else{
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:@"图片上传失败!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
//            [av release];
        }
    }];
    
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@,%@", error.localizedDescription,nil);
    }];
    
    
}



//当以application/json格式请求时
-(void)checkRequestString1:(id)request
{
    //    [request setRequestMethod:@"POST"];
    //    [request addRequestHeader:@"Content-Type"value:@"application/json"];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        NSDictionary *info = [responseString objectFromJSONString];
        NSLog(@"上传图片返回的值:%@",info);
        NSNumber *status = [info objectForKey:@"status"];
        if([status intValue]==1){
            //            HJManagedImageV *mi = (HJManagedImageV *)[selfd.view view WithTag:777];
            //            //set the URL that we want the managed image view to load
            //            [mi clear];
            //            mi.url = [NSURL URLWithString:[info objectForKey:@"filePath"]];
            //            [mi showLoadingWheel];
            //            mi.tag = 777 ;
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:@"图片上传成功!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
            
        }else if([status intValue]==-1){
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:[info objectForKey:@"msg"]delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
        }else{
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:[info objectForKey:@"msg"]delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@,%@", error.localizedDescription,nil);
    }];
    
    
}



-(void)uploadPortraitTask:(NSDictionary *)info Delegate:(id)selfd{
    // Do something usefull in here instead of sleeping ...
    NSURL *URL = [NSURL URLWithString:UPLOAD_SERVER_URL];
    ASIFormDataRequest *Request = [ASIFormDataRequest requestWithURL:URL];
    [Request setRequestMethod:@"POST"];
    [Request addRequestHeader:@"Content-Type"value:@"application/json"];
    [Request setTimeOutSeconds:60];
    
    //[Request setPostValue:auth forKey:@"auth"];
    UIImage *img = [self imageWithImageSimple:[info objectForKey:@"UIImagePickerControllerOriginalImage"]scaledToSize:CGSizeMake(300,300)];
    
    [Request setData:UIImagePNGRepresentation(img) forKey:@"file"];
    
    [Request setDelegate:self];
    
    [Request setCompletionBlock:^{
        
        NSString *responseString = [Request responseString];
        //NSLog(@"Response: %@", responseString);
        NSDictionary *info = [responseString objectFromJSONString];
        NSNumber *status = [info objectForKey:@"status"];
        if([status intValue]==1){
//            HJManagedImageV *mi = (HJManagedImageV *)[selfd.view view WithTag:777];
            //set the URL that we want the managed image view to load
//            [mi clear];
//            mi.url = [NSURL URLWithString:[info objectForKey:@"filePath"]];
//            [mi showLoadingWheel];
//            mi.tag = 777 ;
//            IBMEventAppDelegate *appDelegate = (IBMEventAppDelegate *)[[[UIApplication sharedApplication] delegate];
            //[mi setCallbackOnImageTap:self method:@selector(uploadPortrait:)];
//            [appDelegate.objMan manage:mi];
//            [appDelegate loadLoginInfoData];
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:@"图片上传成功!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
            
        }else if([status intValue]==-1){
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:[info objectForKey:@"msg"]delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
        }else{
            UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:[info objectForKey:@"msg"]delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
            [av show];
        }
//        [MBProgressHUDhideHUDForView:selfd.navigationController.view animated:YES];
    }];
    
    
    [Request setFailedBlock:^{
        NSError *error = [Request error];
        NSLog(@"Error: %@,%@", error.localizedDescription,Request.url);
    }];
    
    
    [Request startSynchronous];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error){
        UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
        [av show];
    }else{
        UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil]autorelease];
        [av show];
    }
    
}
@end
