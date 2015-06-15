//
//  VersionModel.h
//  kia-app
//
//  Created by jieyeh on 14/11/15.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface VersionModel : JSONModel
@property (nonatomic, strong) NSString<Optional>* version;
@property (nonatomic, strong) NSString<Optional>* desc;
@end
