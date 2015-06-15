//
//  AuditViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "AuditViewController.h"
#import "NewClue1TableViewCell.h"
#import "UIColor+HexColor.h"

#import "UIPopPickerView.h"
#import "UIPopDateTimePickerView.h"
#import "ClueService.h"
#import "SalesService.h"
#import "Sales.h"
#import "BaseDataIitem.h"
#import "BaseDataService.h"
#import "UIAlertView+Show.h"
#define ACVC_PICKER  1050
#define ACVC_CONTAIN_PICKER  1051


@interface AuditViewController ()<UITableViewDataSource, UITableViewDelegate,
    UIPopPickerViewDelegate, UIPopDateTimePickerViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* btnComfirm;
@property (nonatomic, weak) IBOutlet UIButton* btnProcess;
@property (nonatomic, strong) NSArray* layoutDatasource1;
@property (nonatomic, strong) NSArray* layoutDatasource2;
@property (nonatomic, strong) NSArray* displayDataSource;
@property (nonatomic, strong) NSArray* salesDataSource;
@property (nonatomic, strong) NSArray* levelDataSource;
@property (nonatomic, strong) UIPopPickerView* overlayPickerView;

@property (nonatomic, strong) UIPopDateTimePickerView* overlayDateTimePicker;
@end

@implementation AuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.overlayPickerView = [[UIPopPickerView alloc] initWithParent:self.view];
    self.overlayPickerView.delegate = self;
    
    self.overlayDateTimePicker = [[UIPopDateTimePickerView alloc] initWithParent:self.view];
    self.overlayDateTimePicker.delegate = self;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewClue1TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"NewClue1TableViewCell"];
    
    self.layoutDatasource1 = @[
                               @{
                                   @"title":@"审核意见",
                                   @"field":@"comments",
                                   @"placeholder":@"请输入审核意见",
                                   @"isEdit":@1,
                                   @"value":[[NSMutableDictionary alloc] init]
                                   }
                               ];
    
    self.layoutDatasource2 = @[
                               @{
                                   @"title":@"线索等级",
                                   @"field":@"levelID",
                                   @"placeholder":@"必填",
                                   @"isEdit":@0,
                                   @"value":[[NSMutableDictionary alloc] init]
                                   },
                               @{
                                   @"title":@"销售顾问",
                                   @"field":@"salesID",
                                   @"isEdit":@0,
                                   @"placeholder":@"必填",
                                   @"value":[[NSMutableDictionary alloc] init]
                                   },
                               @{
                                   @"title":@"下次跟进时间",
                                   @"field":@"followtime",
                                   @"isEdit":@0,
                                   @"placeholder":@"必填",
                                   @"value":[[NSMutableDictionary alloc] init]
                                   },
                               @{
                                   @"title":@"审核意见",
                                   @"field":@"comments",
                                   @"isEdit":@1,
                                   @"placeholder":@"请输入审核意见",
                                   @"value":[[NSMutableDictionary alloc] init]
                                   }
                               ];
    self.displayDataSource = self.layoutDatasource1;
    [self.tableView reloadData];
    
//    self.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"保存"
//                                     style:UIBarButtonItemStyleDone
//                                    target:self
//                                    action:@selector(btnSaveEvent:)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    [self setNavigationTitle:@"战败审核"];
    
