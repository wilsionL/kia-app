//
//  VersionModel.m
//  kia-app
//
//  Created by jieyeh on 14/11/15.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"desc"
                                                       }];
}
@end
