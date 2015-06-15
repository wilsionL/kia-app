//
//  ChannelViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/5.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "ChannelViewController.h"
#import "BaseDataIitem.h"
#import "BaseDataService.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Show.h"
@interface ChannelViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray* dataSource1;
@property (nonatomic, strong) NSArray* dataSource2;
@property (nonatomic, weak) IBOutlet UITableView* tableView1;
@property (nonatomic, weak) IBOutlet UITableView* tableView2;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    
    [self.tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
    [self loadSubCategory:self.category andThirdCategory:self.subCategoryValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableView1){
        return self.dataSource1.count;
    }
    else {
        return self.dataSource2.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    ChannelInfo* ci = nil;
    if(tableView == self.tableView1){
        cell = [self.tableView1 dequeueReusableCellWithIdentifier:@"cell1"
                                                     forIndexPath:indexPath];
        ci = [self.dataSource1 objectAtIndex:indexPath.row];
        if([ci.channelID isEqualToString:self.subCategoryValue.channelID]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else{
        cell = [self.tableView2 dequeueReusableCellWithIdentifier:@"cell2"
                                                     forIndexPath:indexPath];
        ci = [self.dataSource2 objectAtIndex:indexPath.row];
        
        if([ci.channelID isEqualToString:self.thirdCategoryValue.channelID]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    cell.textLabel.text = ci.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelInfo* ci = nil;
    if(tableView == self.tableView1){
        ci = [self.dataSource1 objectAtIndex:indexPath.row];
        self.subCategoryValue = ci;
        [self.tableView1 reloadData];
        [self loadThirdCategory:self.subCategoryValue];
    }
    else{
        ci = [self.dataSource2 objectAtIndex:indexPath.row];
        self.thirdCategoryValue = ci;
        if(self.delegate != nil &&
           [self.delegate respondsToSelector:@selector(SelectedChannel:andThird:)]){
            [self.delegate SelectedChannel:self.subCategoryValue andThird:ci];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) loadSubCategory:(ChannelInfo*) cid andThirdCategory:(ChannelInfo*)tid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getChannelSubCategory:cid.channelID andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource1 = obj;
            if(tid == nil && self.dataSource1.count > 0){
                ChannelInfo* ci = [self.dataSource1 objectAtIndex:0];
                [self loadThirdCategory:ci];
            }
            else if(tid != nil && self.dataSource1.count > 0){
                [self loadThirdCategory:tid];
            }
            [self.tableView1 reloadData];
            
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
-(void)loadThirdCategory:(ChannelInfo*) pid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getChannelThirdCategory:pid.channelID andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.dataSource1 = obj;
            [self.tableView2 reloadData];
            
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
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
