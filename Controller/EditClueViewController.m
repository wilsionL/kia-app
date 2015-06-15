//
//  EditClueViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/3.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "EditClueViewController.h"
#import "NewClue1TableViewCell.h"
#import "EditClue3TableViewCell.h"
#import "EditClue2TableViewCell.h"
#import "EditClueTableViewCell.h"
#import "BaseDataService.h"
#import "BaseDataIitem.h"
#import "UIColor+HexColor.h"
#import "MBProgressHUD.h"
#import "UIPopPickerView.h"
#import "UIPopDateTimePickerView.h"
#import "UIAlertView+Show.h"
#import "ClueService.h"
#import "NSString+util.h"

#define REMARK_TAG   3000

@interface EditClueViewController ()<UITableViewDataSource, UITableViewDelegate,
UIPopPickerViewDelegate, UIPopDateTimePickerViewDelegate,
EditClueTableViewCellDelegate, EditClue2TableViewCellDelegate,EditClue3TableViewCellDelegate, NewClue1TableViewCellDelegate>
@property (nonatomic, strong) NSArray* layoutDataSource1;
@property (nonatomic, strong) NSArray* layoutDataSource2;
@property (nonatomic, strong) NSArray* layoutDataSource3;
@property (nonatomic, strong) NSArray* layoutDataSource4;
@property (nonatomic, strong) NSArray* layoutDataSource5;
@property (nonatomic, strong) NSArray* layoutDataSource6;
@property (nonatomic, strong) NSArray* layoutDataSource7;
@property (nonatomic, weak) NSArray* displayDataSource;
@property (nonatomic, strong) NSArray* resultDataSource;
@property (nonatomic, strong) NSArray* levelDataSource;
@property (nonatomic, strong) NSArray* carsDataSource;
@property (nonatomic, strong) NSArray* failureDataSource;
@property (nonatomic, strong) NSArray* competeBrandsDataSource;
@property (nonatomic, strong) NSArray* competeModelsDataSource;
@property (nonatomic, strong) NSArray* competeMcarsDataSource;
@property (nonatomic, strong) NSArray* modelsDataSource;
@property (nonatomic, strong) NSArray* invalidDataSource;
@property (nonatomic, strong) UIPopPickerView* overlayPickerView;
@property (nonatomic, strong) NSMutableDictionary* parameters;
@property (nonatomic, strong) BaseDataItem* curLevel;
@property (nonatomic, strong) BaseDataItem* FOLevel;
@property (nonatomic, strong) BaseDataItem* OLevel;
@property (nonatomic, strong) BaseDataItem* FLevel;
@property (nonatomic, strong) UIPopDateTimePickerView* overlayDateTimePicker;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation EditClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.resultDataSource =
    @[
      @"安排回访",
      @"安排到店",
      @"安排交车",
      @"客户战败",
      @"作废"
      ];
    self.parameters = [[NSMutableDictionary alloc] init];
    [self buildLayout];
    
    self.overlayPickerView = [[UIPopPickerView alloc] initWithParent:self.view];
    self.overlayPickerView.delegate = self;
    
    self.overlayDateTimePicker = [[UIPopDateTimePickerView alloc] initWithParent:self.view];
    self.overlayDateTimePicker.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewClue1TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"NewClue1TableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditClueTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"EditClueTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditClue2TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"EditClue2TableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditClue3TableViewCell" bundle:nil]
         forCellReuseIdentifier:@"EditClue3TableViewCell"];
    self.displayDataSource = self.layoutDataSource1;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.parameters setObject:@{@"text":self.cLevel, @"value":self.cLevel}
                        forKey:@"level"];
    [self.parameters setObject:@{@"text":@"1", @"value":@"1"}
                        forKey:@"iscome"];
    [self initClueLevelData:self.cLevel];
    [self.tableView reloadData];
    
    
    //    self.navigationItem.rightBarButtonItem =
    //    [[UIBarButtonItem alloc] initWithTitle:@"保存"
    //                                     style:UIBarButtonItemStyleDone
    //                                    target:self
    //                                    action:@selector(btnSaveEvent:)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.tableView.frame = CGRectMake(0, 0, 320, 100);
    [self setNavigationView:[UIColor colorWithHex:0xbb162bff]];
    [self setBackButton];
    
    [self setNavigationTitle:@"跟进结果录入"];
    
    CGRect frame = CGRectMake(0, 0, 47, 23);
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict = [self.displayDataSource objectAtIndexedSubscript:indexPath.row];
    if([[dict objectForKey:@"type"] isEqual:@5]){
        return 100;
    }
    return 44.;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    NSDictionary* dict = [self.displayDataSource objectAtIndex:indexPath.row];
    NSDictionary* valueDict = [self.parameters objectForKey:[dict objectForKey:@"field"]];
    if([[dict objectForKey:@"type"] isEqual:@3]){
        cell =
        (EditClueTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"EditClueTableViewCell"
                                                                     forIndexPath:indexPath];
        
        
        EditClueTableViewCell* ectvc = (EditClueTableViewCell*)cell;
        ectvc.iscome = [valueDict objectForKey:@"value"];
        ectvc.delegate = self;
        
    }
    else if([[dict objectForKey:@"type"] isEqual:@5]){
        cell =
        (EditClue2TableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"EditClue2TableViewCell"
                                                                      forIndexPath:indexPath];
        EditClue2TableViewCell* cell2 = (EditClue2TableViewCell*)cell;
        cell2.txtView.text = [valueDict objectForKey:@"value"];
        cell2.delegate = self;
    } else if([[dict objectForKey:@"type"] isEqual:@6]){
        cell =
        (EditClue3TableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"EditClue3TableViewCell"
                                                                      forIndexPath:indexPath];
        EditClue3TableViewCell* cell3 = (EditClue3TableViewCell*)cell;
        NSLog(@"%@",[dict objectForKey:@"title"]);
        cell3.nameText.text = [dict objectForKey:@"title"];
        cell3.delegate = self;
    }
    else{
        cell = (NewClue1TableViewCell*)
        [self.tableView dequeueReusableCellWithIdentifier:@"NewClue1TableViewCell"
                                             forIndexPath:indexPath];
        
        NewClue1TableViewCell* nctvc = (NewClue1TableViewCell*)cell;
        nctvc.delegate = self;
        
        if([dict objectForKey:@"edit"] != nil && [[dict objectForKey:@"edit"] isEqual:@1]){
            nctvc.lbValue.enabled = YES;
        }
        else{
            nctvc.lbValue.enabled = NO;
        }
        if([[dict objectForKey:@"field"] isEqualToString:@"carprice"]){
            nctvc.lbValue.keyboardType = UIKeyboardTypeDecimalPad;
        }
        
        NSDictionary* dict = [self.displayDataSource objectAtIndex:indexPath.row];
        nctvc.fieldName = [dict objectForKey:@"field"];
        //        NSMutableDictionary* val = [dict objectForKey:@"value"];
        nctvc.lbName.text = [dict objectForKey:@"title"];
        NSDictionary* valueDict = [self.parameters objectForKey:[dict objectForKey:@"field"]];
        nctvc.lbValue.text = [valueDict objectForKey:@"text"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    cell.lbValue.text = [val objectForKey:@"text"];
    //    cell.valDict = val;
    //    [cell.lbValue resignFirstResponder];
    //    if([[dict objectForKey:@"isEdit"] isEqual: @1]){
    //        cell.lbValue.enabled = YES;
    //    }
    //    else{
    //        cell.lbValue.enabled = NO;
    //    }
    //
    //    cell.lbValue.placeholder = [dict  objectForKey:@"placeholder"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil from:nil forEvent:nil];
    
    NSDictionary* dict = [self.displayDataSource objectAtIndex:indexPath.row];
    NSString* field = [dict objectForKey:@"field"];
    if([field isEqualToString:@"result"]){
        [self loadClueResult:indexPath.row];
    }
    else if([field isEqualToString:@"level"]){
        if(self.displayDataSource != self.layoutDataSource4
           && self.displayDataSource != self.layoutDataSource5
           && self.displayDataSource != self.layoutDataSource6){
            [self loadClueLevel:indexPath.row];
        }
    }
    else if([field isEqualToString:@"backdate"] || [field isEqualToString:@"reservedate"]){
        self.overlayDateTimePicker.tag = indexPath.row;
        [self.overlayDateTimePicker show];
    }
    else if([field isEqualToString:@"cars"]){
        self.overlayPickerView.tag = indexPath.row;
        //        NSDictionary* modelsItem = [self.parameters objectForKey:@"models"];
        //        [modelsItem setValue:[[NSMutableDictionary alloc] init] forKey:@"value"];
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"models"];
        [self loadCarsType:@"0" andBrand:@""];
        
    }
    
    else if([field isEqualToString:@"models"]){
        self.overlayPickerView.tag = indexPath.row;
        NSDictionary* carItem = [self.parameters objectForKey:@"cars"];
        if(carItem != nil && [carItem isKindOfClass:[NSDictionary class]]){
            [self loadCarModel:@"0" andSubType:[carItem objectForKey:@"value"]];
        }
        else{
            [UIAlertView alert:@"请选择车系"];
        }
    }
    else if([field isEqualToString:@"competebrand"]){
        self.overlayPickerView.tag = indexPath.row;
        [self loadBrandListType:@"1"];
    }
    else if([field isEqualToString:@"competecars"]){
        NSDictionary* brandItem = [self.parameters objectForKey:@"competebrand"];
        self.overlayPickerView.tag = indexPath.row;
        if(brandItem != nil && [brandItem isKindOfClass:[NSDictionary class]]){
            [self loadCarsType:@"1" andBrand:[brandItem objectForKey:@"value"]];
        }
        else{
            [UIAlertView alert:@"请选择竞争品牌"];
        }
    }
    else if([field isEqualToString:@"competemodels"]){
        self.overlayPickerView.tag = indexPath.row;
        NSDictionary* carItem = [self.parameters objectForKey:@"competecars"];
        if(carItem != nil && [carItem isKindOfClass:[NSDictionary class]]){
            [self loadCarModel:@"1" andSubType:[carItem objectForKey:@"value"]];
        }
        else{
            [UIAlertView alert:@"请选择竞争车系"];
        }
    }
    else if([field isEqualToString:@"defeatreason"]){
        [self loadFailureType:indexPath.row];
    }
    else if([field isEqualToString:@"invalidreason"]){
        [self loadInvalidType:indexPath.row];
    }
    
}
#pragma UIPopPickerViewdelegate for datasource
-(NSString*)UIPopPickerView:(NSArray *)dataSource titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    id item = [dataSource objectAtIndex:row];
    if([item isKindOfClass:[NSString class]]){
        return [dataSource objectAtIndex:row];
    }
    else if([item isKindOfClass:[KeyValue class]]){
        KeyValue* val = (KeyValue*)[dataSource objectAtIndex:row];
        return val.name;
    }
    
    else if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*)[dataSource objectAtIndex:row];
        return [NSString stringWithFormat:@"%@ %@", val.keycode, val.ramark];
    }
    return nil;
}
#pragma UIPopPickerViewdelegate
-(void)UIPopPickerView:(UIPopPickerView *)pickerView andSelectedItem:(id)item{
    NSLog(@"%@",item);
    NSInteger row = pickerView.tag;
    if(row < 0 || row >= self.displayDataSource.count) return;
    NSString* text = nil;
    NSString* value = nil;
    NSDictionary* fieldDict = [self.displayDataSource objectAtIndex:row];
    NSString* fieldName = [fieldDict objectForKey:@"field"];
    if([item isKindOfClass:[NSString class]]){
        text = item;
        value = item;
    }
    else if([item isKindOfClass:[BaseDataItem class]]){
        BaseDataItem* val = (BaseDataItem*)item;
        text = [NSString stringWithFormat:@"%@ %@", val.keycode, val.ramark];
        value = val.identity;
    }
    else if([item isKindOfClass:[KeyValue class]]){
        KeyValue* kv = (KeyValue*)item;
        text= kv.name;
        value = kv.identity;
    }
    if(text != nil && value != nil){
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:fieldName];
    }
    NSLog(@"fieldName:%@,text:%@,value:%@",fieldName,text,value);
    if([value isEqualToString:@"安排回访"]){
        self.displayDataSource = self.layoutDataSource2;
        text = [NSString stringWithFormat:@"%@ %@", self.curLevel.keycode,
                self.curLevel.ramark];
        value = self.curLevel.identity;
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:@"level"];
    }
    else  if([value isEqualToString:@"安排到店"]){
        self.displayDataSource = self.layoutDataSource3;
        text = [NSString stringWithFormat:@"%@ %@", self.curLevel.keycode,
                self.curLevel.ramark];
        value = self.curLevel.identity;
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:@"level"];
    }
    else  if([value isEqualToString:@"安排交车"]){
        self.displayDataSource = self.layoutDataSource4;
        text = [NSString stringWithFormat:@"%@ %@", self.OLevel.keycode,
                self.OLevel.ramark];
        value = self.OLevel.identity;
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:@"level"];
        [self.parameters setObject:@{
                                     @"text":self.carseriesname,
                                     @"value":self.carseriesid
                                     }
                            forKey:@"cars"];
        [self.parameters setObject:@{
                                     @"text":self.carmodelname,
                                     @"value":self.carmodelid
                                     }
                            forKey:@"models"];
    }
    else  if([value isEqualToString:@"客户战败"]){
        self.displayDataSource = self.layoutDataSource5;
        text = [NSString stringWithFormat:@"%@ %@", self.FOLevel.keycode,
                self.FOLevel.ramark];
        value = self.FOLevel.identity;
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:@"level"];
        
    }
    else  if([value isEqualToString:@"作废"]){
        self.displayDataSource = self.layoutDataSource6;
        text = [NSString stringWithFormat:@"%@ %@", self.curLevel.keycode,
                self.curLevel.ramark];
        value = self.curLevel.identity;
        [self.parameters setObject:@{
                                     @"text":text,
                                     @"value":value
                                     }
                            forKey:@"level"];
    }
    else if([fieldName isEqualToString:@"defeatreason"] &&
            [value isEqualToString:@"A871303AEB03410BAB2DF047D158945A"]){
        self.displayDataSource = self.layoutDataSource7;
    }
    else if([fieldName isEqualToString:@"competebrand"]){
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"competecars"];
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"competemodels"];
        self.displayDataSource = self.layoutDataSource7;
    }
    else if([fieldName isEqualToString:@"competecars"]){
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"competemodels"];
        self.displayDataSource = self.layoutDataSource7;
    }
    else if([fieldName isEqualToString:@"defeatreason"] &&
            ![value isEqualToString:@"A871303AEB03410BAB2DF047D158945A"]){
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"competecars"];
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"competemodels"];
        
        [self.parameters setObject:@{
                                     @"text":@"",
                                     @"value":@""
                                     }
                            forKey:@"carprice"];
        
        
        self.displayDataSource = self.layoutDataSource5;
    }
    
    [self.tableView reloadData];
}
#pragma UIPopDateTimePickerViewDelegate
-(void)UIPopDateTimePickerView:(UIPopDateTimePickerView *)pickerView andSelectedDate:(NSDate *)date andTime:(NSDate *)time{
    NSInteger row = pickerView.tag;
    if(row < 0 || row >= self.displayDataSource.count) return;
    NSDictionary* fieldDict = [self.displayDataSource objectAtIndex:row];
    NSString* fieldName = [fieldDict objectForKey:@"field"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger unitFlags1 = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps1 = [calendar components:unitFlags1 fromDate:time];
    
    NSString* strdatetime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00",
                             comps.year, comps.month, comps.day,
                             comps1.hour, comps1.minute];
    // yyyy-MM-dd HH:mm:ss
    NSLog(@"%@,%@, %@",date, time, strdatetime);
    
    [self.parameters setObject:@{
                                 @"text":strdatetime,
                                 @"value":strdatetime
                                 }
                        forKey:fieldName];
    [self.tableView reloadData];
}
#pragma EditClueTableViewCellDelegate
-(void)SetComeState:(EditClueTableViewCell *)cell andState:(NSString *)state{
    [self.parameters setObject:@{
                                 @"text":state,
                                 @"value":state
                                 }
                        forKey:@"iscome"];
    [self.tableView reloadData];
}

