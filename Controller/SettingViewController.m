//
//  SettingViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "SettingViewController.h"
#import "VersionService.h"
#import "VersionModel.h"
#import "UIColor+HexColor.h"
#import "UIAlertView+Show.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSource;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataSource = @[
                        @{
                            @"img":@"password_icon",
                            @"title":@"密码修改"
                            },
                        @{
                            @"img":@"info_icon",
                            @"title":@"版本信息"
                            },
                        @{
                            @"title":@"退出登录"
                            }
                        ];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell2"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:@"设置"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(indexPath.row < 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                        forIndexPath:indexPath];
        if(indexPath.row < 2){
            NSDictionary* dict = [self.dataSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"img"]];
            cell.textLabel.text = [dict objectForKey:@"title"];
        }
        if(indexPath.row < 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                               forIndexPath:indexPath];
        UIButton* btn = (UIButton*)[cell viewWithTag:1006];
        if(btn == nil){
            btn = [[UIButton alloc] initWithFrame:
                   CGRectMake(20, 5,DEVICERECT.size.width - 40, 30)];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"]
                           forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(btnExit:)
          forControlEvents:UIControlEventTouchUpInside];
        }
//        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"segNavEditPassword" sender:nil];
    }
    else{
        VersionService *service = [[VersionService alloc]init];
        [service getVersion:^(id obj, NSError *err) {
            if(err != nil) [UIAlertView alert:err.localizedDescription];
            VersionModel* version = (VersionModel*) obj;
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
            if (version && [version.version compare:appVersion] == NSOrderedDescending) {
                [self updateVersion:version.desc];
            }
        }];
    }
}
- (void)updateVersion:(NSString*) msg {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = 888;
    [alert show];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 888 && buttonIndex == 0)
    {
        NSURL* url = [NSURL URLWithString: URL_UPDATE_VERSION];
        [[UIApplication sharedApplication] openURL: url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnExit:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
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
