//
//  NotifyObj.m
//  jiguang
//
//  Created by Xiao_huanG on 15/11/30.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import "NotifyObj.h"

@implementation NotifyObj

- (instancetype)initWithNotificateInfo:(NSDictionary *)dic {
  
  self = [super init];
  
  if (self) {
    self.msgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"alert"]];
    self.isReaded = NO;
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  
  self = [super init];
  
  if (self) {
    self.msgStr = [NSString stringWithFormat:@"%@",[coder decodeObjectForKey:@"alert"]];
    self.isReaded = [coder decodeBoolForKey:@"isRead"];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  
  [coder encodeObject:self.msgStr forKey:@"alert"];
  [coder encodeBool:self.isReaded forKey:@"isRead"];
  
}

#pragma mark - Accessor
- (NSString *)msgStr {
  
  if (!_msgStr) {
    _msgStr = [[NSString alloc] init];
  }
  
  return _msgStr;
}

@end
