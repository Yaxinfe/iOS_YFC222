//
//  ReplyTableViewCell.m
//  YFC
//
//  Created by topone on 10/12/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lbl_ReplyContent = [[UILabel alloc]init];
        [self.lbl_ReplyContent setFrame:CGRectMake(0, 0, self.frame.size.width - 20, 60)];
        [self.lbl_ReplyContent setTextAlignment:NSTextAlignmentLeft];
        [self.lbl_ReplyContent setTextColor:[UIColor blackColor]];
        [self.lbl_ReplyContent setBackgroundColor:[UIColor clearColor]];
        [self.lbl_ReplyContent setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:self.lbl_ReplyContent];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
