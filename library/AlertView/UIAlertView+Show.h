//
//  UIAlertView+Show.h
//  kia-app
//
//  Created by jieyeh on 14/10/30.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Show)
+(void)alert:(NSString*) message;
+(void)alert:(NSString*) title andMessage:(NSString*) message;
@end
