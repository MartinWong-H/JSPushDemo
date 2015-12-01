//
//  AppDelegate.m
//  jiguang
//
//  Created by Xiao_huanG on 15/11/17.
//  Copyright © 2015年 xiao_Warn. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "ColorHeader.h"
#import "APService.h"
#import "NotifyObj.h"

@interface AppDelegate ()

@property (nonatomic,strong) UINavigationController *firstNav;
@property (nonatomic,strong) UINavigationController *secondVav;
@property (nonatomic,strong) UINavigationController *thirdNav;
@property (nonatomic,strong) UINavigationController *fourNav;

@property (nonatomic,strong) UITabBarController *tabBarController;

/**
 *  推送消息
 */
@property (nonatomic,strong) NSMutableArray *notifications;

/**
 *  未读信息
 */
@property (nonatomic,strong) NSMutableArray *unreadMsgs;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  self.tabBarController = [[UITabBarController alloc] init];
  ViewController *first = [[ViewController alloc] init];
  SecondViewController *second = [[SecondViewController alloc] init];
  ThirdViewController *third = [[ThirdViewController alloc] init];
  FourViewController *four = [[FourViewController alloc] init];
  
  self.firstNav = [[UINavigationController alloc] initWithRootViewController:first];
  self.firstNav.title = @"首页";
  
  self.secondVav = [[UINavigationController alloc] initWithRootViewController:second];
  self.secondVav.title = @"消息";
  
  self.thirdNav = [[UINavigationController alloc] initWithRootViewController:third];
  self.thirdNav.title = @"圈子";
  
  self.fourNav = [[UINavigationController alloc] initWithRootViewController:four];
  self.fourNav.title = @"设置";
  
  self.tabBarController.viewControllers = @[self.firstNav,self.secondVav,self.thirdNav,self.fourNav];
  
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setBarTintColor:COLOR_VALUE(255, 0, 51, 1)];
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
  
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_VALUE(255, 52, 41, 1), NSForegroundColorAttributeName, [UIFont systemFontOfSize:14.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
  //[[UITabBar appearance] setBarTintColor:ColorValue(246, 246, 246, 1)];
  [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
  
  // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
  } else {
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
  }
#else
  //categories 必须为nil
  [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
                                     categories:nil];
#endif
  // Required
  [APService setupWithOption:launchOptions];
  
  // 自定义消息推送通知
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
  
  //NSMutableArray *arrs = [[NSMutableArray alloc] init];
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
    [self.notifications removeAllObjects];
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    //[arrs addObjectsFromArray:notifications];
    [self.notifications addObjectsFromArray:notifications];
  }
  
  
  [self.unreadMsgs removeAllObjects];
  for (NSData *data in self.notifications) {
    NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj.isReaded == NO) {
      [self.unreadMsgs addObject:obj];
    }
  }
  
  NSLog(@"obj未读个数 %lu",(unsigned long)self.unreadMsgs.count);
  
  if (self.unreadMsgs.count != 0) {
    
    self.secondVav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMsgs.count];
    [APService setBadge:self.unreadMsgs.count];
  }
  else {
    
  }
  
  self.window.rootViewController = self.tabBarController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
  //NSMutableArray *arrs = [[NSMutableArray alloc] init];
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
    [self.notifications removeAllObjects];
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
    [self.notifications addObjectsFromArray:notifications];
  }
  
  [self.unreadMsgs removeAllObjects];
  for (NSData *data in self.notifications) {
    
    NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj.isReaded == NO) {
      [self.unreadMsgs addObject:obj];
    }
  }
  
  [[NSNotificationCenter defaultCenter]postNotificationName:@"updateApnsInfo" object:nil];
  if (self.unreadMsgs.count != 0) {
    self.secondVav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMsgs.count];
  }
  else {
    
  }
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  // 清除图标数字
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [APService resetBadge];
  
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  // Required
  [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
//  // 取得 APNs 标准信息内容
//  NSDictionary *aps = [userInfo valueForKey:@"aps"];
//  NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//  NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//  NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//  
//  // 取得自定义字段内容
//  NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//  NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
  
  // Required
  [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  NSLog(@"this is iOS7 Remote Notification");
  
  // IOS 7 Support Required
  
  NSDictionary *aps = [userInfo valueForKey:@"aps"];
  //NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
  
  if (application.applicationState == UIApplicationStateActive) {
    
    NSLog(@"userInfo前台运行: %@",userInfo);
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
//      
//      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
//      [array addObjectsFromArray:notifications];
//      
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
      
      [self.notifications removeAllObjects];
      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
      [self.notifications addObjectsFromArray:notifications];
    }
    
    NotifyObj *obj = [[NotifyObj alloc] initWithNotificateInfo:aps];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [self.notifications insertObject:archivedData atIndex:0];
    [[NSUserDefaults standardUserDefaults]setValue:self.notifications forKey:@"Notification_Info"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
//      [self.notifications removeAllObjects];
//      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
//      [self.notifications addObjectsFromArray:notifications];
//    }
    
    [self.unreadMsgs removeAllObjects];
    for (NSData *data in self.notifications) {
      
      NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      if (obj.isReaded == NO) {
        [self.unreadMsgs addObject:obj];
      }
    }
    if (self.unreadMsgs.count != 0) {
      self.secondVav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMsgs.count];
    }
    else {
      
    }
    // 通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateApnsInfo" object:nil];
    
  }
  else if (application.applicationState == UIApplicationStateInactive) {
    
    NSLog(@"userInfo后台运行: %@",userInfo);
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
//      
//      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
//      [array addObjectsFromArray:notifications];
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
      
      [self.notifications removeAllObjects];
      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
      [self.notifications addObjectsFromArray:notifications];
    }
    
    NotifyObj *obj = [[NotifyObj alloc] initWithNotificateInfo:aps];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [self.notifications insertObject:archivedData atIndex:0];
    [[NSUserDefaults standardUserDefaults]setValue:self.notifications forKey:@"Notification_Info"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"角标个数%lu",(unsigned long)self.notifications.count);
    //[self.notifications addObjectsFromArray:array];
    NSLog(@"后台运行：%@",obj.msgStr);
    
    //NSMutableArray *arrs = [[NSMutableArray alloc] init];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"]) {
//      [self.notifications removeAllObjects];
//      NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Info"];
//      //[arrs addObjectsFromArray:notifications];
//      [self.notifications addObjectsFromArray:notifications];
//    }
    
    [self.unreadMsgs removeAllObjects];
    for (NSData *data in self.notifications) {
      
      NotifyObj *obj = (NotifyObj *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      if (obj.isReaded == NO) {
        [self.unreadMsgs addObject:obj];
      }
    }
    
    if (self.unreadMsgs.count != 0) {
      self.secondVav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.unreadMsgs.count];
    }
    else {
      
    }
    
    // 通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateApnsInfo" object:nil];
  }
  
  [APService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

// 自定义消息内容的获取方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
  
//  NSDictionary * userInfo = [notification userInfo];
//  NSString *content = [userInfo valueForKey:@"content"];
//  NSDictionary *extras = [userInfo valueForKey:@"extras"];
//  NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
  
}

#pragma mark - Accessor
- (NSMutableArray *)notifications {
  
  if (!_notifications) {
    _notifications = [[NSMutableArray alloc] init];
  }
  return _notifications;
}

- (NSMutableArray *)unreadMsgs {
  
  if (!_unreadMsgs) {
    _unreadMsgs = [[NSMutableArray alloc] init];
  }
  return _unreadMsgs;
}

@end
