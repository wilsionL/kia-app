//
//  BaseDataService.m
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "BaseDataService.h"
#import "JSONModelArray.h"
#import "BaseDataIitem.h"

@implementation BaseDataService
-(void)getBaseDataList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetBaseData"
                              params:@{@"basedataType":type}
                               class:[BaseDataItem class]
                          completion:^(id obj, NSError *err)
    {
        if(err == nil && [type isEqualToString:@"2"]){
            NSMutableArray* ds = [[NSMutableArray alloc] init];
            NSArray* arr = (NSArray*)obj;
            for(NSInteger idx = 0; idx < arr.count; idx++){
                BaseDataItem* item = (BaseDataItem*)[arr objectAtIndex:idx];
                NSString* strLevel = [NSString stringWithFormat:@"%@", item.keycode];
                if(![strLevel isEqualToString:@"F"] &&
                   ![strLevel isEqualToString:@"FO"] &&
                   ![strLevel isEqualToString:@"O"]){
                    [ds addObject:item];
                }
            }
            obj = ds;

        }
        completeBlock(obj, err);
    }];
}
-(void)getAllBaseDataList:(NSString*)type andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetBaseData"
                              params:@{@"basedataType":type}
                               class:[BaseDataItem class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];
}
-(void)getBrandList:(NSString*)isCompete
   andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"BrandList"
                              params:@{@"isCompete": isCompete}
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];

}

-(void)getCarTypeList:(NSString*)isCompete
     andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"Carlist"
                              params:@{@"isCompete": isCompete, @"brandid":@""}
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];

}
-(void)getCarTypeList:(NSString*)isCompete
             andBrand:(NSString*) brand
     andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock
{
    [super postWithCookieAndGetArray:@"Carlist"
                              params:@{@"isCompete": isCompete,
                                       @"brandid":brand}
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];
}
-(void)getCarModelList:(NSString*)isCompete
                     andType:(NSString*)type
            andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock
{
    [super postWithCookieAndGetArray:@"Modellist"
                              params:@{
                                       @"isCompete":isCompete,
                                       @"id":type
                                       }
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];

}
-(void)getProviceList:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetProviceOrCityInfo"
                              params:@{
                                       @"type":@"1",
                                       @"id":@""
                                       }
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];
}

-(void)getCityList:(NSString*)proviceId
  andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetProviceOrCityInfo"
                              params:@{
                                       @"type":@"2",
                                       @"id":proviceId
                                       }
                               class:[KeyValue class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];
}

-(void) getChannelCategory:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetChannelInfo"
                              params:@{
                                       @"layerID":@"1",
                                       @"channelId":@""
                                       }
                               class:[ChannelInfo class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];

}

-(void) getChannelSubCategory:(NSString*) parentId
             andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetChannelInfo"
                              params:@{
                                       @"layerID":@"2",
                                       @"channelId":parentId
                                       }
                               class:[ChannelInfo class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];

}

-(void) getChannelThirdCategory:(NSString*) parentId
               andCompleteBlock:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookieAndGetArray:@"GetChannelInfo"
                              params:@{
                                       @"layerID":@"3",
                                       @"channelId":parentId
                                       }
                               class:[ChannelInfo class]
                          completion:^(id obj, NSError *err)
     {
         completeBlock(obj, err);
     }];}
@end
