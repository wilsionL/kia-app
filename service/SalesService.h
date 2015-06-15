//
//  SalesService.h
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface SalesService : HttpClientService
-(void)getSalesList:(HttpClientServiceObjectBlock)completeBlock;
@end
