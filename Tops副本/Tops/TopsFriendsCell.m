//
//  TopsFriendsCell.m
//  Tops
//
//  Created by Ding Sheng on 13-3-29.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsFriendsCell.h"

@implementation TopsFriendsCell

@synthesize fnameLabel=_fnameLabel;
@synthesize fsexImageLabel=_fsexImageLabel;
@synthesize fcompanyLabel=_fcompanyLabel;
@synthesize froleLabel=_froleLabel;
@synthesize fphoneLabel=_fphoneLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fnameLabel release];
    [_fsexImageLabel release];
    [_fcompanyLabel release];
    [_froleLabel release];
    [_fphoneLabel release];
    [super dealloc];
}
@end
