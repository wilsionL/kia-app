//
//  SelectedConditionViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "SelectedConditionViewController.h"
#import "MBProgressHUD.h"
#import "BaseDataService.h"
#import "UIAlertView+Show.h"
#import "BaseDataIitem.h"
#import "ClueLevelTableViewCell.h"
#import "ChannelViewController.h"
@interface SelectedConditionViewController ()<UITableViewDataSource,
UITableViewDelegate, ChannelViewControllerDelegate, SelectedConditionViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSource;
@end

@implementation SelectedConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell1"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClueLevelTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClueLevelTableViewCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if([self.type isEqualToString:@"cartype"]){
        [self loadCarType];
    }
    else if([self.type isEqualToString:@"carmodel"]){
        [self loadCarModel:self.subType];
    }
    else if([self.type isEqualToString:@"basedata"]){
        [self loadBaseData:self.subType];
    }
    else if([self.type isEqualToString:@"channel"]){
        
    }
    else if([self.type isEqualToString:@"province"]){
        [self loadProvice];
    }
    else if([self.type isEqualToString:@"city"]){
        [self loadCity:self.subType];
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    
    NSString* keyId = nil;
    
    if([self.type isEqualToString:@"province"]
       || [self.type isEqualToString:@"city"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"
                                               forIndexPath:indexPath];
        KeyValue* item = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        
        if(self.value != nil && [self.value isEqualToString:item.identity])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if([self.type isEqualToString:@"basedata"] && [self.subType isEqualToString:@"5"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"
                                               forIndexPath:indexPath];
        BaseDataItem* item = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = item.keycode;
        keyId = item.identity;
        
    }
    else if([self.type isEqualToString:@"basedata"] && [self.subType isEqualToString:@"2"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClueLevelTableViewCell"
                                               forIndexPath:indexPath];
        ClueLevelTableViewCell* cltvc = (ClueLevelTableViewCell*)cell;
        
        BaseDataItem* item = [self.dataSource objectAtIndex:indexPath.row];
//        cell.textLabel.text = item.keycode;
//        cell.detailTextLabel.text = item.ramark;
        cltvc.lbField1.text = [NSString stringWithFormat:@"等级%@", item.keycode];
        cltvc.lbField2.text = item.ramark;
        keyId = item.identity;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"
                                               forIndexPath:indexPath];
    }
    if(self.value != nil && [self.value isEqualToString:keyId])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
//    BaseDataItem* item = [self.dataSource objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.ramark;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id val1 = nil, val2 = nil, val3 = nil;
    // 如果该选择作为省份城市时执行如下代码
    if([self.type isEqualToString:@"province"]
       || [self.type isEqualToString:@"city"]){
        val1 = [self.dataSource objectAtIndex:indexPath.row];
    }
    else if([self.type isEqualToString:@"basedata"]){
        KeyValue* item = [[KeyValue alloc] init];
        BaseDataItem* bdi = [self.dataSource objectAtIndex:indexPath.row];
        item.identity = bdi.identity;
        item.name = [NSString stringWithFormat:@"等级%@", bdi.keycode];
        val1 = item;
    }
    if(self.delegate != nil &&
       [self.delegate respondsToSelector:@selector(SelectedItem:andFieldName
                                                   :andNavType:andSubType:andValue1:andValue2:andValue3:)]){
        [self.delegate SelectedItem:self.category
                       andFieldName:self.fieldName
                         andNavType:self.type
                         andSubType:self.subType
                          andValue1:val1
                          andValue2:val2
                          andValue3:val3];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    BaseDataItem* item = [self.dataSource objectAtIndex:indexPath.row];
//    if(self.delegate != nil &&
//       [self.delegate respondsToSelector:@selector(SelectedBaseDataItems:)])
//    {
//        [self.delegate SelectedBaseDataItems:nil];
//    }
//    NSLog(@"%@", item);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 获取基础数据
-(void)loadBaseData:(NSString*)type{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:type andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource = obj;
             [self.tableView reloadData];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取车系
-(void)loadCarType{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarTypeList:@"0" andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource = obj;
             [self.tableView reloadData];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取车型
-(void)loadCarModel:(NSString*) subType{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarModelList:@"0" andType:subType andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource = obj;
             [self.tableView reloadData];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
    
}
// 获取省份信息
-(void)loadProvice{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getProviceList:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource = obj;
            [self.tableView reloadData];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取城市信息
-(void)loadCity:(NSString*)provice{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCityList:provice andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource = obj;
            [self.tableView reloadData];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}


-(void)SelectedItem:(NSString *)category andFieldName:(NSString *)fieldName andNavType:(NSString *)navType andSubType:(NSString *)subType andValue1:(id)val1 andValue2:(id)val2 andValue3:(id)val3{
    
}
-(void)SelectedChannel:(ChannelInfo *)sub andThird:(ChannelInfo *)third{
    if([self.delegate respondsToSelector:@selector(SelectedItem:andFieldName
                                                :andNavType:andSubType:andValue1:andValue2:andValue3:)]){
        [self.delegate SelectedItem:self.category
                       andFieldName:self.fieldName
                         andNavType:self.type
                         andSubType:self.subType
                          andValue1:self.objValue
                          andValue2:sub
                          andValue3:third];
    }
}
@end
