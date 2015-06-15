//
//  AssignClueViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "AssignClueViewController.h"
#import "ClueService.h"
#import "Sales.h"
#import "SalesService.h"
#import "ClueMasterInfo.h"
#import "UIColor+HexColor.h"

#import "MBProgressHUD.h"
#import "UIAlertView+Show.h"
#import "JNKeychain.h"
#import "UserModel.h"
#import "AssignClueTableViewCell.h"
#import "ClueDetailViewController.h"
#define ACVC_PICKER  1050
#define ACVC_CONTAIN_PICKER  1051
#define ACVC_FOOTERVIEW  1061

#define RIGHTBUTTON_STATE1 111

#define RIGHTBUTTON_STATE2 112

@interface AssignClueViewController ()
<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,
UIPickerViewDelegate, AssignClueTableViewCellDelegate>

@property (nonatomic, strong) NSArray* displayDataSource;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray<Sales>* salesList;
@property (nonatomic, weak) Sales* selectedSales;
@property (nonatomic, strong) NSMutableArray* selectedArray;
@property (nonatomic, assign) CGRect tableviewFrame;
//@property (nonatomic, weak) UIPickerView* pickerView;
@end

@implementation AssignClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"AssignClueTableViewCell" bundle:nil] forCellReuseIdentifier:@"AssignClueTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"批量"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(btnAllProcessEvent:)];
    self.navigationItem.rightBarButtonItem.tag = RIGHTBUTTON_STATE1;
    
    
    // 添加选择销售代表空间
    CGRect frame = CGRectMake(0, DEVICERECT.size.height - 216,
                              DEVICERECT.size.width, 216);
    UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:frame];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.tag = ACVC_PICKER;
    pickerView.backgroundColor = [UIColor whiteColor];
    frame = self.view.frame;
    frame.origin.y = DEVICERECT.size.height;
    UIView* container = [[UIView alloc] initWithFrame:frame];
    container.tag = ACVC_CONTAIN_PICKER;
    container.backgroundColor = [UIColor colorWithHex:OVERLAYCOLOR];
    [container addSubview:pickerView];
//    self.pickerView.hidden = YES;
    
    //tool bar
    UIView* vwTitle = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICERECT.size.height - 216 - 44, DEVICERECT.size.width, 44)];
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICERECT.size.width, 44)];
    img.image = [UIImage imageNamed:@"popupwindow_bg"];
    vwTitle.backgroundColor = [UIColor whiteColor];
    [vwTitle addSubview:img];
    
//    vwTitle.backgroundColor = [UIColor redColor];
    UIButton* btnBack = [[UIButton alloc] initWithFrame:CGRectMake(20, 12, 47, 23)];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"button2"]
                       forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(20, 12, 56, 23) ;
    
    [btnBack addTarget:self action:@selector(btnSelectorBackEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [btnBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton* btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(DEVICERECT.size.width - 70, 12, 56, 23)];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.frame = CGRectMake(DEVICERECT.size.width - 56 - 20, 12, 56, 23) ;
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"button"]
                          forState:UIControlStateNormal];

    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    
    [btnConfirm addTarget:self action:@selector(btnSelectorConfirmEvent:) forControlEvents:UIControlEventTouchUpInside];
