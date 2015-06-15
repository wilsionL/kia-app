//
//  NewClueViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/3.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "NewClueViewController.h"
#import "NewClue1TableViewCell.h"
#import "NewClue2TableViewCell.h"
#import "UIColor+HexColor.h"
#import "BaseDataIitem.h"
#import "UIAlertView+Show.h"
#import "MBProgressHUD.h"
#import "BaseDataService.h"
#import "ClueService.h"
#import "UIPopPickerView.h"
#import "NSString+util.h"
#import "UserModel.h"
#import "JNKeychain.h"
@interface NewClueViewController ()<UITableViewDataSource, UITableViewDelegate,UIPopPickerViewDelegate>
@property (nonatomic, strong) NSArray* titleInfoArr;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* plandataDataSource;
@property (nonatomic, strong) NSArray* carsDataSource;
@property (nonatomic, strong) NSArray* modelsDataSource;
@property (nonatomic, strong) NSArray* source1DataSource;
@property (nonatomic, strong) NSArray* source2DataSource;
@property (nonatomic, strong) NSArray* source3DataSource;
@property (nonatomic, strong) NSArray* levelDataSource;
@property (nonatomic, strong) NSArray* provinceDataSource;
@property (nonatomic, strong) NSArray* cityDataSource;
@property (nonatomic, strong) UIPopPickerView* overlayPickerView;
@end

@implementation NewClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.overlayPickerView = [[UIPopPickerView alloc] initWithParent:self.view];
    self.overlayPickerView.delegate = self;
    
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    
    NSMutableDictionary* cityDict = [[NSMutableDictionary alloc] init];
    [cityDict setObject:user.cityName forKey:@"text"];
    [cityDict setObject:user.cityid forKey:@"val"];
    
    NSMutableDictionary* provinceDict = [[NSMutableDictionary alloc] init];
    [provinceDict setObject:user.provinceName forKey:@"text"];
    [provinceDict setObject:user.provinceid forKey:@"val"];

    // Do any additional setup after loading the view.
    
