//
//  CustomerService.h
//  kia-app
//
//  Created by jieyeh on 14/10/31.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface CustomerService : HttpClientService
-(void)Summary:(HttpClientServiceObjectBlock)completeBlock;
@end