//    vwTitle.backgroundColor = [UIColor whiteColor];
//    [vwTitle setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupwindow_bg"]]];
    [vwTitle addSubview:btnBack];
    [vwTitle addSubview:btnConfirm];
    [container addSubview:vwTitle];
    [self.view addSubview:container];
    
    // 添加"分配至"View
    CGFloat footerHeight = 40;
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICERECT.size.height, DEVICERECT.size.width, footerHeight)];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICERECT.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:0xbb162bff];
    [footerView addSubview:lineView];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DEVICERECT.size.width - 80, 5, 60, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"分配至" forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnSetSelectedSale:)
  forControlEvents:UIControlEventTouchUpInside];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton* btnSelectItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelectItem.frame = CGRectMake(10, 5, 60, 28);
    [btnSelectItem setBackgroundImage:[UIImage imageNamed:@"btn_bg"]
                             forState:UIControlStateNormal];
    [btnSelectItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelectItem setTitle:@"选择" forState:UIControlStateNormal];
    [btnSelectItem addTarget:self
                      action:@selector(btnSelectItemEvent:)
            forControlEvents:UIControlEventTouchUpInside];
    
    footerView.tag = ACVC_FOOTERVIEW;
    
    [footerView addSubview:btn];
    [footerView addSubview:btnSelectItem];
    [self.view addSubview:footerView];
    [self LoadSales];
    if([self.type isEqualToString:@"noassign"]){
        [self loadNoFollowData];
    }else if([self.type isEqualToString:@"timeout"]){
        [self loadNoFollowTimeoutData];
    }
    self.tableviewFrame = self.tableView.frame;
    
}
-(void)viewWillAppear:(BOOL)animated{
    if([AppDelegate isNeedRefresh]){
        if([self.type isEqualToString:@"noassign"]){
            [self loadNoFollowData];
        }else if([self.type isEqualToString:@"timeout"]){
            [self loadNoFollowTimeoutData];
        }
    }
    
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    [self setNavigationTitle:self.title];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 38);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"批量" forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnAllProcessEvent:)
  forControlEvents:UIControlEventTouchUpInside];
    
    [self buildRightView:btn];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma table
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssignClueTableViewCell* cell = (AssignClueTableViewCell*)
    [self.tableView dequeueReusableCellWithIdentifier:@"AssignClueTableViewCell"
                                         forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber* checked = nil;
    id item = [self.displayDataSource objectAtIndex:indexPath.row];
    //    cell.lbCarType.text = info.;
    if([item isKindOfClass:[ClueMasterInfo class]]){
        ClueMasterInfo* clue = [self.displayDataSource objectAtIndex:indexPath.row];
        cell.lbUser.text = clue.salesname;
        cell.lbName.text = clue.name;
        cell.lbStatus.text = clue.mobile;
        cell.lbCarType.text = clue.cartype;
        cell.salesId = clue.salesid;
        checked = clue.isChecked;

    }else if([item isKindOfClass:[CluesAduit class]]){
        CluesAduit* info = [self.displayDataSource objectAtIndex:indexPath.row];
        cell.lbUser.text = info.salesname;
        cell.lbName.text = info.name;
        cell.lbStatus.text = info.phone;
        cell.lbCarType.text = info.cartype;
        cell.salesId = info.salesid;
        checked = info.isChecked;
    }
    if(self.navigationItem.rightBarButtonItem.tag == RIGHTBUTTON_STATE2){
        cell.checkbox.hidden = NO;
        cell.checkbox.checked = checked == nil || !checked.boolValue ? NO : YES;
    }
    else{
        cell.checkbox.hidden = YES;
    }
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"sgeAssignToDetail" sender:indexPath];
}
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.salesList.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Sales* sales = [self.salesList objectAtIndex:row];
    return sales.name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedSales = [self.salesList objectAtIndex:row];
}

