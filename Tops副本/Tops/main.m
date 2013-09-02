//
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopsAppDelegate.h"

int main(int argc, char *argv[])
{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;

//    @autoreleasepool {
//        
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TopsAppDelegate class]));
//    }
}
