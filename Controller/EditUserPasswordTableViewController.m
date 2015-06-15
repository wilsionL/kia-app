//
//  EditUserPasswordTableViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "EditUserPasswordTableViewController.h"
#import "UIAlertView+Show.h"
#import "UIColor+HexColor.h"
#import "UserService.h"

@interface EditUserPasswordTableViewController ()
@property (nonatomic, weak) IBOutlet UITextField* txtOldPassword;
@property (nonatomic, weak) IBOutlet UITextField* txtNewPassword;
@property (nonatomic, weak) IBOutlet UITextField* txtConfirmPassword;
@end

@implementation EditUserPasswordTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:@"修改密码"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnEditPasswordEvent:(id)sender{
    if(self.txtOldPassword.text.length == 0){
        [UIAlertView alert:@"输入的旧密码不能为空"];
        return;
    }
    if(self.txtNewPassword.text.length == 0){
        [UIAlertView alert:@"输入的新密码不能为空"];
        return;
    }
    if(![self.txtNewPassword.text isEqualToString:self.txtConfirmPassword.text]){
        [UIAlertView alert:@"您输入的新密码与确认密码不一致"];
        return;
    }
    UserService* service = [[UserService alloc] init];
    [service ChangePassword:self.txtOldPassword.text
             andNewPassword:self.txtNewPassword.text
                 completion:^(id obj, NSError *err)
    {
        if(err == nil){
            [UIAlertView alert:@"密码修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}


@end
