//
//  JsonResponse.h
//  kia-app
//
//  Created by jieyeh on 14/10/28.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface ResultStatus :JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString* message;

@end
@interface JsonResponse : JSONModel
@property (nonatomic, strong) ResultStatus* resultstatus;
@property (nonatomic, strong) NSDictionary<Optional>* resultvalue;
@end
