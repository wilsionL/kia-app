//
//  ClueViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/1.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "ClueViewController.h"

#import "ClueService.h"
#import "ClueMasterInfo.h"

#import "MBProgressHUD.h"
#import "UIAlertView+Show.h"
#import "JNKeychain.h"
#import "UserModel.h"
#import "UIColor+HexColor.h"
#import "ClueTableViewCell.h"
#import "ClueDetailViewController.h"
@interface ClueViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray* comeDataSource;
@property (nonatomic, strong) NSArray* backDataSource;
@property (nonatomic, strong) NSArray* displayDataSource;
@property (nonatomic, strong)  UIButton* btnComeList;
@property (nonatomic, strong)  UIButton* btnBackList;
@property (nonatomic, weak) IBOutlet UIView* headerView;
@property (nonatomic, strong)  UIView* vwComeLine;
@property (nonatomic, strong)  UIView* vwBackLine;

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation ClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"ClueTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ClueTableViewCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
//    if(![user.role isEqual:@"manager"]){
//        self.navigationItem.rightBarButtonItem =
//        [[UIBarButtonItem alloc] initWithTitle:@"新建"
//                                         style:UIBarButtonItemStyleDone
//                                        target:self
//                                        action:@selector(btnNewClue:)];
//
//    }
    [self BuildHeaderTab];
    [self.btnBackList setTitle:@"今日回访(0)"
                      forState:UIControlStateNormal];
    
    [self.btnComeList setTitle:@"今日到店(0)"
                      forState:UIControlStateNormal];
    if([self.curType isEqualToString:@"come"]){
        [self setComeState];
    }else{
        [self setBackState];
    }
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:@"全部线索"];
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
        [self loadData];
    }

}
-(void)BuildHeaderTab{

    CGFloat width = (self.headerView.frame.size.width - 1) / 2;
    CGFloat height = self.headerView.frame.size.height - 2;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    self.btnComeList = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnComeList.frame = frame;

    
    self.btnBackList = [UIButton buttonWithType:UIButtonTypeCustom];
//    frame.origin.x += (width + 1);
    frame = CGRectMake(width + 1, 0, width, height);
    self.btnBackList.frame = frame;
    
    self.vwComeLine = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 2)];
    self.vwBackLine = [[UIView alloc] initWithFrame:CGRectMake(width + 1, height, width, 2)];
    
    [self.btnBackList addTarget:self action:@selector(btnBackListEvent:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.btnComeList addTarget:self action:@selector(btnComeListEvent:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:self.btnBackList];
    [self.headerView addSubview:self.btnComeList];
    [self.headerView addSubview:self.vwBackLine];
    [self.headerView addSubview:self.vwComeLine];
    
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
    
    ClueMasterInfo* info = [self.displayDataSource objectAtIndex:indexPath.row];
    cell.lbCarType.text = info.cartype;
    cell.lbDate.text = info.comedate;
    cell.lbName.text = info.name;
    cell.lbStatus.text = info.phone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"navDetailSeg" sender:indexPath];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.destinationViewController isKindOfClass:[ClueDetailViewController class]]){
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        ClueMasterInfo* info = (ClueMasterInfo*)[self.displayDataSource objectAtIndex:indexPath.row];
        ClueDetailViewController* vw = (ClueDetailViewController*)(segue.destinationViewController);
        vw.identity = info.identity;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(IBAction)btnComeListEvent:(id)sender{
    [self setComeState];
    
}
-(IBAction)btnBackListEvent:(id)sender{
    [self setBackState];
   
}
-(void)setComeState{
    self.vwComeLine.backgroundColor = [UIColor colorWithHex:0xbb162bff];
    self.vwBackLine.backgroundColor = [UIColor clearColor];
    [self.btnComeList setTitleColor:[UIColor colorWithHex:0xbb162bff] forState:UIControlStateNormal];
    
    [self.btnBackList setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.displayDataSource = self.comeDataSource;
    [self.tableView reloadData];
}
-(void)setBackState{
    self.vwComeLine.backgroundColor = [UIColor clearColor];
    self.vwBackLine.backgroundColor = [UIColor colorWithHex:0xbb162bff];
    
    [self.btnBackList setTitleColor:[UIColor colorWithHex:0xbb162bff] forState:UIControlStateNormal];
    [self.btnComeList setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.displayDataSource = self.backDataSource;
    [self.tableView reloadData];
}
-(void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ClueService* service = [[ClueService alloc] init];

    [service listClue:@"Comelist" andCompleteBlock:^(id obj, NSError *err) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        
        self.comeDataSource = obj;
        [service listClue:@"Backlist" andCompleteBlock:^(id obj, NSError *err) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(err != nil){
                [UIAlertView alert:err.localizedDescription];
                return;
            }
            self.backDataSource = obj;
            [self.btnBackList setTitle:[NSString stringWithFormat:@"今日回访(%ld)", (unsigned long)self.backDataSource.count]
                              forState:UIControlStateNormal];
            
            [self.btnComeList setTitle:[NSString stringWithFormat:@"今日到店(%ld)", (unsigned long)self.comeDataSource.count]
                              forState:UIControlStateNormal];
            
            if([self.curType isEqualToString:@"come"]){
                [self setComeState];
            }else{
                [self setBackState];
            }

//            self.backDataSource = self.backDataSource;
//            self.displayDataSource = self.comeDataSource;
//            [self.tableView reloadData];
        }];
       
    }];
}

-(void)btnNewClue:(id)sender{
    [self performSegueWithIdentifier:@"segNavNewClue" sender:nil];
}
@end
