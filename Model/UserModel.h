//
//  UserModel.h
//  kia-app
//
//  Created by jieyeh on 14/10/28.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel
@property (nonatomic, strong) NSString<Optional>* UserName;
@property (nonatomic, strong) NSString<Optional>* shopName;
@property (nonatomic, strong) NSString<Optional>* shopaddress;
@property (nonatomic, strong) NSString<Optional>* salesName;
@property (nonatomic, strong) NSString<Optional>* salesPhone;
@property (nonatomic, strong) NSString<Optional>* provinceName;
@property (nonatomic, strong) NSString<Optional>* provinceid;
@property (nonatomic, strong) NSString<Optional>* cityName;
@property (nonatomic, strong) NSString<Optional>* cityid;
@property (nonatomic, strong) NSString<Optional>* password;
//@property (nonatomic, strong) NSArray* cookies;
@property (nonatomic, strong) NSString<Optional>*  cookies;
@property (nonatomic, strong) NSString* role;
@end
