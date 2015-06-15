//
//  HttpClientService.h
//  kia-app
//
//  Created by jieyeh on 14/10/29.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//
#import <Foundation/Foundation.h>


typedef void (^HttpClientServiceObjectBlock)(id obj, NSError* err);

@interface HttpClientService : NSObject
-(void) post:(NSString*)op
      params:(NSDictionary*)params
  completion:(HttpClientServiceObjectBlock)completeBlock;
-(void) post:(NSString*)op
      params:(NSDictionary*)params
       class:(Class) class
  completion:(HttpClientServiceObjectBlock)completeBlock;
-(void) postAndGetArray:(NSString*)op
                 params:(NSDictionary*)params
                  class:(Class) class
            completion:(HttpClientServiceObjectBlock)completeBlock;
-(void) postWithCookie:(NSString*)op
                params:(NSDictionary*)params
    completion:(HttpClientServiceObjectBlock)completeBlock;

-(void) postWithCookie:(NSString*)op
                params:(NSDictionary*)params
                 class:(Class) class
    completion:(HttpClientServiceObjectBlock)completeBlock;
-(void) postWithCookieAndGetArray:(NSString*)op
                           params:(NSDictionary*)params
                            class:(Class) class
completion:(HttpClientServiceObjectBlock)completeBlock;

@end
