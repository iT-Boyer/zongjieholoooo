//
//  TopsPeoplesCell.m
//  Tops
//
//  Created by 鼎晟中天 on 13-3-18.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "TopsPeoplesCell.h"

@implementation TopsPeoplesCell

@synthesize companyLabel=companyLabel_;
@synthesize nameLabel=nameLabel_;
@synthesize roleLabel=roleLabel_;
@synthesize sexImage=sexImage_;

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

@end