//    [self setNavigationTitle:self.title];
    CGRect frame = CGRectMake(0, 0, 78, 30);
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    
//    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_save"]
                           forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(btnSaveEvent:)
          forControlEvents:UIControlEventTouchUpInside];
    [self buildRightView:rightButton];
}
#pragma table
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewClue1TableViewCell* cell = (NewClue1TableViewCell*)
    [self.tableView dequeueReusableCellWithIdentifier:@"NewClue1TableViewCell"
                                         forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary* dict = [self.displayDataSource objectAtIndex:indexPath.row];
    NSMutableDictionary* val = [dict objectForKey:@"value"];
    cell.lbName.text = [dict objectForKey:@"title"];
    cell.lbValue.text = [val objectForKey:@"text"];
    cell.valDict = val;
    [cell.lbValue resignFirstResponder];
    if([[dict objectForKey:@"isEdit"] isEqual: @1]){
        cell.lbValue.enabled = YES;
    }
    else{
        cell.lbValue.enabled = NO;
    }
    
    cell.lbValue.placeholder = [dict  objectForKey:@"placeholder"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView reloadData];
    if(self.displayDataSource == self.layoutDatasource1) return;
    NSDictionary* dict = [self.layoutDatasource2 objectAtIndex:indexPath.row];
    if([[dict objectForKey:@"field"] isEqualToString:@"levelID"]){
        [self loadClueLevel:indexPath.row + 500];
    }
    else if([[dict objectForKey:@"field"] isEqualToString:@"salesID"]){
        [self loadSalesList:indexPath.row + 500];
    }
    else if([[dict objectForKey:@"field"] isEqualToString:@"followtime"]) {
        self.overlayDateTimePicker.tag = indexPath.row + 500;
        [self.overlayDateTimePicker show];
    }
//    [self performSegueWithIdentifier:@"sgeAssignToDetail" sender:indexPath];
}
#pragma UIPopPickerViewdelegate for datasource
-(NSString*)UIPopPickerView:(NSArray *)dataSource titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id item = [dataSource objectAtIndex:row];
    if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*) item;
        return [NSString stringWithFormat:@"%@   %@", val.keycode, val.ramark];
    }
    else if([item isKindOfClass:[Sales class]]){
        Sales* val = (Sales*) item;
        return val.name;
    }
    return nil;
}
#pragma UIPopPickerViewdelegate
-(void)UIPopPickerView:(UIPopPickerView *)pickerView andSelectedItem:(id)item{
    NSLog(@"%@",item);
    if(self.displayDataSource == self.layoutDatasource1) return;
    NSInteger idx = pickerView.tag - 500;
    if(idx < 0 && idx >= self.layoutDatasource2.count) return;
    NSDictionary* dict = [self.layoutDatasource2 objectAtIndex:idx];
    NSMutableDictionary* valueDict = [dict objectForKey:@"value"];
    [valueDict setObject:item forKey:@"val"];
    if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*) item;
        [valueDict setObject:[NSString stringWithFormat:@"%@-%@",val.keycode, val.ramark]
                      forKey:@"text"];
    }
    else if([item isKindOfClass:[Sales class]]){
        Sales* val = (Sales*) item;
        [valueDict setObject:val.name
                      forKey:@"text"];
    }
    [self.tableView reloadData];
}

