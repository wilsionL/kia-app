//
//  NofollowClueViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/5.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "NofollowClueViewController.h"
#import "ClueService.h"
#import "ClueMasterInfo.h"
#import "UIColor+HexColor.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Show.h"
#import "JNKeychain.h"
#import "UserModel.h"
#import "ClueDetailViewController.h"
#import "AuditViewController.h"
#import "ClueTableViewCell.h"

@interface NofollowClueViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* displayDataSource;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation NofollowClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
//    if(![user.role isEqual:@"manager"]){
//        self.navigationItem.rightBarButtonItem =
//        [[UIBarButtonItem alloc] initWithTitle:@"新建"
//                                         style:UIBarButtonItemStyleDone
//                                        target:self
//                                        action:@selector(btnNewClue:)];
//        
//    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClueTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ClueTableViewCell"];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if([self.type isEqualToString:@"audit"]){
        [self loadAuditData];
    }
    else if([self.type isEqualToString:@"cluecount"]){
        [self loadAllClueData];
    }else{
        [self loadData];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.tableView.frame = CGRectMake(0, 0, 320, 100);
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:self.title];
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    if(![user.role isEqual:@"manager"]){
        CGRect frame = frame = CGRectMake(0, 0, 29, 29);
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = frame;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"add"]
                               forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(btnNewClue:)
              forControlEvents:UIControlEventTouchUpInside];
        [self buildRightView:rightButton];
    }
    if([AppDelegate isNeedRefresh]){
        if([self.type isEqualToString:@"audit"]){
            [self loadAuditData];
        }else{
            [self loadData];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClueTableViewCell* cell = (ClueTableViewCell*)
    [self.tableView dequeueReusableCellWithIdentifier:@"ClueTableViewCell"
                                         forIndexPath:indexPath];
    
    CluesAduit* info = [self.displayDataSource objectAtIndex:indexPath.row];
    cell.lbCarType.text = info.cartype;
    cell.lbDate.text = info.updatetime;
    cell.lbName.text = info.name;
    cell.lbStatus.text = info.phone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.type isEqualToString:@"audit"]){
        [self performSegueWithIdentifier:@"segNavAudit" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"segNoFollowToDetail" sender:indexPath];
        
    }
}
-(void)loadData{
    
    ClueService* service = [[ClueService alloc] init];
    NSString* parameter = nil;
    if([self.type isEqualToString:@"nofollowup"]){
        parameter = @"1";
    }
    else if([self.type isEqualToString:@"timeoutremind"]){
        parameter = @"3";
    }else{
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service listSaleCluesList:parameter andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        CluesAduitList* list = obj;
        self.displayDataSource = list.CluesAduit;
        [self.tableView reloadData];
    }];
}
-(void)loadAllClueData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ClueService* service = [[ClueService alloc] init];
    [service listAllCluesList:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        CluesAduitList* list = obj;
        self.displayDataSource = list.CluesAduit;
        [self.tableView reloadData];
    }];
}
-(void)loadAuditData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ClueService* service = [[ClueService alloc] init];
    [service listAduitClues:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        CluesAduitList* list = obj;
        self.displayDataSource = list.CluesAduit;
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    if([segue.destinationViewController isKindOfClass:[ClueDetailViewController class]]){
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        CluesAduit* audit = [self.displayDataSource objectAtIndex:indexPath.row];
    
        ClueDetailViewController* ctrl = segue.destinationViewController;
        ctrl.identity = audit.identity;
        ctrl.type = self.type;
    }
    else if([segue.destinationViewController isKindOfClass:[AuditViewController class]]){
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        CluesAduit* audit = [self.displayDataSource objectAtIndex:indexPath.row];
        
        AuditViewController* ctrl = segue.destinationViewController;
        ctrl.identity = audit.identity;

    }
}
-(void)btnNewClue:(id)sender{
    [self performSegueWithIdentifier:@"segNofollowNavNewClue" sender:nil];
}

@end
