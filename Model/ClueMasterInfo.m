//
//  ClueMasterInfo.m
//  kia-app
//
//  Created by jieyeh on 14/11/1.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "ClueMasterInfo.h"

@implementation ClueMasterInfo
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end
@implementation ClueAssignInfo
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end
@implementation CluesAduit
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end
@implementation CluesAduitList

@end

@implementation ClueHistory

@end
@implementation ClueDetailInfo
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity"
                                                       }];
}
@end

@implementation NewClueInfo

@end