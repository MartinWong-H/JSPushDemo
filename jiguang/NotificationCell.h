//
//  NotificationCell.h
//  jiguang
//
//  Created by Xiao_huanG on 15/11/30.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (nonatomic,strong) UILabel *msgLabel;

/**
 *  阅读状态
 */
@property (nonatomic,strong) UILabel *isReadLabel;

@end
