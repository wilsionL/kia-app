//
//  BaseDataService.h
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface BaseDataService : HttpClientService
-(void)getBaseDataList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;
-(void)getAllBaseDataList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)getBrandList:(NSString*)isCompete
   andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)getCarTypeList:(NSString*)isCompete
     andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)getCarTypeList:(NSString*)isCompete
             andBrand:(NSString*) brand
     andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)getCarModelList:(NSString*)isCompete
               andType:(NSString*)type
      andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void)getProviceList:(HttpClientServiceObjectBlock)completeBlock;

-(void)getCityList:(NSString*)proviceId
      andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void) getChannelCategory:(HttpClientServiceObjectBlock)completeBlock;

-(void) getChannelSubCategory:(NSString*) parentId
             andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

-(void) getChannelThirdCategory:(NSString*) parentId
               andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock;

@end
