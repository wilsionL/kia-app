//
//  CustomerService.m
//  kia-app
//
//  Created by jieyeh on 14/10/31.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "CustomerService.h"
#import "SummaryModel.h"
@implementation CustomerService
-(void)Summary:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"Summary" params:nil class:[SummaryModel class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
@end
