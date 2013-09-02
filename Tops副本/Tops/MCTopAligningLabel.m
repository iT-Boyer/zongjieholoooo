//
//  MCTopAligningLabel.m
//  MCTopAligningLabel
//
//  Created by Baglan on 11/29/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCTopAligningLabel.h"

@implementation MCTopAligningLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//      [self initWithFrame:CGRectMake(5, 20, 200, 150)];
    }
    return self;
}
- (void)setText:(NSString *)text
{
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.frame = frame;
    self.transform = transform;
    
    [super setText:text];
}

@end
