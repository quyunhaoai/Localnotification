//
//  ViewController.m
//  Localnotification
//
//  Created by 王栋栋 on 15-5-14.
//  Copyright (c) 2015年 王栋栋. All rights reserved.
//
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#import "ViewController.h"

@interface ViewController ()
{
    UILocalNotification *notification;
    NSDate *pushDate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    CGRect frame = [[UIScreen mainScreen]bounds].size.width;
    CGFloat width = [[UIScreen mainScreen]bounds].size.width;
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(width/2-120, 200, 100, 40);
    [button setFont:[UIFont systemFontOfSize:14]];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"创建本地通知" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(notification) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc]init];
    button2.frame = CGRectMake(width/2+20, 200, 100, 40);
    [button2 setFont:[UIFont systemFontOfSize:14]];
    [button2 setBackgroundColor:[UIColor blueColor]];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitle:@"取消本地通知" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(cancelNotification) forControlEvents:UIControlEventTouchUpInside];
    [button2 setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:button2];
//    [self notification];
}
-(void)notification
{
    notification = [[UILocalNotification alloc]init];
    pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    if (notification != nil) {
        NSDate *now = [NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:10];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = kCFCalendarUnitDay;
        notification.soundName =UILocalNotificationDefaultSoundName;
        notification.alertBody = @"测试，你喜欢吗？";
        notification.alertAction = @"打开";
        notification.applicationIconBadgeNumber = 1;
        
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        notification.userInfo = info;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
    
}
-(void)cancelNotification
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:@"name"]) {
                    if (notification){
//                        [localNotification release];
                        notification = nil;
                    }
//                    localNotification = [noti retain];
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!notification) {
            //不存在初始化
            localNotification = [[UILocalNotification alloc] init];
        }
        
        if (notification) {
            //不推送 取消推送
            [app cancelLocalNotification:notification];
//            [localNotification release];
            notification = nil;
            return;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
