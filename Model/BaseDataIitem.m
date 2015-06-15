//
//  BaseDataIitem.m
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "BaseDataIitem.h"

@implementation BaseDataItem
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end

@implementation KeyValue
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end


@implementation ChannelInfo

@end

