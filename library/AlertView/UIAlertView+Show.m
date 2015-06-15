//
//  UIAlertView+Show.m
//  kia-app
//
//  Created by jieyeh on 14/10/30.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIAlertView+Show.h"

@implementation UIAlertView (Show)
+ (void)alert:(NSString*) message{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@""
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil , nil];
    [av show];
}
+ (void)alert:(NSString*) title andMessage:(NSString*) message{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil , nil];
    [av show];
}
@end
