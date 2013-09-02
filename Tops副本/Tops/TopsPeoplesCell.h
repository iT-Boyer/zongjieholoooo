//
//  TopsPeoplesCell.h
//  Tops
//
//  Created by 鼎晟中天 on 13-3-18.
//  Copyright (c) 2013年 鼎盛中天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopsPeoplesCell : UITableViewCell
{
    UILabel *companyLabel_;
    UILabel *nameLabel_;
    UILabel *roleLabel_;
    UIImageView *sexImage_;

}

@property(nonatomic,retain)IBOutlet UILabel *companyLabel;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel;
@property(nonatomic,retain)IBOutlet UILabel *roleLabel;
@property(nonatomic,retain)IBOutlet UIImageView *sexImage;

@end