#pragma UIPopDateTimePickerViewDelegate
-(void)UIPopDateTimePickerView:(UIPopDateTimePickerView *)pickerView andSelectedDate:(NSDate *)date andTime:(NSDate *)time{
    if(self.displayDataSource == self.layoutDatasource1) return;
    
    NSInteger idx = pickerView.tag - 500;
    if(idx < 0 && idx >= self.layoutDatasource2.count) return;
    NSDictionary* dict = [self.layoutDatasource2 objectAtIndex:idx];
    NSMutableDictionary* valueDict = [dict objectForKey:@"value"];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger unitFlags1 = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMinute;
    NSDateComponents *comps1 = [calendar components:unitFlags1 fromDate:time];

    NSString* strdatetime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00",
                             comps.year, comps.month, comps.day,
                             comps1.hour, comps1.minute];
    [valueDict setObject:strdatetime forKey:@"val" ];
    [valueDict setObject:strdatetime forKey:@"text"];
    // yyyy-MM-dd HH:mm:ss
    NSLog(@"%@,%@, %@",date, time, strdatetime);
    [self.tableView reloadData];
}
-(IBAction)btnComfirmEvent:(id)sender{
    [self.btnComfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnProcess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnComfirm setBackgroundImage:[UIImage imageNamed:@"btn_selected"]
                               forState:UIControlStateNormal ];
    
    [self.btnProcess setBackgroundImage:[UIImage imageNamed:@"btn_unselected"]
                               forState:UIControlStateNormal ];
    
    self.displayDataSource = self.layoutDatasource1;
    [self.tableView reloadData];
}
-(IBAction)btnProcessEvent:(id)sender{
    [self.btnProcess setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnComfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnProcess setBackgroundImage:[UIImage imageNamed:@"btn_selected"]
                               forState:UIControlStateNormal ];
    
    [self.btnComfirm setBackgroundImage:[UIImage imageNamed:@"btn_unselected"]
                               forState:UIControlStateNormal ];
    
    self.displayDataSource = self.layoutDatasource2;
    [self.tableView reloadData];
    
}
-(void)btnSaveEvent:(id)sender{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary* fieldInfo in self.displayDataSource) {
        NSMutableDictionary* dict = [fieldInfo objectForKey:@"value"];
        NSString* fieldName = [fieldInfo objectForKey:@"field"];
        if(fieldName.length == 0) continue;
        id value = [dict objectForKey:@"val"];
        if(value == nil) continue;
        if([value isKindOfClass:[NSString class]] && ((NSString*)value).length != 0){
            [parameters setObject:value forKey:fieldName];
        }
        else if([value isKindOfClass:[Sales class]]){
            Sales* sale = (Sales*)value;
            [parameters setObject:sale.identity forKey:@"salesID"];
            [parameters setObject:sale.name forKey:@"salesName"];
        }
        else if([value isKindOfClass:[BaseDataItem class]]){
            BaseDataItem* item = (BaseDataItem*)value;
            [parameters setObject:item.identity forKey:@"levelID"];
            [parameters setObject:item.keycode forKey:@"levelName"];
        }
    }
    NSString* type = nil;
    if(self.displayDataSource == self.layoutDatasource1){
        if(parameters.count != 1){
            [UIAlertView alert:@"请输入审核意见"];
            return;
        }
        type = @"2";
        [parameters setObject:@"" forKey:@"levelID"];
        [parameters setObject:@"" forKey:@"levelName"];
        [parameters setObject:@"" forKey:@"salesName"];
        [parameters setObject:@"" forKey:@"salesID"];
        [parameters setObject:@"" forKey:@"followtime"];
        
    }
    else if(self.displayDataSource == self.layoutDatasource2){
        if(parameters.count != 6){
            [UIAlertView alert:@"请填写所有的内容再提交"];
            return;
        }
        type = @"1";
    }
    if(type == nil) return;
    [parameters setObject:self.identity forKey:@"id"];
    [parameters setObject:type forKey:@"type"];
    ClueService* service = [[ClueService alloc] init];
    [service defeataudit:parameters andCompleteBlock:^(id obj, NSError *err) {
        if(err == nil){
            [UIAlertView alert:@"提交成功"];
            [AppDelegate setRefresh];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取线索等级
-(void) loadClueLevel:(NSInteger) tag{
    self.overlayPickerView.tag = tag;
    if(self.levelDataSource != nil){
        self.overlayPickerView.dataSource = self.levelDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
        return;
    }
//    NSMutableArray* ds = [[NSMutableArray alloc] init];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"2" andCompleteBlock:^(id obj, NSError *err) {
        if(err != nil){
            return;
        }
        NSMutableArray* ds = [[NSMutableArray alloc] init];
        self.levelDataSource = obj;
        for(NSInteger idx = 0; idx < self.levelDataSource.count;
            idx++){
            BaseDataItem* item = [self.levelDataSource objectAtIndex:idx];
            NSString* strLevel = [NSString stringWithFormat:@"%@", item.keycode];
            
            if(![strLevel isEqualToString:@"F"] &&
               ![strLevel isEqualToString:@"FO"] &&
               ![strLevel isEqualToString:@"O"]){
                [ds addObject:item];
            }
        }
        self.levelDataSource = ds;
        
        self.overlayPickerView.dataSource = self.levelDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }];
}
// 获取销售顾问
-(void) loadSalesList:(NSInteger) tag{
    if(self.salesDataSource != nil){
        self.overlayPickerView.dataSource = self.salesDataSource;
        self.overlayPickerView.tag = tag;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
        return;
    }
    SalesService* service = [[SalesService alloc] init];
    [service getSalesList:^(id obj, NSError *err) {
        self.salesDataSource = obj;
        self.overlayPickerView.tag = tag;
        self.overlayPickerView.dataSource = self.salesDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
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
