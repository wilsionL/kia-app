//
//  UserService.m
//  kia-app
//
//  Created by jieyeh on 14/10/30.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UserService.h"
#import "UserModel.h"
#import "JNKeychain.h"
@implementation UserService
-(void)login:(NSString*)loginName
 andPassword:(NSString*) password
andDeviceToken:(NSString*)token
  completion:(HttpClientServiceObjectBlock)completeBlock{
    if(loginName.length == 0 || password.length == 0){
        completeBlock(nil,
        [NSError errorWithDomain:@"UserService.Login"
                            code:-1
                        userInfo:@{NSLocalizedDescriptionKey:@"用户名或密码不能为空"}]);
        return;
    }
    [super post:@"Login"
         params:@{@"username":loginName, @"password":password, @"pushNo":token}
          class:[UserModel class]
     completion:^(UserModel* user, NSError *err) {
         if(user != nil){
             user.cookies = nil;
             // 设置cookie;
             NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
             if(cookieJar != nil && cookieJar.cookies != nil){
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookieJar.cookies];
                 [JNKeychain saveValue:data forKey:COOKIE_NAME];
             }
             
             for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                 NSLog(@"%@", cookie);
                 if([cookie.name isEqualToString: COOKIE_NAME]){
                     user.cookies = cookie.value;
                 }
             }
            
         }
         completeBlock(user, err);
     }];
   
}
-(void)ChangePassword:(NSString*)oldPwd andNewPassword:(NSString*)newPwd completion:(HttpClientServiceObjectBlock)completeBlock{
    [super postWithCookie:@"Changepwd"
                   params:@{@"oldpassword":oldPwd, @"newpassword":newPwd}
               completion:^(id obj, NSError *err) {
                   completeBlock(obj, err);
               }];
}
@end
