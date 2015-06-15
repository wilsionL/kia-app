//
//  AppDelegate.m
//  kia-app
//
//  Created by jieyeh on 14/10/28.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

static Boolean needRefresh;
@interface AppDelegate ()
@property (nonatomic, assign) BOOL isExistenceNetworkApi;
@end

@implementation AppDelegate
@synthesize isExistenceNetworkApi;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    isExistenceNetworkApi = NO;
    needRefresh = NO;
    self.deviceToken = @"";
    
    // 注册网路状态变化监听函数
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound];

    [reach startNotifier];
    
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
//        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        if (badge>0) {
//            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
//            badge--;
//            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//        }
    }
    if(launchOptions){
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        ////判断程序是不是由推送服务完成的
        if (pushNotificationKey) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recvnotification" object:launchOptions];
        }
    }
    //消息推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication]
         registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];

    }
    
    
    
//    判断推送是否打开
//    UIRemoteNotificationType types;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
//    }
//    else
//    {
//        types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    }
//    
//    
//    return (types & UIRemoteNotificationTypeAlert);
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = token;
    NSLog(@"%@",token);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recvnotification" object:userInfo];
}
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    
//}
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 * 判断网络状态
 */
- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    BOOL connectionRequired = [reach connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable: {
            self.isExistenceNetworkApi = NO;
            NSLog( @"网络不可用" );
            break;
        }
        case ReachableViaWWAN: {
            self.isExistenceNetworkApi = YES;
            NSLog(@"当前通过2g/3g连接");
            break;
        }
        case ReachableViaWiFi: {
            self.isExistenceNetworkApi = YES;
            NSLog(@"当前通过wifi连接");
            break;
        }
    }
    if (connectionRequired)
    {
        NSLog(@"Connection Required");
    }
    
}
-(BOOL)isNetworkRreachable{
    return isExistenceNetworkApi;
}
+(BOOL) isNeedRefresh{
    return needRefresh;
}
+(void) resetRefreshState{
    needRefresh = NO;
}
+(void) setRefresh{
    needRefresh = YES;
}
@end
