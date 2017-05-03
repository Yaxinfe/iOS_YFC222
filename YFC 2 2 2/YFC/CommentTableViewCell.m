//
//  CommentTableViewCell.m
//  YFC
//
//  Created by topone on 10/12/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "ReplyTableViewCell.h"

#define PADDING 8

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.image =[UIImageView new];
        self.image.frame=CGRectMake(10, 5, 70, 70);
        self.image.clipsToBounds = YES;
        self.image.userInteractionEnabled=YES;
        self.image.backgroundColor = [UIColor blackColor];
        self.image.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.image];
    
        self.lbl_NickName = [[UILabel alloc]init];
        [self.lbl_NickName setFrame:CGRectMake(90, 5, self.frame.size.width - 95, 20)];
        [self.lbl_NickName setTextAlignment:NSTextAlignmentLeft];
        [self.lbl_NickName setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
        [self.lbl_NickName setBackgroundColor:[UIColor clearColor]];
        [self.lbl_NickName setFont:[UIFont boldSystemFontOfSize:16.0]];
        self.lbl_NickName.numberOfLines = 1;
        [self addSubview:self.lbl_NickName];
    
        self.lbl_Content = [[UILabel alloc]init];
        [self.lbl_Content setFrame:CGRectMake(90, 30, self.frame.size.width - 95, 45)];
        [self.lbl_Content setTextAlignment:NSTextAlignmentLeft];
        [self.lbl_Content setTextColor:[UIColor blackColor]];
        [self.lbl_Content setBackgroundColor:[UIColor clearColor]];
        [self.lbl_Content setFont:[UIFont systemFontOfSize:14.0]];
        self.lbl_Content.numberOfLines = 3;
        [self addSubview:self.lbl_Content];
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, self.lbl_Content.frame.origin.y + self.lbl_Content.frame.size.height + 4, self.frame.size.width - 95, 0.5)];
        self.lineImgView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
        [self addSubview:self.lineImgView];
        
        self.replyTable = [[UITableView alloc] initWithFrame:CGRectMake(90, 80, self.bounds.size.width - 100, self.replyArray.count*60) style:UITableViewStylePlain];
        [self.replyTable registerClass:[ReplyTableViewCell class] forCellReuseIdentifier:@"ReplyCell"];
        self.replyTable.delegate = self;
        self.replyTable.dataSource = self;
        self.replyTable.backgroundColor = [UIColor clearColor];
        self.replyTable.scrollEnabled = NO;
        [self.replyTable setSeparatorInset:UIEdgeInsetsZero];
        self.replyTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.replyTable];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)refreshTableView:(NSMutableArray *)array commentid:(NSString *)comment{
    self.commentID = comment;
    self.replyArray = array;
    
    NSString *strComment = self.lbl_Content.text;
    CGSize constrainedSize = CGSizeMake(self.frame.size.width - 95, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
    CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    [self.lbl_Content setFrame:CGRectMake(90, 30, self.frame.size.width - 95, requiredCommentHeight.size.height)];
    
    int height = 0;
    
    for (int i = 0; i < self.replyArray.count; i++) {
        NSString *content_str = nil;
        NSString *replyName = nil;
        NSString *replyNickname = nil;
        NSString *reply_str = nil;
        
        reply_str = [[self.replyArray objectAtIndex:i] objectForKey:@"content"];
        if ([[self.replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
            replyNickname = [[self.replyArray objectAtIndex:i] objectForKey:@"nickname"];
            content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
        }
        else{
            replyNickname = [[self.replyArray objectAtIndex:i] objectForKey:@"rnickname"];
            replyName = [[self.replyArray objectAtIndex:i] objectForKey:@"nickname"];
            content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
        }
        
        CGSize constrainedSize = CGSizeMake(self.bounds.size.width - 110, 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                              nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        height = height + requiredHeight.size.height + PADDING;
    }
    
    self.lineImgView.frame = CGRectMake(90, self.lbl_Content.frame.origin.y + self.lbl_Content.frame.size.height + 4, self.frame.size.width - 95, 0.5);
    self.replyTable.frame = CGRectMake(90, self.lbl_Content.frame.origin.y + self.lbl_Content.frame.size.height + 5, self.bounds.size.width - 100, height + PADDING);
    
    [self.replyTable reloadData];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.replyArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReplyCell";
    
    ReplyTableViewCell *cell = (ReplyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableAttributedString *attributedString = nil;
    
    NSString *content_str = nil;
    NSString *replyName = nil;
    NSString *replyNickname = nil;
    NSString *reply_str = nil;
    
    int nContent = 0;
    int nReplyName = 0;
    int nReplyNickName = 0;
    int nReply_Str = 0;
    
    reply_str = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    nReply_Str = (int)[reply_str length];
    
    if ([[[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"rnickname"] isEqualToString:@""]) {
        replyNickname = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
        
        nReplyNickName = (int)[replyNickname length];
        nContent = (int)[content_str length];
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:content_str];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0] range:NSMakeRange(0, nReplyNickName)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(nReplyNickName, nContent - nReplyNickName)];
        
    }
    else{
        replyNickname = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"rnickname"];
        replyName = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyName, replyNickname, reply_str];
        
        nReplyNickName = (int)[replyNickname length];
        nReplyName = (int)[replyName length];
        nContent = (int)[content_str length];
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:content_str];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0] range:NSMakeRange(0, nReplyName)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(nReplyName, 2)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0] range:NSMakeRange(nReplyName + 2, nReplyNickName)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(nReplyNickName + 2 + nReplyName, nContent - nReplyNickName - 2 - nReplyName)];
        
    }
    
    cell.lbl_ReplyContent.attributedText = attributedString;
    CGRect defaultFrame = cell.lbl_ReplyContent.frame;
    
    CGSize constrainedSize = CGSizeMake(self.bounds.size.width - 110, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect newFrame = defaultFrame;
    newFrame.size.height = requiredHeight.size.height + PADDING;
    cell.lbl_ReplyContent.frame = newFrame;
    cell.lbl_ReplyContent.numberOfLines = 10;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    NSString *content_str = nil;
    NSString *replyName = nil;
    NSString *replyNickname = nil;
    NSString *reply_str = nil;
    
    reply_str = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    if ([[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"rnickname"] == [NSNull null]) {
        replyNickname = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
    }
    else{
        replyNickname = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"rnickname"];
        replyName = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
    }
    
    CGSize constrainedSize = CGSizeMake(self.bounds.size.width - 110, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return requiredHeight.size.height + PADDING;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *replyid = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"replyid"];
    NSString *ruserid = [[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"userid"];
    NSString *lastReplyId = [[self.replyArray firstObject] objectForKey:@"replyid"];
    
    [userdefault setObject:replyid forKey:@"rReplyID"];
    [userdefault setObject:ruserid forKey:@"rUserID"];
    [userdefault setObject:lastReplyId forKey:@"lastReplyId"];
    [userdefault setObject:self.commentID forKey:@"replyCommentId"];
    [userdefault setObject:[[self.replyArray objectAtIndex:indexPath.row] objectForKey:@"nickname"] forKey:@"replyNickname"];
    
    [userdefault synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"replyDelegate" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
