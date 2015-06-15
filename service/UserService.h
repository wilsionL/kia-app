//
//  UserService.h
//  kia-app
//
//  Created by jieyeh on 14/10/30.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "HttpClientService.h"

@interface UserService : HttpClientService
-(void)login:(NSString*)loginName
 andPassword:(NSString*) password
andDeviceToken:(NSString*)token
  completion:(HttpClientServiceObjectBlock)completeBlock;
-(void)ChangePassword:(NSString*)oldPwd andNewPassword:(NSString*)newPwd completion:(HttpClientServiceObjectBlock)completeBlock;
@end
