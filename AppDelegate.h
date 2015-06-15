//
//  AppDelegate.h
//  kia-app
//
//  Created by jieyeh on 14/10/28.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *deviceToken;
+(BOOL) isNeedRefresh;
+(void) setRefresh;
+(void) resetRefreshState;
-(BOOL) isNetworkRreachable;
@end

