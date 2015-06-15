//
//  Sales.h
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface Sales : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString* name;
@end

@protocol Sales <NSObject>

@end