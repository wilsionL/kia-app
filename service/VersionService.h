//
//  VersionService.h
//  kia-app
//
//  Created by jieyeh on 14/11/15.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface VersionService : HttpClientService
-(void)getVersion:(HttpClientServiceObjectBlock)completeBlock;
@end