#pragma EditClue2TableViewCellDelegate
-(void)changeTextView:(EditClue2TableViewCell *)cell andText:(NSString *)val{
    [self.parameters setObject:@{
                                 @"text":val,
                                 @"value":val
                                 }
                        forKey:@"remark"];
    
}

#pragma EditClue3TableViewCellDelegate
-(void)changeTextView3:(EditClue3TableViewCell *)cell andText:(NSString *)val{
    [self.parameters setObject:@{
                                 @"text":val,
                                 @"value":val
                                 }
                        forKey:@"vin"];
    
}
#pragma NewClue1TableViewCellDelegate
-(void)valueChange:(NewClue1TableViewCell *)cell andFieldName:(NSString *)fieldName andNewValue:(NSString *)value{
    if(fieldName == nil || ![fieldName isEqualToString:@"carprice"]) return;
    [self.parameters setObject:@{
                                 @"text":value,
                                 @"value":value
                                 }
                        forKey:@"carprice"];
    
}
//-(void)valueChange:(NewClue1TableViewCell *)cell andNewValue:(NSString *)value{
//
//    [self.parameters setObject:@{
//                                 @"text":value,
//                                 @"value":value
//                                 }
//                        forKey:@"carprice"];
//}

#pragma btnSaveEvent
-(IBAction)btnSaveEvent:(id)sender{
    if(self.displayDataSource == self.layoutDataSource1){
        [UIAlertView alert:@"请选择处理结果"];
        return;
    }
    NSString* level = [self getParameterValue: @"level"];
    if(level == nil || level.length < 3){
        [UIAlertView alert:@"请选择线索等级"];
        return;
    }
    NSString* remark = [self getParameterValue: @"remark"];
    NSString* vin = [self getParameterValue: @"vin"];
    if(remark == nil) remark = @"";
    NSDictionary* postParams = nil;
    // 安排回访
    if(self.displayDataSource == self.layoutDataSource2){
        NSString* backdate =[self getParameterValue: @"backdate"] ;
        if(backdate == nil){
            [UIAlertView alert:@"请选择下次回访时间"];
            return;
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":@"",
          @"result":@"安排回访",
          @"level":level,
          @"backdate":backdate,
          @"reservedate":@"",
          @"cars":@"",
          @"models":@"",
          @"defeatreason":@"",
          @"competecars":@"",
          @"competemodels":@"",
          @"invalidreason":@"",
          @"carprice":@"",
          @"remark":remark,
          @"vin":@""
          };
    }
    // 安排在店
    else if(self.displayDataSource == self.layoutDataSource3){
        NSString* iscome =[self getParameterValue: @"iscome"] ;
        NSString* reservedate =[self getParameterValue: @"reservedate"] ;
        if(iscome == nil){
            [UIAlertView alert:@"请选择客户状态"];
            return;
        }
        if(reservedate == nil){
            [UIAlertView alert:@"请选择预约时间"];
            return;
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":iscome,
          @"result":@"安排到店",
          @"level":level,
          @"backdate":@"",
          @"reservedate":reservedate,
          @"cars":@"",
          @"models":@"",
          @"defeatreason":@"",
          @"competecars":@"",
          @"competemodels":@"",
          @"invalidreason":@"",
          @"carprice":@"",
          @"remark":remark,
          @"vin":@""
          };
    }
    // 安排交车
    else if(self.displayDataSource == self.layoutDataSource4){
        NSString* cars =[self getParameterValue: @"cars"] ;
        NSString* models =[self getParameterValue: @"models"] ;
        if(cars == nil){
            [UIAlertView alert:@"请选择成交车系"];
            return;
        }
        if(models == nil){
            [UIAlertView alert:@"请选择成交车型"];
            return;
        }
        if (vin.length!=17) {
            [UIAlertView alert:@"VIN长度必须为17位"];
            return;
        }else{
            NSString *regex = @"^[A-Za-z0-9]+$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([predicate evaluateWithObject:vin] == YES) {
                //implement
                NSLog(@"yes");
            }else {
                [UIAlertView alert:@"只允许输入英文和数字"];
                return;
            }
            
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":@"",
          @"result":@"安排交车",
          @"level":level,
          @"backdate":@"",
          @"reservedate":@"",
          @"cars":cars,
          @"models":models,
          @"defeatreason":@"",
          @"competecars":@"",
          @"competemodels":@"",
          @"invalidreason":@"",
          @"carprice":@"",
          @"remark":remark,
          @"vin":vin
          };
    }
    // 客户战败
    else if(self.displayDataSource == self.layoutDataSource5){
        NSString* defeatreason =[self getParameterValue: @"defeatreason"] ;
        if(defeatreason == nil){
            [UIAlertView alert:@"请选择战败原因"];
            return;
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":@"",
          @"result":@"客户战败",
          @"level":level,
          @"backdate":@"",
          @"reservedate":@"",
          @"cars":@"",
          @"models":@"",
          @"defeatreason":defeatreason,
          @"competecars":@"",
          @"competemodels":@"",
          @"invalidreason":@"",
          @"carprice":@"",
          @"remark":remark,
          @"vin":@""
          };
        
    }
    // 客户战败 已购竞争品牌
    else if(self.displayDataSource == self.layoutDataSource7){
        NSString* defeatreason =[self getParameterValue: @"defeatreason"] ;
        if(defeatreason == nil){
            [UIAlertView alert:@"请选择战败原因"];
            return;
        }
        NSString* competecars = @"";
        NSString* competemodels = @"";
        NSString* carprice = @"";
        if([defeatreason isEqualToString:@"A871303AEB03410BAB2DF047D158945A"]){
            competecars =[self getParameterValue: @"competecars"] ;
            if(competecars == nil || competecars.length == 0){
                [UIAlertView alert:@"请选择已购竞争品牌车系"];
                return;
            }
            competemodels =[self getParameterValue: @"competemodels"] ;
            if(competemodels == nil || competemodels.length == 0){
                [UIAlertView alert:@"请选择已购竞争品牌车型"];
                return;
            }
            carprice =[self getParameterValue: @"carprice"] ;
            if(carprice == nil || carprice.length == 0 || ![carprice isDecimal]){
                [UIAlertView alert:@"请输入竞争车价"];
                return;
            }
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":@"",
          @"result":@"客户战败",
          @"level":level,
          @"backdate":@"",
          @"reservedate":@"",
          @"cars":@"",
          @"models":@"",
          @"defeatreason":defeatreason,
          @"competecars":competecars,
          @"competemodels":competemodels,
          @"invalidreason":@"",
          @"carprice":carprice,
          @"remark":remark,
          @"vin":@""
          };
    }
    // 作废
    else if(self.displayDataSource == self.layoutDataSource6){
        NSString* invalidreason =[self getParameterValue: @"invalidreason"] ;
        if(invalidreason == nil){
            [UIAlertView alert:@"请选无效原因"];
            return;
        }
        postParams =
        @{
          @"id":self.cid,
          @"iscome":@"",
          @"result":@"作废",
          @"level":level,
          @"backdate":@"",
          @"reservedate":@"",
          @"cars":@"",
          @"models":@"",
          @"defeatreason":@"",
          @"competecars":@"",
          @"competemodels":@"",
          @"invalidreason":invalidreason,
          @"carprice":@"",
          @"remark":remark,
          @"vin":@""
          };
    }
    else{
        [UIAlertView alert:@"异常处理结果"];
        return;
    }
    NSLog(@"%@", postParams);
    ClueService* service = [[ClueService alloc] init];
    [service followup:postParams andCompleteBlock:^(id obj, NSError *err) {
        if(err == nil){
            [UIAlertView alert:@"保存成功"];
            [AppDelegate setRefresh];
            //            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
}
-(NSString*)getParameterValue:(NSString*)key{
    NSDictionary* dict =[self.parameters objectForKey:key];
    if(dict != nil && [dict objectForKey:@"value"] != nil){
        return [dict objectForKey:@"value"];
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取结果类型
-(void) loadClueResult:(NSInteger) tag{
    self.overlayPickerView.tag = tag;
    self.overlayPickerView.dataSource = self.resultDataSource;
    [self.overlayPickerView reload];
    [self.overlayPickerView show];
}
// 获取线索等级
-(void) initClueLevelData:(NSString*)curLevel{
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getAllBaseDataList:@"2" andCompleteBlock:^(id obj, NSError *err) {
        
        NSMutableArray* ds = [[NSMutableArray alloc] init];
        self.levelDataSource = obj;
        for(NSInteger idx = 0; idx < self.levelDataSource.count;
            idx++){
            BaseDataItem* item = [self.levelDataSource objectAtIndex:idx];
            NSString* strLevel = [NSString stringWithFormat:@"%@", item.keycode];
            
            if([strLevel isEqualToString:self.cLevel]){
                NSString* text =
                [NSString stringWithFormat:@"%@ %@", item.keycode, item.ramark];
                NSString* value = item.identity;
                self.curLevel = item;
                [self.parameters setObject:@{@"text":text, @"value":value}
                                    forKey:@"level"];
            }
            if([strLevel isEqualToString:@"F"]){
                self.FLevel = item;
            }else if([strLevel isEqualToString:@"FO"]){
                self.FOLevel = item;
            }
            else if([strLevel isEqualToString:@"O"]){
                self.OLevel = item;
            }
            else{
                [ds addObject:item];
            }
            //            if(![strLevel isEqualToString:@"F"] &&
            //               ![strLevel isEqualToString:@"FO"] &&
            //               ![strLevel isEqualToString:@"O"]){
            //                [ds addObject:item];
            //            }
        }
        self.levelDataSource = ds;
        [self.tableView reloadData];
        return ;
        
    }];
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
    
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"2" andCompleteBlock:^(id obj, NSError *err) {
        self.levelDataSource = obj;
        self.overlayPickerView.dataSource = self.levelDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }];
}
// 获取车系
-(void)loadBrandListType:(NSString*) isCompete{
    if(self.competeBrandsDataSource != nil){
        self.overlayPickerView.dataSource = self.competeBrandsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBrandList:isCompete
         andCompleteBlock:^(id obj, NSError *err) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if(err == nil){
                 self.competeBrandsDataSource = obj;
                 self.overlayPickerView.dataSource = self.competeBrandsDataSource;
                 [self.overlayPickerView reload];
                 [self.overlayPickerView show];
             }
             else{
                 [UIAlertView alert:err.localizedDescription];
             }
         }];
}
// 获取车系
-(void)loadCarsType:(NSString*)isCompete andBrand:(NSString*) brand{
    if(brand == nil) brand = @"";
    if(self.carsDataSource != nil && [isCompete isEqualToString:@"0"]){
        self.overlayPickerView.dataSource = self.carsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    else if(self.competeMcarsDataSource != nil && [isCompete isEqualToString:@"1"]){
        self.overlayPickerView.dataSource = self.competeMcarsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarTypeList:isCompete
                   andBrand:brand
           andCompleteBlock:^(id obj, NSError *err)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if(err == nil){
             if([isCompete isEqualToString:@"0"]){
                 self.carsDataSource = obj;
                 self.overlayPickerView.dataSource = self.carsDataSource;
             }else{
                 self.competeMcarsDataSource = obj;
                 self.overlayPickerView.dataSource = self.competeMcarsDataSource;
             }
             //            self.carsDataSource = obj;
             //            self.overlayPickerView.dataSource = self.carsDataSource;
             [self.overlayPickerView reload];
             [self.overlayPickerView show];
         }
         else{
             [UIAlertView alert:err.localizedDescription];
         }
     }];
}
// 获取车型
-(void)loadCarModel:(NSString*)isCompete andSubType:(NSString*) subType{
    if(self.modelsDataSource != nil && [isCompete isEqualToString:@"0"]){
        self.overlayPickerView.dataSource = self.modelsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    else if(self.competeModelsDataSource != nil && [isCompete isEqualToString:@"1"]){
        self.overlayPickerView.dataSource = self.competeModelsDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getCarModelList:isCompete andType:subType andCompleteBlock:^(id obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err == nil){
            if([isCompete isEqualToString:@"0"]){
                self.modelsDataSource = obj;
                self.overlayPickerView.dataSource = self.modelsDataSource;
            }else{
                self.competeModelsDataSource = obj;
                self.overlayPickerView.dataSource = self.competeModelsDataSource;
            }
            [self.overlayPickerView reload];
            [self.overlayPickerView show];
        }
        else{
            [UIAlertView alert:err.localizedDescription];
        }
    }];
    
}
// 获取战败原因
-(void) loadFailureType:(NSInteger) tag{
    self.overlayPickerView.tag = tag;
    if(self.failureDataSource != nil){
        self.overlayPickerView.dataSource = self.failureDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
        return;
    }
    
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"3" andCompleteBlock:^(id obj, NSError *err) {
        self.failureDataSource = obj;
        self.overlayPickerView.dataSource = self.failureDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
    }];
}
// 获取无效原因
-(void) loadInvalidType:(NSInteger) tag{
    self.overlayPickerView.tag = tag;
    if(self.invalidDataSource != nil){
        self.overlayPickerView.dataSource = self.invalidDataSource;
        [self.overlayPickerView reload];
        [self.overlayPickerView show];
        return;
    }
    
    BaseDataService* service = [[BaseDataService alloc] init];
    [service getBaseDataList:@"4" andCompleteBlock:^(id obj, NSError *err) {
        self.invalidDataSource = obj;
        self.overlayPickerView.dataSource = self.invalidDataSource;
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

-(void)buildLayout{
    self.layoutDataSource1 =
    @[
      @{
          @"title":@"处理结果",
          @"type":@0,
          @"field":@"result"
          },
      @{
          @"title":@"线索等级",
          @"type":@1,
          @"field":@"level"
          },
      @{
          @"title":@"点击进行备注",
          @"type":@5,
          @"field":@"remark"
          }
      ];
    self.layoutDataSource2 =
    @[
      @{
          @"title":@"处理结果",
          @"type":@0,
          @"field":@"result"
          },
      @{
          @"title":@"线索等级",
          @"type":@1,
          @"field":@"level"
          },
      @{
          @"title":@"下次回访时间",
          @"type":@1,
          @"field":@"backdate"
          },
      @{
          @"title":@"点击进行备注",
          @"type":@5,
          @"field":@"remark"
          }
      ];
    self.layoutDataSource3 =
    @[
      @{
          @"title":@"处理结果",
          @"type":@0,
          @"field":@"result"
          },
      @{
          @"title":@"客户状态",
          @"type":@3,
          @"field":@"iscome"
          },
      @{
          @"title":@"线索等级",
          @"type":@1,
          @"field":@"level"
          },
      
      @{
          @"title":@"预约时间",
          @"field":@"reservedate",
          
          @"type":@1
          },
      @{
          @"title":@"点击进行备注",
          @"field":@"remark",
          @"type":@5
          }
      ];
    self.layoutDataSource4=
    @[
      @{
          @"title":@"处理结果",
          @"field":@"result",
          @"type":@0
          },
      @{
          @"title":@"线索等级",
          @"field":@"level",
          @"type":@1
          },
      @{
          @"title":@"成交车系",
          
          @"field":@"cars",
          @"type":@1
          },
      
      @{
          @"title":@"成交车型",
          @"type":@1,
          @"field":@"models"
          },
      @{
          @"title":@"VIN",
          @"type":@6,
          @"field":@"vin"
          },
      @{
          @"title":@"点击进行备注",
          @"field":@"remark",
          @"type":@5
          }
      ];
    self.layoutDataSource5 =
    @[
      @{
          @"title":@"处理结果",
          @"field":@"result",
          @"type":@0
          },
      @{
          @"title":@"线索等级",
          @"field":@"level",
          @"type":@1
          },
      @{
          @"title":@"战败原因",
          @"field":@"defeatreason",
          @"type":@1
          },
      @{
          @"title":@"点击进行备注",
          @"field":@"remark",
          @"type":@5
          }
      ];
    self.layoutDataSource6 =
    @[
      @{
          @"title":@"处理结果",
          @"field":@"result",
          @"type":@0
          },
      @{
          @"title":@"线索等级",
          @"field":@"level",
          @"type":@1
          },
      @{
          @"title":@"无效原因",
          @"field":@"invalidreason",
          @"type":@1
          },
      @{
          @"title":@"点击进行备注",
          @"field":@"remark",
          @"type":@5
          }
      ];
    self.layoutDataSource7 =
    @[
      @{
          @"title":@"处理结果",
          @"field":@"result",
          @"type":@0
          },
      @{
          @"title":@"线索等级",
          @"field":@"level",
          @"type":@1
          },
      @{
          @"title":@"战败原因",
          @"field":@"defeatreason",
          @"type":@1
          },
      @{
          @"title":@"竞争品牌",
          @"field":@"competebrand",
          @"type":@1
          },
      @{
          @"title":@"竞争车系列",
          @"field":@"competecars",
          @"type":@1
          },
      @{
          @"title":@"竞争车型",
          @"field":@"competemodels",
          @"type":@1
          },
      @{
          @"title":@"车价",
          @"field":@"carprice",
          @"type":@1,
          @"edit":@1
          },
      @{
          @"title":@"点击进行备注",
          @"field":@"remark",
          @"type":@5
          }
      ];
}
@end
