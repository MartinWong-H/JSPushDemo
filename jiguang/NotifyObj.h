//
//  NotifyObj.h
//  jiguang
//
//  Created by Xiao_huanG on 15/11/30.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyObj : NSObject

/**
 *  推送标题
 */
@property (nonatomic,strong) NSString *msgStr;

@property (nonatomic,assign) BOOL isReaded;

- (instancetype)initWithNotificateInfo:(NSDictionary *)dic;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