#pragma AssignClueTableViewCellDelegate
-(void)SelectSales:(AssignClueTableViewCell *)cell{
    self.selectedArray = [[NSMutableArray alloc] init];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    // 暂存选择的数据
    [self.selectedArray addObject:[self.displayDataSource objectAtIndex:indexPath.row]];
    
    UIView* contanier =  (UIView*)[self.view viewWithTag:ACVC_CONTAIN_PICKER];
    
    
    UIPickerView* pv = (UIPickerView*)[contanier viewWithTag:ACVC_PICKER];
    for(int idx = 0; idx < self.salesList.count; idx++){
        Sales* sale = [self.salesList objectAtIndex:idx];
        if([cell.salesId isEqualToString:sale.identity]){
            [pv selectRow:idx inComponent:0 animated:YES];
            break;
        }
    }
    
//    [pv reloadAllComponents];
    [self.view bringSubviewToFront:contanier];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    contanier.frame = self.view.frame;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)SelectClueInfo:(AssignClueTableViewCell *)cell andIsChecked:(Boolean)checked{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CluesAduit* audit = [self.displayDataSource objectAtIndex:indexPath.row];
    audit.isChecked = [NSNumber numberWithBool:checked];
}
-(void)btnSelectorConfirmEvent:(id)sender{
    do{
        if(self.selectedArray == nil || self.selectedArray.count == 0){
            break;
        }
        if(self.selectedSales == nil){
            self.selectedSales = [self.salesList objectAtIndex:0];
            //            break;
        }
        NSLog(@"self.selectedSales :%@",self.selectedSales );

        // 更新到用户选择的数据到数据源.
        NSMutableString* idx = [[NSMutableString alloc] init];
        for (CluesAduit* info in self.selectedArray) {
            CluesAduit* ca = (CluesAduit*) info;
            if(idx.length > 0){
                [idx appendString:@","];
            }
            [idx appendFormat:@"%@", ca.identity];
        }
        ClueService* service = [[ClueService alloc] init];
        [service Assign:idx andUserId:self.selectedSales.identity andCompleteBlock:^(id obj, NSError *err) {
            if(err != nil){
                [UIAlertView alert:err.localizedDescription];
            }
            else{
                // 刷新数据
                if(![self.type isEqualToString:@"timeout"]){
                    [self loadNoFollowData];
                }else{
                    [self loadNoFollowTimeoutData];
                }
                [AppDelegate setRefresh];
                [UIAlertView alert:@"分配成功"];
                
            }
        }];
    }while(false);
    UIView* contanier =  (UIPickerView*)[self.view viewWithTag:ACVC_CONTAIN_PICKER];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    CGRect frame = self.view.frame;
    frame.origin.y =  DEVICERECT.size.height;
    contanier.frame = frame;
    [UIView setAnimationDelegate:self];
    
    [self hiddenFooter];
    // 动画完毕后调用animationFinished
    // [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
-(void)btnSelectItemEvent:(id)sender{

    for(NSInteger idx = 0; idx < 10 && idx < self.displayDataSource.count; idx++){
		CluesAduit* audit = [self.displayDataSource objectAtIndex:idx];
		audit.isChecked = [NSNumber numberWithBool:YES];;
	}
    [self.tableView reloadData];
}
-(void)btnSelectorBackEvent:(id)sender{
    UIView* contanier =  (UIPickerView*)[self.view viewWithTag:ACVC_CONTAIN_PICKER];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    CGRect frame = self.view.frame;
    frame.origin.y =  DEVICERECT.size.height;
    contanier.frame = frame;
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    //    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
-(void)btnAllProcessEvent:(id)sender{
    NSInteger tag = self.navigationItem.rightBarButtonItem.tag;
    if(tag == RIGHTBUTTON_STATE1){
        [self showFooter];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.tag = RIGHTBUTTON_STATE2;
    }else{
        [self hiddenFooter];
        
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.tag = RIGHTBUTTON_STATE1;
    }
}
// 批量设置销售代表时操作
-(void)btnSetSelectedSale:(id)sender{
    self.selectedArray = [[NSMutableArray alloc] init];
    // 查找是否有选中的操作
    UIView* contanier =  (UIView*)[self.view viewWithTag:ACVC_CONTAIN_PICKER];
    for(NSInteger idx = 0; idx < self.displayDataSource.count; idx++){
        CluesAduit* ca = [self.displayDataSource objectAtIndex:idx];
        if(ca.isChecked.boolValue){
            [self.selectedArray addObject:ca];
        }
       
    }
    if(self.selectedArray.count == 0){
        [UIAlertView alert:@"请选择线索"];
        return;
    }
    [self.view bringSubviewToFront:contanier];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    contanier.frame = self.view.frame;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

}
-(void)showFooter{
    CGFloat footerHeight = 40;
    UIView* footerview =  (UIPickerView*)[self.view viewWithTag:ACVC_FOOTERVIEW];
    [self.view bringSubviewToFront:footerview];

    
    [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
    self.navigationItem.rightBarButtonItem.tag = RIGHTBUTTON_STATE2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];//动画时间长度，单位秒，浮点数
    CGRect frame = footerview.frame;
    frame.origin.y =  DEVICERECT.size.height - footerHeight;
    footerview.frame = frame;
    
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    
    frame = self.tableviewFrame;
    frame.size.height -= footerHeight;
    self.tableView.frame = frame;
}
-(void)hiddenFooter{
    CGFloat footerHeight = 40;
    UIView* footerview =  (UIPickerView*)[self.view viewWithTag:ACVC_FOOTERVIEW];
    self.navigationItem.rightBarButtonItem.tag = RIGHTBUTTON_STATE1;
    [self.navigationItem.rightBarButtonItem setTitle:@"批量"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];//动画时间长度，单位秒，浮点数
    CGRect frame = self.view.frame;
    frame.origin.y =  DEVICERECT.size.height;
    footerview.frame = frame;
    [UIView setAnimationDelegate:self];
    
    frame = self.tableviewFrame;
    frame.size.height += footerHeight;
    self.tableView.frame = frame;
}
-(void)loadNoFollowTimeoutData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ClueService* service = [[ClueService alloc] init];
    
    [service listSaleCluesList:@"2" andCompleteBlock:^(id obj, NSError *err) {
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
-(void)loadNoFollowData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ClueService* service = [[ClueService alloc] init];
    [service listClue:@"Assignlist" andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        self.displayDataSource = obj;
        [self.tableView reloadData];
    }];
}
-(void)LoadSales{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SalesService* service = [[SalesService alloc] init];
    [service getSalesList:^(id obj, NSError *err) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alert:err.localizedDescription];
            return;
        }
        self.salesList = obj;
        UIPickerView* pv =  (UIPickerView*)[self.view viewWithTag:ACVC_PICKER];
        [pv reloadAllComponents];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[ClueDetailViewController class]]){
        NSIndexPath* indexPath = (NSIndexPath*)sender;
         CluesAduit* audit = [self.displayDataSource objectAtIndex:indexPath.row];
        ClueDetailViewController* ctrl = segue.destinationViewController;
        ctrl.identity = audit.identity;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
