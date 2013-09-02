//
//  Record.m
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import "Infos.h"

@implementation Infos

@synthesize title, time, content;

- (id)initWithIndex:(int)newIid Title:(NSString *)newTitle Time:(NSString *)newTime Content:(NSString *)newContent
{
	if(self = [super init])
    {
		iid = newIid;
		self.title = newTitle;
        self.time = newTime;
		self.content = newContent;
	}
	return self;
}

- (int)getIid{
	return iid;
}

- (void)dealloc {
	[title release];
    [time release];
	[content release];
	[super dealloc];
}

@end