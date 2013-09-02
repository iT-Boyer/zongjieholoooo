//
//  Record.h
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Infos : NSObject {
	int iid;
	NSString *title;
    NSString *time;
	NSString *content;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *content;

- (id)initWithIndex:(int)newIid Title:(NSString *)newTitle Time:(NSString *)newTime Content:(NSString *)newContent;
- (int)getIid;

@end
