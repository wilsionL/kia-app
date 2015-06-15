//
//  VersionService.m
//  kia-app
//
//  Created by jieyeh on 14/11/15.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "VersionService.h"
#import "VersionModel.h"

@implementation VersionService
-(void)getVersion:(HttpClientServiceObjectBlock)completeBlock{
    [super post:@"GetVersion" params:@{@"version":@"2"}
          class:[VersionModel class]
     completion:^(id obj, NSError *err) {
        completeBlock(obj, err);
    }];

}
@end
