//
//  SalesService.m
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "SalesService.h"
#import "Sales.h"

@implementation SalesService
-(void)getSalesList:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"Userlist" params:nil class:[Sales class]
                          completion:^(id obj, NSError *err) {
                              completeBlock(obj, err);
                          }];

}
@end
