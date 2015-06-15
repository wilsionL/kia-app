//
//  ClueDetailViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/2.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "ClueDetailViewController.h"
#import "ClueService.h"
#import "ClueMasterInfo.h"
#import "UserModel.h"
#import "JNKeychain.h"
#import "ClueDetailTableViewCell.h"
#import "EditClueViewController.h"
#import "UIAlertView+Show.h"
#import "UIColor+HexColor.h"
#import <MessageUI/MessageUI.h>

@interface ClueDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UILabel* lbName;
@property (nonatomic, weak) IBOutlet UILabel* lbLinkTel;
@property (nonatomic, weak) IBOutlet UILabel* lbCarType;
@property (nonatomic, weak) IBOutlet UILabel* lbLevel;
@property (nonatomic, weak) IBOutlet UILabel* lbSource;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray<ClueHistory>* dataSource;
@property (nonatomic, strong) ClueDetailInfo* clueItem;
@property (nonatomic, strong) IBOutlet UIView* footView;
@end

@implementation ClueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib* nib = [UINib nibWithNibName:@"ClueDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ClueDetailTableViewCell"];
    self.title = @"线索详情";
    self.lbName.text = @"";
    self.lbLinkTel.text = @"";
    self.lbCarType.text = @"";
    self.lbLevel.text = @"";
    self.lbSource.text = @"";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    if([user.role isEqual:@"manager"] || [self.type isEqualToString:@"cluecount"]){
        self.footView.hidden = YES;
    }
    else{
        [self buildFooterButton];
    }
    
    [self loadData:self.identity];
}
-(void)buildFooterButton{
    CGFloat btnWidth = DEVICERECT.size.width / 3;
    UIButton* btnCall = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, 37)];
    [btnCall setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [btnCall addTarget:self action:@selector(btnCallEvent:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:btnCall];
    
    
    UIButton* btnSendMessage = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth, 0, btnWidth, 37)];
    [btnSendMessage addTarget:self action:@selector(btnSendmessageEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    [btnSendMessage setImage:[UIImage imageNamed:@"msg_small"] forState:UIControlStateNormal];
    [self.footView addSubview:btnSendMessage];
    
    UIButton* btnEditResult = [[UIButton alloc] initWithFrame:CGRectMake(2*btnWidth, 0, btnWidth, 37)];
    [btnEditResult addTarget:self action:@selector(btnEditEvent:)
            forControlEvents:UIControlEventTouchUpInside];
    [btnEditResult setImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
    [self.footView addSubview:btnEditResult];
//    self.footView.backgroundColor = [UIColor redColor];
}
-(void)viewDidLayoutSubviews{
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];

    if([user.role isEqual:@"manager"]|| [self.type isEqualToString:@"cluecount"]){
        CGRect frame = self.tableView.frame;
        frame.size.height = DEVICERECT.size.height -frame.origin.y;
        self.tableView.frame = frame;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tableView.frame = CGRectMake(0, 0, 320, 100);
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:@"线索详情"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClueDetailTableViewCell* cell
    = (ClueDetailTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ClueDetailTableViewCell"
                                                                     forIndexPath:indexPath];
    
    ClueHistory* history = [self.dataSource objectAtIndex:indexPath.row];
    cell.lbDate.text = history.optdate;
    cell.lbResult.text = history.followersult;
    cell.lbUser.text = history.optuser;
    return cell;
}
-(IBAction)btnCallEvent:(id)sender{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"拨打%@?",
                                                             self.lbLinkTel.text]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 1004;
    [alert show];
}
-(IBAction)btnSendmessageEvent:(id)sender{
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
        controller.recipients = [NSArray arrayWithObject:self.lbLinkTel.text];
        controller.body =
        [NSString stringWithFormat:@"消息提醒%@,您好! 感谢您关注%@ 欢迎您到店看车试驾,%@将竭诚为您服务。电话:%@ %@,地址%@.", self.lbName.text, self.lbCarType.text, user.shopName,
         user.salesPhone, user.salesName, user.shopaddress
         ];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
//        [self presentedViewController:controller animated:YES];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信"];//修改短信界面标题
    }else{
        [UIAlertView alert:@"设备没有短信功能"];
    }

//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://2222"]];
}
-(IBAction)btnEditEvent:(id)sender{
    [self performSegueWithIdentifier:@"segNavToEdit" sender:sender];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1 && alertView.tag == 1004){
        NSLog(@"call %@", self.lbLinkTel.text);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",
                                                                         self.lbLinkTel.text]]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[EditClueViewController class]]){
        EditClueViewController* ecvc = (EditClueViewController*)segue.destinationViewController;
        ecvc.cid = self.clueItem.identity;
        ecvc.cLevel = self.clueItem.level;
        ecvc.carseriesname = self.clueItem.carseriesname;
        ecvc.carmodelname = self.clueItem.carmodelname;
        ecvc.carmodelid = self.clueItem.carmodelid;
        ecvc.carseriesid = self.clueItem.carseriesid;
    }
}

-(void) loadData:(NSString*)identity{
    ClueService* service = [[ClueService alloc] init];
    [service getClueDetail:identity andCompleteBlock:^(id obj, NSError *err) {
        ClueDetailInfo* detail = (ClueDetailInfo*)obj;
        self.clueItem = detail;
        self.lbName.text = detail.name;
        self.lbLinkTel.text = detail.mobile;
        self.lbCarType.text = detail.cartype;
        self.lbLevel.text = detail.level;
        self.lbSource.text = detail.source;
        self.dataSource = detail.history;
        [self.tableView reloadData];
    }];
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:^{
    }];
    NSLog(@"%d", result);
    switch ( result ) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:// send failed
            [UIAlertView alert:@"发送失败"];
            break;
        case MessageComposeResultSent:
            [UIAlertView alert:@"发送成功"];
            break;
        default:
            break;
    }
}

@end
