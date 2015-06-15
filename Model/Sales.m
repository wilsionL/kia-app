//
//  Sales.m
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "Sales.h"

@implementation Sales
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}

@end
