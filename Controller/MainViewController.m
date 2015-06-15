//
//  MainViewController.m
//  kia-app
//
//  Created by jieyeh on 14/10/31.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "kia-app.pch"
#import "MainViewController.h"
#import "UserService.h"
#import "UserModel.h"
#import "M13Checkbox.h"
#import "JNKeychain.h"
#import "UIAlertView+Show.h"
#import "CustomerService.h"
#import "SummaryModel.h"
#import "MBProgressHUD.h"
#import "VBPieChart.h"
#import "UserModel.h"
#import "UIColor+HexColor.h"
#import "ClueViewController.h"
#import "NofollowClueViewController.h"
#import "AssignClueViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) SummaryModel* dataSource;
@property (nonatomic, weak) IBOutlet UIView* summaryView;
@property (nonatomic, weak) IBOutlet UILabel* lbSummaryRate;
@property (nonatomic, weak) IBOutlet UIView* contentView;
@property (nonatomic, strong) NSArray* contentManagerItemArray;
@property (nonatomic, strong) NSArray* contentCommonItemArray;
@property (nonatomic, strong) VBPieChart *chart;
@property (nonatomic, weak) IBOutlet UIButton* btnUpdate;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSDate* lastUpdatetime;
@property (nonatomic, weak) IBOutlet UILabel* lbToolTip;
@property (nonatomic, weak) IBOutlet UIView* vwToolTip;
@property (nonatomic, assign) Boolean isManager;
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) NSString* strToolTip;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *image = [UIImage imageNamed:@"setting"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recvnotification" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(recvnotification:) name:@"recvnotification" object:nil];
    
    self.contentManagerItemArray =
  @[
  @{
      @"title":@"当日待处理",
      @"backImg":@"biaoqin2",
      @"iconImg":@"status7",
      @"field":@"come"
    },
  @{
      @"title":@"线索查询",
      @"backImg":@"biaoqin4",
      @"iconImg":@"status2",
      @"field":@"cluecount"
      },
  @{
      @"title":@"未分配线索",
      @"backImg":@"biaoqin1",
      @"iconImg":@"status4",
      @"field":@"noassign"
      },
  @{
      @"title":@"未跟进线索",
      @"backImg":@"biaoqin3",
      @"iconImg":@"status8",
      @"field":@"nofollowup"
      },
  @{
      @"title":@"超时未跟进线索",
      @"backImg":@"biaoqin5",
      @"iconImg":@"status3",
      @"field":@"timeout"
      },
  @{
      @"title":@"战败待审核",
      @"backImg":@"biaoqin3",
      @"iconImg":@"status5",
      @"field":@"audit"
      }
  ];
    self.contentCommonItemArray =
    @[
      @{
          @"title":@"当日待处理",
          @"backImg":@"biaoqin2",
          @"iconImg":@"status7",
          @"field":@"come"
          },
      @{
          @"title":@"线索查询",
          @"backImg":@"biaoqin4",
          @"iconImg":@"status2",
          @"field":@"cluecount"
          },
      @{
          @"title":@"未跟进线索",
          @"backImg":@"biaoqin5",
          @"iconImg":@"status8",
          @"field":@"nofollowup"
          },
      @{
          @"title":@"超时线索跟进提醒",
          @"backImg":@"biaoqin3",
          @"iconImg":@"status9",
          @"field":@"timeoutremind"
          },
      ];
   UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    
    if([user.role isEqual:@"manager"]){
         self.isManager = YES;
        [self displaySummary:self.contentManagerItemArray];
       
    }
    else{
        self.isManager = NO;
        [self displaySummary:self.contentCommonItemArray];
    }
    [self.btnUpdate setTitle:@"正在更新..." forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    [self drawPieChart];
    [self loadData];
//    if(needRefresh)
   
}
-(void)recvnotification:(NSNotification*)notifaciton{
    id obj = [notifaciton object];
    if([obj isKindOfClass:[NSDictionary class]]){
       NSDictionary* aps = [obj objectForKey:@"aps"];
        if([aps isKindOfClass:[NSDictionary class]]
           && [[aps objectForKey:@"alert"] isKindOfClass:[NSString class]]){
            self.strToolTip = [aps objectForKey:@"alert"];
        }
    }
    //[UIAlertView alert:self.strToolTip];
//    NSString* tmp = [NSString stringWithFormat:@"%@,%@", notifaciton, obj == nil ? @"" : obj];
  //  [UIAlertView alert:tmp];
   // NSLog(@"%@", obj);
   // if(obj != nil && [obj isKindOfClass:[NSString class]]){
   //     self.strToolTip = obj;
   // }
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationView: nil];
//    [self setLogoView];
//    [self setAddButtonView];
    
    CGRect frame = CGRectMake(0, 0, 29, 29);
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"setting"]
                          forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(settingBarButtonEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self buildLeftView:leftButton];
    
    frame = CGRectMake(0, 0, 62, 30);
    UIImageView* logoView = [[UIImageView alloc] initWithFrame:frame];
    [logoView setImage:[UIImage imageNamed:@"logo"]];
    [self buildCenterView:logoView];
    
    
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    if(![user.role isEqual:@"manager"]){
        frame = CGRectMake(0, 0, 35, 35);
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = frame;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"home_add"]
                               forState:UIControlStateNormal];
        
        [rightButton addTarget:self
                        action:@selector(btnNewClueEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self buildRightView:rightButton];
    }
    if([AppDelegate isNeedRefresh]){
        [AppDelegate resetRefreshState];
        [self loadData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.titleView removeFromSuperview];
}
//-(void) viewWillDisappear:(BOOL)animated{
//    [self.chart removeFromSuperview];
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [super viewWillDisappear:animated];
//    
//    [self.timer invalidate];
//    self.timer = nil;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnUpdateEvent:(id)sender{
    [self loadData];
}
-(IBAction)btnCloseToolTip:(id)sender{
    self.vwToolTip.hidden = YES;
}
-(void)timerFired:(NSTimer *)timer{
//    done =YES;
    if(self.lastUpdatetime == nil) return;
    NSTimeInterval  timeInterval = [self.lastUpdatetime timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result = nil;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚更新"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前更新",temp];
    }
    [self.btnUpdate setTitle:result forState:UIControlStateNormal];
    
}
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CustomerService* service = [[CustomerService alloc] init];
    [service Summary:^(SummaryModel* model, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(err != nil){
            [UIAlertView alert:err.localizedDescription];
        }
        else{
            NSInteger total = model.come.integerValue + model.back.integerValue;
            model.come = [NSNumber numberWithInteger:total];
            self.dataSource = model;
            [self fillSummary:model];
            [self fillPieChart:model.nofollowup andinfollowup:model.infollowup];
            [self.btnUpdate setTitle:@"刚刚更新" forState:UIControlStateNormal];
            self.lastUpdatetime = [NSDate date];
        }
    }];
}
-(void)fillPieChart:(NSNumber*) nof andinfollowup:(NSNumber*) inf{
    //    frame = CGRectMake(frame.size.width / 2 - chartWidth / 2, 8,chartWidth, chartWidth);
    NSInteger finishRate = 0;
    if(nof.integerValue + inf.integerValue > 0){
        finishRate = round(inf.floatValue * 100 / (inf.floatValue + nof.floatValue));
    }
    if(nof.integerValue == 0 && inf.integerValue == 0) {
        nof = @1;
        inf = @0;
    }
    self.lbSummaryRate.text = [NSString stringWithFormat:@"%ld", finishRate];
    self.chart.startAngle = 0;
    NSArray *chartValues =@[
                            @{@"name":@"first",
                              @"value":inf,
                              @"color":[UIColor colorWithHex:0x73B216aa]},
                            @{@"name":@"second",
                              @"value":nof,
                              @"color":[UIColor colorWithHex:0xffcc67aa]}
                            ];
//    [self.chart setChartValues:@[@"adfa", @"abbb"]];
    
    [self.chart setChartValues:chartValues animation:YES];

}
-(void)drawPieChart{
    self.chart = [[VBPieChart alloc] init];
    
    [self.summaryView addSubview:self.chart];
//    float chartWidth = 152;
    CGRect frame = self.summaryView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [self.chart setHoleRadiusPrecent:0.7]; /* hole inside of chart */
    [self.chart setFrame:frame];
//    self.chart.startAngle = 270./360;
//    self.chart.showLabels = YES;
     [self.chart setEnableStrokeColor:YES];
    [self fillPieChart:@1 andinfollowup:@0];
    
}
-(void)fillSummary:(SummaryModel*) model{
    if(self.strToolTip != nil && self.strToolTip.length > 0){
        self.lbToolTip.text = self.strToolTip;
        self.strToolTip = nil;
        self.vwToolTip.hidden = NO;
    }
    else{
        self.vwToolTip.hidden = YES;
    }
    NSArray* arr = nil;
    UserModel* user = [JNKeychain loadValueForKey:LOGIN_INFO_KEY];
    if([user.role isEqual:@"manager"]){
        arr = self.contentManagerItemArray;
        
        //if(model.noassign.integerValue > 0){
        //    self.lbToolTip.text = [NSString stringWithFormat:@"你有%ld条未分配线索", model.noassign.integerValue];
        //    self.vwToolTip.hidden = NO;
        //    [self.view bringSubviewToFront:self.vwToolTip];
        //}else{
        //    self.vwToolTip.hidden = YES;
        //}
    }
    else{
        arr = self.contentCommonItemArray;
        //self.vwToolTip.hidden = YES;
    }
    for (NSInteger idx = 0; idx < arr.count; idx++) {
        NSDictionary* dict = [arr objectAtIndex:idx];
        NSString* field = [dict objectForKey:@"field"];
        UIButton* btnValue = (UIButton*)[self.contentView viewWithTag:1000 + idx];
//        UILabel* lbTip = (UILabel*)[self.contentView viewWithTag:2000 + idx];
        NSNumber* number = [model valueForKey:field];
        
        if(btnValue != nil){
            [btnValue setTitle:[NSString stringWithFormat:@"%@", number] forState:UIControlStateNormal];
        }
    };
}
-(void)displaySummary:(NSArray*) arr{
    
    CGRect rect = DEVICERECT;
    NSInteger col = 3;
    float viewWidth = (rect.size.width - 4) / col;
    float leftmargin = 0;
    if(!self.isManager){
        col = 2;
        leftmargin = 20;
        viewWidth = ((rect.size.width - 2 * leftmargin) - 2) / 2 ;
    }
    if(viewWidth * 2 - 10 > DEVICERECT.size.height - self.contentView.frame.origin.y){
        viewWidth = (DEVICERECT.size.height - self.contentView.frame.origin.y - 5) / 2;
    }
    float left = (DEVICERECT.size.width - col * viewWidth) / 2;
    leftmargin = left;
//    float left = leftmargin;
    float top = 0;

    for (NSInteger idx = 0; idx < arr.count; idx++) {
        NSDictionary* dict = [arr objectAtIndex:idx];
        left += 1;
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(left, top, viewWidth, viewWidth)];
        view.backgroundColor = [UIColor whiteColor];
        left += viewWidth;
        
        // 画主图
        CGFloat statusWidth = viewWidth - 30;
        CGRect imgRect = CGRectMake((viewWidth - statusWidth) / 2, 5, statusWidth, statusWidth);
        
        UIButton* imgButton = [[UIButton alloc] initWithFrame:imgRect];
        [imgButton setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iconImg"]] forState:UIControlStateNormal];
        imgButton.tag = idx;
        [imgButton addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        imgButton.tag = 1000 + idx;
        [imgButton setTitle:@"0" forState:UIControlStateNormal];
        [imgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        imgButton.titleLabel.font = [UIFont systemFontOfSize:21];
//        [img setImage:[UIImage imageNamed:[dict objectForKey:@"iconImg"]]];
        [view addSubview:imgButton];
        
        // 画地栏
        CGRect nameRect = CGRectMake(viewWidth / 2 -  55, viewWidth - 30, 110, 30);
        UIButton* btnFooter = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFooter setImage:[UIImage imageNamed:[dict objectForKey:@"backImg"]]
                   forState:UIControlStateNormal];
        [btnFooter setTitle:[NSString stringWithFormat:@" %@",[dict objectForKey:@"title"]]
                   forState:UIControlStateNormal];
        btnFooter.frame = nameRect;
        btnFooter.titleLabel.font = [UIFont systemFontOfSize:11];
        [btnFooter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIView* nameView = [[UIView alloc] initWithFrame:nameRect];
//        nameView.backgroundColor = [UIColor blueColor];
        // 画icon
        CGRect iconRect = CGRectMake(1, 6, 18, 18);
        UIImageView* iconImg = [[UIImageView alloc] initWithFrame:iconRect];
        iconImg.image = [UIImage imageNamed:[dict objectForKey:@"backImg"]];
        [nameView addSubview:iconImg];
    
        // 画 title
        nameRect = CGRectMake(21, 8, nameRect.size.width - 21, 14);
        UILabel* lbName = [[UILabel alloc] initWithFrame:nameRect];
        lbName.text = [dict objectForKey:@"title"];
        lbName.font = [UIFont systemFontOfSize:11];
//        lbName.backgroundColor = [UIColor blueColor];
        [nameView addSubview:lbName];
        
//        nameView.backgroundColor = [UIColor redColor];
        
        //[view addSubview:nameView];
        [view addSubview:btnFooter];
        
        [self.contentView addSubview:view];
        if(idx % col == col - 1){
            left = leftmargin;
            top += viewWidth + 1;
        }
    }
    self.vwToolTip.hidden = YES;
}
-(void)btnClickEvent:(id)sender{
    UIButton* button = (UIButton*)sender;
    NSInteger idx = button.tag - 1000;
    NSString* name = nil;
    NSDictionary* dict;
    if(self.isManager && idx < self.contentManagerItemArray.count){
        dict = [self.contentManagerItemArray objectAtIndex:idx];
        name = [dict objectForKey:@"field"];
    }else if(idx < self.contentCommonItemArray.count){
        dict = [self.contentCommonItemArray objectAtIndex:idx];
        name = [dict objectForKey:@"field"];
    }
    if(name == nil){
        return;
    }
    if([name isEqualToString:@"noassign"]
       || [name isEqualToString:@"timeout"]
//       || [name isEqualToString:@"timeoutremind"]
       ){
        [self performSegueWithIdentifier:@"segNavAssign" sender:dict];
    }
    else if([name isEqualToString:@"timeoutremind"] ||
            [name isEqualToString:@"nofollowup"] ||
            [name isEqualToString:@"audit"]
            || [name isEqualToString:@"cluecount"]){
        [self performSegueWithIdentifier:@"segNavNofollow" sender:dict];
    }
    else{
        [self performSegueWithIdentifier:@"navClueList" sender:dict];
    }
}

-(void) settingBarButtonEvent:(id)sender{
    [self performSegueWithIdentifier:@"segNavToSetting" sender:nil];
    
}
-(void) btnNewClueEvent:(id)sender{
    [self performSegueWithIdentifier:@"segMainNavToNew" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ClueViewController class]]){
        ClueViewController* vw = (ClueViewController*)segue.destinationViewController;
         NSDictionary* dict = (NSDictionary*)sender;
        vw.curType = [dict objectForKey:@"field"];
//         vw.title = [dict objectForKey:@"title"];
    }
    else if([segue.destinationViewController isKindOfClass:[NofollowClueViewController class]]){
        NSDictionary* dict = (NSDictionary*)sender;
        NofollowClueViewController* vw =
        (NofollowClueViewController*)segue.destinationViewController;
        vw.type = [dict objectForKey:@"field"];
        vw.title = [dict objectForKey:@"title"];
    }
    else if([segue.destinationViewController isKindOfClass:[AssignClueViewController class]]){
        NSDictionary* dict = (NSDictionary*)sender;
        AssignClueViewController* vw =
        (AssignClueViewController*)segue.destinationViewController;
        vw.type = [dict objectForKey:@"field"];
        vw.title = [dict objectForKey:@"title"];
    }
}
@end

