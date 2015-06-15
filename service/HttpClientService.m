//
//  HttpClientService.m
//  kia-app
//
//  Created by jieyeh on 14/10/29.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//
#import "kia-app.pch"
#import "HttpClientService.h"
#import "JsonResponse.h"
#import "AFHTTPRequestOperationManager.h"
#import "JNKeychain.h"
#import "JSONModelArray.h"


@implementation HttpClientService
-(void) post:(NSString*)op params:(NSDictionary*)params completion:(HttpClientServiceObjectBlock)completeBlock{
    NSString* url = [NSString stringWithFormat:@"%@/%@", WEBSERVICE_URL, op];
    NSLog(@"===========action:%@===========", op);
    NSLog(@"   params:%@", params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        JsonResponse* res = [[JsonResponse alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"   result:%@", responseObject);
//        NSLog(@"JSON: %@", responseObject);
        
        if(error != nil){
            completeBlock(nil, error);
            NSLog(@"%@", error);
            NSLog(@"============end action %@=============", op);
            return;
        }
        if(res == nil || res.resultstatus == nil) {
            error = [NSError errorWithDomain:@"httpClientservice.post"
                                        code:-1 userInfo:@{NSLocalizedDescriptionKey:@"错误的返回值"}];
            
        }
        if(res.resultstatus.code != 0) {
            error = [NSError errorWithDomain:@"httpClientservice.post"
                                        code:res.resultstatus.code
                                    userInfo:@{NSLocalizedDescriptionKey:res.resultstatus.message}];
        }
        if(error != nil) {
            NSLog(@"%@", error);
            completeBlock(nil, error);
            NSLog(@"============end action %@=============", op);
            return;
        }
        completeBlock(res.resultvalue, nil);
        NSLog(@"============end action %@=============", op);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completeBlock(nil, error);
        NSLog(@"============end action %@=============", op);
    }];
}
-(void) post:(NSString*)op
      params:(NSDictionary*)params
       class:(Class) class
  completion:(HttpClientServiceObjectBlock)completeBlock{
    [self post:op params:params completion:^(id json, NSError *err) {
        if(json == nil) {
            
            NSLog(@"%@", err);
            completeBlock(json, err);
            return ;
        }
        @try {
            id model = [[class alloc] initWithDictionary:json error:&err];
            if(model == nil){
                
                NSLog(@"%@", err);
                completeBlock(model, err);
            }else{
                completeBlock(model, nil);
            }
        }
        @catch (NSException *exception) {
            
            NSLog(@"%@", exception);
            completeBlock(nil,
                          [NSError errorWithDomain:@"httpClientservice.post"
                                              code:-1
                                               userInfo:exception.userInfo]);
        }
        @finally {
            
        }
    }];
}
-(void) postAndGetArray:(NSString*)op
                 params:(NSDictionary*)params
                  class:(Class) class
             completion:(HttpClientServiceObjectBlock)completeBlock{
    [self post:op params:params completion:^(id json, NSError *err) {
        if(json == nil) {
            
            NSLog(@"%@", err);
            completeBlock(json, err);
            return ;
        }
        @try {
            NSDictionary* dict = (NSDictionary*)json;
            id model = nil;
            if(dict.count == 0){
                model = [[JSONModelArray alloc] init];
            }
            else{
                model = [[JSONModelArray alloc] initWithArray:json modelClass:class];
            }
            if(model == nil){
//
                NSLog(@"%@", err);
                completeBlock(model, err);
            }else{
                completeBlock(model, nil);
            }
        }
        @catch (NSException *exception) {
            
            NSLog(@"%@", exception);
            completeBlock(nil,
                          [NSError errorWithDomain:@"httpClientservice.post"
                                              code:-1
                                          userInfo:exception.userInfo]);
        }
        @finally {
            
        }
    }];
}
-(void) postWithCookie:(NSString*)op
                params:(NSDictionary*)params
            completion:(HttpClientServiceObjectBlock)completeBlock{
    NSData* data = (NSData*)[JNKeychain loadValueForKey:COOKIE_NAME];
    NSArray* cookies = nil;
    NSError* err = nil;
    if(data != nil){
        cookies =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    Boolean findCookies = NO;
    if(cookies != nil && cookies.count > 0){
        for (NSHTTPCookie *cookie in cookies) {
            if([cookie.name isEqualToString: COOKIE_NAME]){
                findCookies = YES;
            }
        }
    }
    if(!findCookies){
        err = [NSError errorWithDomain:@"HttpClientService.postWithCookie"
                                  code:-100
                              userInfo:@{NSLocalizedDescriptionKey:@"没有获取到正确的cookie."}];
        completeBlock(nil, err);
        NSLog(@"%@", err);
        return;
    }
    [self post:op params:params  completion:^(id obj, NSError *err) {
        completeBlock(obj, err);
    }];
}
-(void) postWithCookie:(NSString*)op
                params:(NSDictionary*)params
                 class:(Class) class
            completion:(HttpClientServiceObjectBlock)completeBlock{
    NSData* data = (NSData*)[JNKeychain loadValueForKey:COOKIE_NAME];
    NSArray* cookies = nil;
    NSError* err = nil;
    if(data != nil){
        cookies =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    Boolean findCookies = NO;
    if(cookies != nil && cookies.count > 0){
        for (NSHTTPCookie *cookie in cookies) {
            if([cookie.name isEqualToString: COOKIE_NAME]){
                findCookies = YES;
            }
        }
    }
    if(!findCookies){
        err = [NSError errorWithDomain:@"HttpClientService.postWithCookie"
                                  code:-100
                              userInfo:@{NSLocalizedDescriptionKey:@"没有获取到正确的cookie."}];
        completeBlock(nil, err);
        NSLog(@"%@", err);
        return;
    }
    [self post:op params:params class:class completion:^(id obj, NSError *err) {
        completeBlock(obj, err);
    }];
}
-(void) postWithCookieAndGetArray:(NSString*)op
                           params:(NSDictionary*)params
                            class:(Class) class
                       completion:(HttpClientServiceObjectBlock)completeBlock{
    NSData* data = (NSData*)[JNKeychain loadValueForKey:COOKIE_NAME];
    NSArray* cookies = nil;
    NSError* err = nil;
    if(data != nil){
        cookies =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    Boolean findCookies = NO;
    if(cookies != nil && cookies.count > 0){
        for (NSHTTPCookie *cookie in cookies) {
            if([cookie.name isEqualToString: COOKIE_NAME]){
                findCookies = YES;
            }
        }
    }
    if(!findCookies){
        err = [NSError errorWithDomain:@"HttpClientService.postWithCookie"
                                  code:-100
                              userInfo:@{NSLocalizedDescriptionKey:@"没有获取到正确的cookie."}];
        completeBlock(nil, err);
        NSLog(@"%@", err);
        return;
    }
    [self postAndGetArray:op params:params class:class completion:^(id obj, NSError *err) {
        completeBlock(obj, err);
    }];
}
@end
