//
//  ClueService.m
//  kia-app
//
//  Created by jieyeh on 14/11/1.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "ClueService.h"
#import "ClueMasterInfo.h"
@interface ClueService()
@end
@implementation ClueService
-(void)listClue:(NSString*)action andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:action params:nil class:[ClueMasterInfo class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];

}
-(void) listComelist:(HttpClientServiceObjectBlock)completeBlock{
    [self listClue:@"comlist" andCompleteBlock:completeBlock];
}
-(void) listBacklist:(HttpClientServiceObjectBlock)completeBlock{
    [self listClue:@"backlist" andCompleteBlock:completeBlock];
}
-(void)listSaleCluesList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"CluesList"
                   params:@{@"searchtype": type}
                    class:[CluesAduitList class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];

}
-(void)listAllCluesList:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"GetAllClue"
                   params:nil
                    class:[CluesAduitList class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
-(void)getClueDetail:(NSString*)identity andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"Detail"
                   params:@{@"clueid": identity}
                    class:[ClueDetailInfo class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
    }];
}

// 战败待审核列表
-(void) listAduitClues:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"AduitClues"
                   params:nil
                    class:[CluesAduitList class]
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
    

}
-(void)Assign:(NSString*)ids
    andUserId:(NSString*)userId
andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"Assign"
                   params:@{@"ids": ids, @"userid": userId}
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
-(void)defeataudit:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"defeataudit"
                   params:parameters
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
-(void)saveClue:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"create"
                   params:parameters
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
-(void)followup:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"Followup"
                   params:parameters
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
@end
