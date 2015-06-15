//
//  ClueService.h
//  kia-app
//
//  Created by jieyeh on 14/11/1.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface ClueService : HttpClientService
-(void) listComelist:(HttpClientServiceObjectBlock)completeBlock;
-(void) listBacklist:(HttpClientServiceObjectBlock)completeBlock;
-(void)listClue:(NSString*)action andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
-(void)listSaleCluesList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
-(void)listAllCluesList:(HttpClientServiceObjectBlock)completeBlock;


-(void)getClueDetail:(NSString*)identity andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

// 战败待审核列表
-(void) listAduitClues:(HttpClientServiceObjectBlock)completeBlock;

-(void)Assign:(NSString*)ids
    andUserId:(NSString*)userId
andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)defeataudit:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
-(void)saveClue:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
-(void)followup:(NSDictionary*)parameters andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
@end
