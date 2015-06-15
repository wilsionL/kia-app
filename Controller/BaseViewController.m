//
//  BaseViewController.m
//  kia-app
//
//  Created by jieyeh on 14/11/2.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIView*  headView;

@property (nonatomic, strong) UIView*  titleView;
@property (nonatomic, strong) UIView*  leftiew;
@property (nonatomic, strong) UIView*  rightView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headView removeFromSuperview];
    self.headView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationView:(UIColor*)bgColor{
    CGRect frame = DEVICERECT;
    frame.size.height = 64;
    self.headView = [[UIView alloc] initWithFrame: frame];
    if(bgColor != nil){
        self.headView.backgroundColor = bgColor;
    }
//    self.headView.backgroundColor = [UIColor redColor];
    [self.navigationController.view addSubview:self.headView];
}
-(void)setBackButton{
    CGRect frame = CGRectMake(0, 0, 29, 29);
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"]
                          forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnBackEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self buildLeftView:leftButton];
}
-(void)setNavigationTitle:(NSString*)title{
    CGRect frame = CGRectMake(0, 0, 200, 20);
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self buildCenterView:titleLabel];
}
//-(void)setSettingView{
//    CGRect frame = CGRectMake(0, 0, 20, 20);
//    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = frame;
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"setting"]
//                          forState:UIControlStateNormal];
//    [self buildLeftView:leftButton];
//}
//-(void)setAddButtonView{
//    CGRect frame = CGRectMake(0, 0, 29, 29);
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = frame;
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"home_add"]
//                           forState:UIControlStateNormal];
//    [self buildRightView:rightButton];
//}
//-(void)setLogoView{
//    CGRect frame = CGRectMake(0, 0, 62, 30);
//    UIImageView* logoView = [[UIImageView alloc] initWithFrame:frame];
//    [logoView setImage:[UIImage imageNamed:@"logo"]];
//    [self buildCenterView:logoView];
//
//}
-(void)buildLeftView:(UIView*)lv{
    if(self.headView == nil) return;
    
    CGRect frame = lv.frame;
    frame.origin.x = 10;
    frame.origin.y = (44 - frame.size.height) / 2 + 20;
    lv.frame = frame;
    if(self.leftiew != nil){
        [self.leftiew removeFromSuperview];
    }
    self.leftiew = lv;
    [self.headView addSubview:self.leftiew];
    
}
-(void)buildRightView:(UIView*)rv{
    if(self.headView == nil) return;
    CGRect frame = rv.frame;
    frame.origin.x = DEVICERECT.size.width - 10 - rv.frame.size.width;
    frame.origin.y = (44 - frame.size.height) / 2 + 20;
    if(self.rightView != nil){
        [self.rightView removeFromSuperview];
    }
    rv.frame = frame;
    self.rightView = rv;
    [self.headView addSubview:self.rightView];
}

-(void)buildCenterView:(UIView*)cv{
    if(self.headView == nil) return;
    CGRect frame = cv.frame;
    frame.origin.x = (DEVICERECT.size.width - cv.frame.size.width) / 2;
    frame.origin.y = (44 - frame.size.height) / 2 + 20;
    if(self.titleView != nil){
        [self.titleView removeFromSuperview];
    }
    cv.frame = frame;
    self.titleView = cv;
    [self.headView addSubview:self.titleView];
}
-(IBAction)btnBackEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
