//
//  CustomAutoCompleteCell.m
//  Tops
//
//  Created by Ding Sheng on 13-4-9.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import "CustomAutoCompleteCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomAutoCompleteCell

- (id)init
{
    self=[super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [self initialize];
}

-(void)initialize
{
    [self setSelectedBackgroundView:[self orangeSelectedBackgroundView]];
    
}

//设置单元行被选择时的样式...
-(UIView *)orangeSelectedBackgroundView
{
    UIView *selectecBackgroundView=[[UIView alloc]initWithFrame:self.bounds];
    CAGradientLayer *gradient=[CAGradientLayer layer];
    gradient.frame=selectecBackgroundView.bounds;
    gradient.colors=@[(id)[[UIColor orangeColor] CGColor],(id)[[UIColor colorWithRed:225/255.0 green:100/255.0 blue:0/255.0 alpha:1.0]CGColor]];
    [selectecBackgroundView.layer insertSublayer:gradient atIndex:1];
    return selectecBackgroundView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"单元格的Identifier:%@",reuseIdentifier);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}


@end
