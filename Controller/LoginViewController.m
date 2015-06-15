//
//  LoginViewController.m
//  kia-app
//
//  Created by jieyeh on 14/10/28.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "kia-app.pch"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "UserService.h"
#import "UserModel.h"
#import "UICheckbox.h"
#import "JNKeychain.h"
#import "UIAlertView+Show.h"
@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField* txtUserField;
@property (nonatomic, weak) IBOutlet UITextField* txtPasswordField;
@property (nonatomic, weak) IBOutlet UICheckbox* cbRemberPassword;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserModel* model = (UserModel*)[JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    if(model != nil && model.password != nil && model.UserName != nil){
    
//        [self.cbRemberPassword setCheckState:M13CheckboxStateChecked];
//        self.cbRemberPassword 
        self.txtPasswordField.text = model.password;
        self.txtUserField.text = model.UserName;
        self.cbRemberPassword.checked = YES;
    }
    
    [self.cbRemberPassword setCheckedImage:@"checkbox2" andUncheckedImage:@"checkbox"];
    self.cbRemberPassword.text = @"记住密码";
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickBackgroundEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.cbRemberPassword.checkAlignment = M13CheckboxAlignmentLeft;
//    [self.cbRemberPassword setCheckColor:[UIColor redColor]];
//    self.cbRemberPassword.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.cbRemberPassword.titleLabel.text = @"记住密码";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnLoginEvent:(id)sender{
        //
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserService* service = [[UserService alloc] init];
    NSString *userName = self.txtUserField.text;
    NSString* userPassword = self.txtPasswordField.text;
    NSString* message =[NSString stringWithFormat:@"%@,%@,%@", userName,
                        userPassword, appDelegate.deviceToken];
    NSLog(@"%@", message);
    //[UIAlertView alert:message];
    //return;
//    M13CheckboxState state = self.cbRemberPassword.checkState;
    [service login:userName
       andPassword:userPassword
    andDeviceToken:appDelegate.deviceToken
        completion:^(UserModel* user, NSError *err) {
            if(err != nil){
                [UIAlertView alert:err.localizedDescription];
                //[UIAlertView alert:message];
                return;
            }
            if(self.cbRemberPassword.checked)
//            if( state == M13CheckboxStateChecked){
            {
                user.UserName = userName;
                user.password = userPassword;
                user.cookies = nil;
                [JNKeychain saveValue:user forKey:LOGIN_INFO_KEY];
                
            }
            else
            {
                user.UserName = userName;
                user.cookies = nil;
                user.password = nil;
                [JNKeychain saveValue:user forKey:LOGIN_INFO_KEY];
            }
            
            [self performSegueWithIdentifier:@"navmainIdentifier" sender:sender];
        }];
}
-(void)btnClickBackgroundEvent:(id)sender{
    [self.txtPasswordField resignFirstResponder];
    
    [self.txtUserField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
