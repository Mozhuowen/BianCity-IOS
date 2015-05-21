//
//  CacheTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/21.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "CacheTableViewCell.h"

@implementation CacheTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 5, self.frame.size.width, 80);
    if(self != nil){
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.height-8, self.frame.size.height-8)];
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_image.frame.origin.x+_image.frame.size.width+4, 4,_image.frame.size.width*3, self.frame.size.height/2-4)];
       
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_NameLabel.frame.origin.x,self.frame.size.height/2+ 4,_image.frame.size.width*3, self.frame.size.height/2-4)];
        _deleteImage =[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 10, 30, 30)];
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_NameLabel];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_deleteImage];
    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
