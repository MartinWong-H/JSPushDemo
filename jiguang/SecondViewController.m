//
//  SecondViewController.m
//  jiguang
//
//  Created by Xiao_huanG on 15/11/18.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import "SecondViewController.h"
#import "FrameHeader.h"
#import "ColorHeader.h"
#import "Masonry.h"
#import "NotificationCell.h"
#import "NotifyObj.h"

static NSString *notificationCell = @"notification cell Identificaiton";

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource> {
  
  BOOL isReaded;
}

@property (nonatomic,strong) UITableView *msgTableView;

/**
 *  推送信息
 */
@property (nonatomic,strong) NSMutableArray *notificateMsgs;

/**
 *  阅读状态
 */
@property (nonatomic,strong) UILabel *readLabel;

/**
 * 角标数组
 */
@property (nonatomic,strong) NSMutableArray *badges;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  //self.title = @"推送消息";
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupViews];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateApnsInfo) name:@"updateApnsInfo" object:nil];
  
}

- (void)setupViews {
  
  WS(ws);
  
  [self.view addSubview:self.msgTableView];
  [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(ws.view).mas_offset(@(64));
    make.left.bottom.and.right.mas_equalTo(ws.view);
  }];
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  if ([self.msgTableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [self.msgTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
  }
  
  if ([self.msgTableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.msgTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
  }
  
}

#pragma mark - Delegate
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return self.notificateMsgs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationCell];
  
  if (!cell) {
    cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notificationCell];
  }
  
  NotifyObj *obj = (NotifyObj *)[self.notificateMsgs objectAtIndex:indexPath.row];
  
  cell.msgLabel.text = obj.msgStr;
  
  if (obj.isReaded) {
    cell.isReadLabel.text = @"已读";
  }
  else {
    cell.isReadLabel.text = @"未读";
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return @"删除";
}

/**
 *  点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NotifyObj *obj = (NotifyObj *)[self.notificateMsgs objectAtIndex:indexPath.section];
  obj.isReaded = YES;
  [self.msgTableView reloadData];
  
  NSMutableArray *objs = [[NSMutableArray alloc] init];
  
  for (NotifyObj *obj in self.notificateMsgs) {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [objs addObject:data];
    
  }
  [[NSUserDefaults standardUserDefaults] setObject:objs forKey:@"Notification_Info"];
  [[NSUserDefaults standardUserDefaults]synchronize];
  
  
  NSMutableArray *arrs = [[NSMutableArray alloc] init];
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
    
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    [self.badges removeAllObjects];
    [arrs addObjectsFromArray:notifications];
  }
  
  for (NSData *data in arrs) {
    
    NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj.isReaded == NO) {
      [self.badges addObject:obj];
    }
  }
  if (self.badges.count != 0) {
    
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    item.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)self.badges.count];
  }
  else {
    
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    [item setBadgeValue:nil];
  }
  
}

// 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle != UITableViewCellEditingStyleDelete) {
    
    return;
  }
  
  [self.notificateMsgs removeObjectAtIndex:indexPath.section];
  [self.msgTableView reloadData];
  NSMutableArray *objs = [[NSMutableArray alloc] init];
  
  for (NotifyObj *obj in self.notificateMsgs) {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [objs addObject:data];
  }
  [[NSUserDefaults standardUserDefaults] setObject:objs forKey:@"Notification_Info"];
  [[NSUserDefaults standardUserDefaults]synchronize];
  
  NSMutableArray *arrs = [[NSMutableArray alloc] init];
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    [self.badges removeAllObjects];
    [arrs addObjectsFromArray:notifications];
  }
  
  for (NSData *data in arrs) {
    
    NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj.isReaded == NO) {
      [self.badges addObject:obj];
    }
  }
  if (self.badges.count != 0) {
    
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    item.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)self.badges.count];
  }
  else {
    
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    [item setBadgeValue:nil];
  }
}

#pragma mark Private Method
- (void)updateApnsInfo {
  
  NSMutableArray *arrs = [[NSMutableArray alloc] init];
  [arrs removeAllObjects];
  [self.notificateMsgs removeAllObjects];
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    //[self.notificateMsgs addObjectsFromArray:notifications];
    [arrs addObjectsFromArray:notifications];
  }
  
  NSLog(@"总共：%lu",arrs.count);
  for (NSData *data in arrs) {
    NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"对象数据:%@",obj.msgStr);
    [self.notificateMsgs addObject:obj];
  }
  
  [self.msgTableView reloadData];
  
}

#pragma mark - Accessor
- (UITableView *)msgTableView {
  
  if (!_msgTableView) {
    _msgTableView = [[UITableView alloc] init];
    _msgTableView.backgroundColor = [UIColor whiteColor];
    _msgTableView.delegate = self;
    _msgTableView.dataSource = self;
    _msgTableView.showsVerticalScrollIndicator = NO;
    _msgTableView.scrollEnabled = YES;
  }
  
  return _msgTableView;
}

- (NSMutableArray *)notificateMsgs {
  
  if (!_notificateMsgs) {
    
    _notificateMsgs = [[NSMutableArray alloc] init];
    
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    [_notificateMsgs removeAllObjects];
    for (NSData *data in notifications) {
      NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      [_notificateMsgs addObject:obj];
      NSLog(@"对象数据:%@",obj.msgStr);
    }
  }
  
  return _notificateMsgs;
}

- (UILabel *)readLabel {
  
  if (!_readLabel) {
    _readLabel = [[UILabel alloc] init];
    _readLabel.textAlignment = NSTextAlignmentRight;
    _readLabel.font = [UIFont systemFontOfSize:16.0];
    _readLabel.textColor = COLOR_VALUE(69, 158, 197, 1);
  }
  
  return _readLabel;
}

- (NSMutableArray *)badges {
  
  if (!_badges) {
    
    _badges = [[NSMutableArray alloc] init];
  }
  return _badges;
}


@end
