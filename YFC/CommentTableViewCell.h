//
//  CommentTableViewCell.h
//  YFC
//
//  Created by topone on 10/12/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CommentCellDelegate <NSObject>
//@optional
//
//- (void)setArray:(NSMutableArray *)array;
//
//@end

@interface CommentTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel     *lbl_NickName;
@property (nonatomic, strong) UILabel     *lbl_Content;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UIImageView *lineImgView1;

@property (nonatomic, strong) UITableView *replyTable;

@property (nonatomic, strong) NSMutableArray *replyArray;
@property (nonatomic, strong) NSString       *commentID;

- (void)refreshTableView:(NSMutableArray*)array commentid:(NSString *)comment;

@end
