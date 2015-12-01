//
//  NotificationCell.m
//  jiguang
//
//  Created by Xiao_huanG on 15/11/30.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import "NotificationCell.h"
#import "Masonry.h"
#import "ColorHeader.h"
#import "FrameHeader.h"
#import "NotifyObj.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface NotificationCell ()

@end

@implementation NotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    [self setupView];
  }
  
  return self;
}

- (void)setupView {
  
  WS(ws);
  
  [self.contentView addSubview:self.msgLabel];
  [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ws.contentView).mas_offset(@(8));
    make.centerY.mas_equalTo(ws.contentView);
    make.width.mas_equalTo(@(120));
  }];
  
  [self.contentView addSubview:self.isReadLabel];
  [self.isReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(ws.contentView);
    make.right.mas_equalTo(ws.contentView).mas_offset(-7);
  }];
  
  NotifyObj *obj = [[NotifyObj alloc]init];
  
  if (obj.isReaded) {
    self.isReadLabel.text = @"已读";
  }
  else {
    self.isReadLabel.text = @"未读";
  }
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark Accessor
- (UILabel *)msgLabel {
  
  if (!_msgLabel) {
    _msgLabel = [UILabel new];
    _msgLabel.textColor = [UIColor lightGrayColor];
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _msgLabel;
}

- (UILabel *)isReadLabel {
  
  if (!_isReadLabel) {
    _isReadLabel = [UILabel new];
    _isReadLabel.textAlignment = NSTextAlignmentRight;
    _isReadLabel.font = [UIFont systemFontOfSize:16.0];
    _isReadLabel.textColor = COLOR_VALUE(69, 158, 197, 1);
  }
  
  return _isReadLabel;
}


@end