//    self.navigationItem.leftBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"取消"
//                                     style:UIBarButtonItemStyleDone
//                                    target:self
//                                    action:@selector(btnCancel:)];
//    self.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"保存"
//                                     style:UIBarButtonItemStyleDone
//                                    target:self
//                                    action:@selector(btnSave:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewClue2TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"NewClue2TableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewClue1TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"NewClue1TableViewCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleInfoArr =
  @[@{
        @"key":@"客户信息",
        @"category":@"base",
        @"val":@[
                @{
                    @"key":@"姓名",
                    @"field":@"name",
                    @"placeholder":@"请输入姓名",
                    @"type":@0,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"性别",
                    @"field":@"sex",
                    @"type":@2,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"联系电话",
                    @"field":@"mobile",
                    @"placeholder":@"请输入联系方式",
                    @"type":@0,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"计划购车时间",
                    @"field":@"plandata",
                    @"placeholder":@"必填",
                    @"type":@1,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"意向车系",
                    @"field":@"cars",
                    @"placeholder":@"请选择意向车系",
                    @"type":@1,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"意向车型",
                    @"field":@"models",
                    @"placeholder":@"请选择意向车型",
                    @"type":@1,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                ]
        },
    @{
        @"key":@"来源信息",
        @"category":@"source",
        @"val":@[
                @{
                    @"key":@"线索来源",
                    @"field":@"source",
                    @"placeholder":@"请选择线索来源",
                    @"type":@1,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                @{
                    @"key":@"线索等级",
                    @"field":@"level",
                    @"placeholder":@"请选择线索等级",
                    @"type":@1,
                    @"must":@1,
                    @"value": [[NSMutableDictionary alloc] init],
                    },
                ]
        },
    @{
        @"key":@"客户所在省份",
        @"category":@"address",
        @"val":@[
                @{
                    @"key":@"所在省",
                    @"field":@"province",
                    @"placeholder":@"必填",
                    @"type":@1,
                    @"must":@1,
                    @"value": provinceDict
                    },
                @{
                    @"key":@"所在市",
                    @"field":@"city",
                    @"placeholder":@"必填",
                    @"type":@1,
                    @"must":@1,
                    @"value": cityDict
                    },
                ]
        },
    ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setNavigationTitle:@"新建线索"];
    CGRect frame = CGRectMake(0, 0, 47, 23);
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel"]
                          forState:UIControlStateNormal];
    [leftButton addTarget:self
                    action:@selector(btnBackEvent:)
          forControlEvents:UIControlEventTouchUpInside];
    [self buildLeftView:leftButton];
    
    frame = CGRectMake(0, 0, 56, 23);
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_save"]
                           forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(btnSave:)
          forControlEvents:UIControlEventTouchUpInside];
    [self buildRightView:rightButton];

    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary* group = [self.titleInfoArr objectAtIndex:section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    return groupCtx.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(10, 0, DEVICERECT.size.width, 44);
    UIView* headView = [[UIView alloc] initWithFrame:frame];
    // 添加圆点
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 16, 11, 11)];
    [imgView setImage:[UIImage imageNamed:@"point"]];
    [headView addSubview:imgView];
    frame = CGRectMake(20, 10, frame.size.width - 30, 22) ;
    UILabel* headLabel = [[UILabel alloc] initWithFrame:frame];
      NSDictionary* group = [self.titleInfoArr objectAtIndex:section];
    NSString* txt = [group objectForKey:@"key"];
     headLabel.text = txt;
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont systemFontOfSize:15];
   
    
    frame = CGRectMake(0, 42, DEVICERECT.size.width, 1);
    UIView* lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorWithHex:LINECOLOR];
    
    [headView addSubview:headLabel];
    [headView addSubview:lineView];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    NSDictionary* group = [self.titleInfoArr objectAtIndex:indexPath.section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    NSDictionary* fieldInfo = [groupCtx objectAtIndex:indexPath.row];
    
    NSString* placeholder = [fieldInfo objectForKey:@"placeholder"];
    
    if([[fieldInfo objectForKey:@"type"]  isEqual: @0] ||
       [[fieldInfo objectForKey:@"type"]  isEqual: @1]){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewClue1TableViewCell"
                                                    forIndexPath:indexPath];
        NewClue1TableViewCell* nctv = (NewClue1TableViewCell*)cell;
        nctv.lbName.text = [fieldInfo objectForKey:@"key"];
        
        NSMutableDictionary* valDict = [fieldInfo objectForKey:@"value"];
        nctv.lbValue.text = [valDict objectForKey:@"text"];
        nctv.lbValue.placeholder = placeholder;
        nctv.maxLength = -1;
        nctv.lbValue.keyboardType = UIKeyboardTypeDefault;
        nctv.lbValue.enabled = [[fieldInfo objectForKey:@"type"]  isEqual: @0];
        if([[fieldInfo objectForKey:@"field"] isEqualToString:@"mobile"]){
            nctv.lbValue.keyboardType = UIKeyboardTypePhonePad;
            nctv.maxLength = 11;
        }else if([[fieldInfo objectForKey:@"field"] isEqualToString:@"name"]){
            nctv.maxLength = 6;
        }
        nctv.valDict = valDict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewClue2TableViewCell"
                                                    forIndexPath:indexPath];
         NewClue2TableViewCell* nctv = (NewClue2TableViewCell*)cell;
        NSMutableDictionary* valDict = [fieldInfo objectForKey:@"value"];
        nctv.itemValue = valDict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    self.overlayPickerView.tag = indexPath.section * 100 + indexPath.row;
    NSDictionary* group = [self.titleInfoArr objectAtIndex:indexPath.section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    NSDictionary* fieldInfo = [groupCtx objectAtIndex:indexPath.row];
    NSString* fieldName = [fieldInfo objectForKey:@"field"];
    
    if([fieldName isEqualToString:@"plandata"]){
        [self loadPlanDataSource];
    }
    else if([fieldName isEqualToString:@"cars"]){
        [self loadCarsType];
    }
    else if([fieldName isEqualToString:@"models"]){
        NSDictionary* valueDict = [self getValueDictionary:@"base" andFieldName:@"cars"];
        NSString* val = [valueDict objectForKey:@"val"];
        if(val == nil || val.length == 0){
            [UIAlertView alert:@"请选择车系"];
            return;
        }
        [self loadCarModel:val];
    }
    else if([fieldName isEqualToString:@"source"]){
        NSMutableDictionary* valDict = [fieldInfo objectForKey:@"value"];
        [valDict setObject:@"1" forKey:@"layout"];
        [self loadCategory];
    }
    else if([fieldName isEqualToString:@"level"]){
        [self loadClueLevelSource];
    }
    else if([fieldName isEqualToString:@"province"]){
        [self loadProvice];
    }
    else if([fieldName isEqualToString:@"city"]){
        NSDictionary* valueDict = [self getValueDictionary:@"address" andFieldName:@"province"];
        NSString* val = [valueDict objectForKey:@"val"];
        if(val == nil || val.length == 0){
            [UIAlertView alert:@"请选择省份"];
            return;
        }
        [self loadCity:val];
    }
}
#pragma UIPopPickerViewdelegate for datasource
-(NSString*)UIPopPickerView:(NSArray *)dataSource titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id item = [dataSource objectAtIndex:row];
    if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*) item;
        return [NSString stringWithFormat:@"%@   %@", val.keycode, val.ramark];
    }
    else if([item isKindOfClass:[KeyValue class]]){
        KeyValue* val = (KeyValue*) item;
        return val.name;
    }
    else if([item isKindOfClass:[ChannelInfo class]]){
        ChannelInfo* val = (ChannelInfo*) item;
        return val.name;

    }
    
    return nil;
}
#pragma UIPopPickerViewdelegate
-(void)UIPopPickerView:(UIPopPickerView *)pickerView andSelectedItem:(id)item{
    NSLog(@"%@",item);
    NSInteger section = pickerView.tag / 100;
    NSInteger row = pickerView.tag % 100;
    if(section < 0 && section >= self.titleInfoArr.count) return;
    NSDictionary* group = [self.titleInfoArr objectAtIndex:section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    if(row < 0 && row >= groupCtx.count) return;
    NSDictionary* fieldInfo = [groupCtx objectAtIndex:row];
    NSMutableDictionary* valDict = [fieldInfo objectForKey:@"value"];
    if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*) item;
        [valDict setObject:val.keycode forKey:@"text"];
        [valDict setObject:val.identity forKey:@"val"];
    }
    else if([item isKindOfClass:[KeyValue class]]){
        KeyValue* val = (KeyValue*) item;
        if([[fieldInfo objectForKey:@"field"] isEqualToString:@"province"]){
            NSMutableDictionary* cityDict =
            (NSMutableDictionary*)[self getFieldInfoDictionary:@"address" andFieldName:@"city"];
            [cityDict setObject:@"" forKey:@"text"];
            [cityDict setObject:@"" forKey:@"val"];   
        }
        if([[fieldInfo objectForKey:@"field"] isEqualToString:@"cars"]){
            NSMutableDictionary* modelsDict =
            (NSMutableDictionary*)[self getFieldInfoDictionary:@"base" andFieldName:@"models"];
            [modelsDict setObject:@"" forKey:@"text"];
            [modelsDict setObject:@"" forKey:@"val"];
        }
        [valDict setObject:val.name forKey:@"text"];
        [valDict setObject:val.identity forKey:@"val"];

    }
    // 线索来源选择
    else if([item isKindOfClass:[ChannelInfo class]]){
        ChannelInfo* val = (ChannelInfo*) item;
        NSString* layout = [valDict objectForKey:@"layout"];
        if(layout == nil || [layout isEqualToString:@"1"]){
            [valDict setObject:val.name forKey:@"tmpText"];
            [valDict setObject:val.channelID forKey:@"tmpval"];
//            [self loadSubCategory:val];
            [self performSelector:@selector(loadSubCategory:)
                       withObject:val
                       afterDelay:0];
            [valDict setObject:@"2" forKey:@"layout"];
            
        }
        else if([layout isEqualToString:@"2"]){
            NSString* str = [NSString stringWithFormat:@"%@-%@",
                             [valDict objectForKey:@"tmpText"], val.name];
            [valDict setObject:str forKey:@"tmpText"];
            
            NSString* tmpVal = [NSString stringWithFormat:@"%@,%@",
                                [valDict objectForKey:@"tmpval"], val.channelID];
            [valDict setObject:tmpVal forKey:@"tmpval"];
            
            [valDict setObject:@"3" forKey:@"layout"];
            [self performSelector:@selector(loadThirdCategory:)
                       withObject:val
                       afterDelay:0];
        }
        else if([layout isEqualToString:@"3"]){
            NSString* str = [NSString stringWithFormat:@"%@-%@",
                             [valDict objectForKey:@"tmpText"], val.name];
            [valDict setObject:str forKey:@"text"];
            
            NSString* tmpVal = [NSString stringWithFormat:@"%@,%@",
                                [valDict objectForKey:@"tmpval"], val.channelID];
            
            [valDict setObject:tmpVal forKey:@"val"];
            
            [valDict setObject:@"1" forKey:@"layout"];
        }
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 根据分类和字段名称获取字段值字典
-(NSMutableDictionary*) getValueDictionary:(NSString*) category
                              andFieldName:(NSString*) fieldName{
    
    NSDictionary* group = nil;
    for(NSInteger idx = 0; idx < self.titleInfoArr.count; idx++){
        NSDictionary* tmp = [self.titleInfoArr objectAtIndex:idx];
        NSString* tmpCat = [tmp objectForKey:@"category"];
        if([tmpCat isEqualToString:category]){
            group = tmp;
            break;
        }
    }
    NSDictionary* fieldInfo = nil;
    NSArray* groupCtx = [group objectForKey:@"val"];
    for(NSInteger idx = 0; idx < groupCtx.count; idx++){
        NSDictionary* tmp = [groupCtx objectAtIndex:idx];
        NSString* tmpFieldName = [tmp objectForKey:@"field"];
        if(tmpFieldName != nil && [tmpFieldName isEqualToString:fieldName]){
            fieldInfo = tmp;
        }
    }
    NSMutableDictionary* value = [fieldInfo objectForKey:@"value"];
    return value;
    
}
// 根据tableview的行信息获取字段字典
-(NSDictionary*) getFieldInfoDictionaryByIndexPath:(NSIndexPath*)indexPath{
    
    NSDictionary* group = [self.titleInfoArr objectAtIndex:indexPath.section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    NSDictionary* fieldInfo = [groupCtx objectAtIndex:indexPath.row];
    return fieldInfo;
}
// 根据tableview的行信息获取字段值字典
-(NSDictionary*) getValueDictionaryByIndexPath:(NSIndexPath*)indexPath{
    
    NSDictionary* group = [self.titleInfoArr objectAtIndex:indexPath.section];
    NSArray* groupCtx = [group objectForKey:@"val"];
    NSDictionary* fieldInfo = [groupCtx objectAtIndex:indexPath.row];
    return [fieldInfo objectForKey:@"value"];
}
// 根据分类和字段名称获取字段字典
-(NSMutableDictionary*) getFieldInfoDictionary:(NSString*) category
                              andFieldName:(NSString*) fieldName{
    
    NSDictionary* group = nil;
    for(NSInteger idx = 0; idx < self.titleInfoArr.count; idx++){
        NSDictionary* tmp = [self.titleInfoArr objectAtIndex:idx];
        NSString* tmpCat = [tmp objectForKey:@"category"];
        if([tmpCat isEqualToString:category]){
            group = tmp;
            break;
        }
    }
    NSDictionary* fieldInfo = nil;
    NSArray* groupCtx = [group objectForKey:@"val"];
    for(NSInteger idx = 0; idx < groupCtx.count; idx++){
        NSDictionary* tmp = [groupCtx objectAtIndex:idx];
        NSString* tmpFieldName = [tmp objectForKey:@"field"];
        if(tmpFieldName != nil && [tmpFieldName isEqualToString:fieldName]){
            fieldInfo = tmp;
        }
    }
    return [fieldInfo objectForKey:@"value"];
    
}
-(IBAction)btnSave:(id)sender{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    for(NSInteger idx = 0; idx < self.titleInfoArr.count; idx++){
        NSDictionary*group = [self.titleInfoArr objectAtIndex:idx];
        NSArray* groupCtx = [group objectForKey:@"val"];
        for(NSInteger ydx = 0; ydx < groupCtx.count; ydx++){
            NSDictionary* fileInfo = [groupCtx objectAtIndex:ydx];
            NSDictionary* valDict = [fileInfo objectForKey:@"value"];
            NSString* val = [valDict objectForKey:@"val"];
            
            if(val == nil || val.length == 0){
                NSString* tip = nil;
                if([[fileInfo objectForKey:@"type"] isEqual:@0]){
                    tip = [NSString stringWithFormat:@"请输入%@",
                           [fileInfo objectForKey:@"key"]];
                }
                else{
                    tip = [NSString stringWithFormat:@"请选择%@",
                           [fileInfo objectForKey:@"key"]];
                }
                [UIAlertView alert:tip];
                return;
            }
            [parameters setValue:val forKey:[fileInfo objectForKey:@"field"]];
        }
    }
    ClueService* service = [[ClueService alloc] init];
    [service saveClue:parameters andCompleteBlock:^(id obj, NSError *err) {
        if(err == nil){
            [UIAlertView alert:@"提交成功"];
            [AppDelegate setRefresh];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];

}

#pragma load selected data
// 计划购车时间
-(void)loadPlanDataSource{
    if(self.plandataDataSource != nil){
        self.overlayPickerView.dataSource = self.plandataDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"5" andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.plandataDataSource = obj;
            self.overlayPickerView.dataSource = self.plandataDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取车系
-(void)loadCarsType{
    if(self.carsDataSource != nil){
        self.overlayPickerView.dataSource = self.carsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarTypeList:@"0" andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.carsDataSource = obj;
            self.overlayPickerView.dataSource = self.carsDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取车型
-(void)loadCarModel:(NSString*) subType{
    if(self.modelsDataSource != nil){
        self.overlayPickerView.dataSource = self.modelsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarModelList:@"0" andType:subType andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.modelsDataSource = obj;
            self.overlayPickerView.dataSource = self.modelsDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
    
}
// 获取Channel第一级别表单
-(void) loadCategory{
    if(self.source1DataSource != nil){
        self.overlayPickerView.dataSource = self.source1DataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getChannelCategory:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.source1DataSource = obj;
            self.overlayPickerView.dataSource = self.source1DataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取Channel第二级别表单
-(void) loadSubCategory:(ChannelInfo*) cid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getChannelSubCategory:cid.channelID andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.source2DataSource = obj;
            self.overlayPickerView.dataSource = self.source2DataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
            
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取Channel第三级别表单
-(void)loadThirdCategory:(ChannelInfo*) pid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getChannelThirdCategory:pid.channelID andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.source3DataSource = obj;
            self.overlayPickerView.dataSource = self.source3DataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
            
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}

// 计划购车时间
-(void)loadClueLevelSource{
    if(self.levelDataSource != nil){
        self.overlayPickerView.dataSource = self.levelDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"2" andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.levelDataSource = obj;
            self.overlayPickerView.dataSource = self.levelDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}

// 获取省份信息
-(void)loadProvice{
    if(self.provinceDataSource != nil){
        self.overlayPickerView.dataSource = self.provinceDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getProviceList:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.provinceDataSource = obj;
            self.overlayPickerView.dataSource = self.provinceDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
// 获取城市信息
-(void)loadCity:(NSString*)provice{
    if(self.cityDataSource != nil){
        self.overlayPickerView.dataSource = self.cityDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCityList:provice andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            self.cityDataSource = obj;
            self.overlayPickerView.dataSource = self.cityDataSource;
            [self.overlayPickerView reload];
            [self.overlayPickerView show];

        }
        else{
            self.provinceDataSource = nil;
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}

@end
