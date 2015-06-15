//
//  UIPopView.m
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopOverlayView.h"
#import "UIColor+HexColor.h"
#define POPOVERLAYVIEW_CONTAINER  1005
@interface UIPopOverlayView()
@property (nonatomic, weak) UIView* parentView;
@property (nonatomic, assign) Boolean isViewHiden;
@end
@implementation UIPopOverlayView
-(instancetype)initWithParent:(UIView*)parentView ContainerView:(UIView*) container{
    self = [super init];
    if(self != nil){
        self.parentView = parentView;
        CGRect frame = DEVICERECT;
        frame.origin.y = DEVICERECT.size.height;
        self.frame = frame;
        self.isViewHiden = YES;
               // 添加标题
        frame = CGRectMake(0, 0, DEVICERECT.size.width, 40);
        frame.origin.y =
        DEVICERECT.size.height - container.frame.size.height - frame.size.height;
        
        UIView* toolView = [[UIView alloc] initWithFrame:frame];
        // 添加标题背景图
        UIImageView* topImage =
        [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICERECT.size.width, 40)];
        [topImage setImage:[UIImage imageNamed:@"popupwindow_bg"]];
        [toolView addSubview:topImage];
        toolView.backgroundColor = [UIColor whiteColor];
        [self addSubview:toolView];
        // 添加确定按钮
        UIButton* btnComfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnComfirm setTitle:@"确定" forState:UIControlStateNormal];
        btnComfirm.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnComfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        btnComfirm.frame = CGRectMake(DEVICERECT.size.width - 56 - 20, 8, 47, 23) ;
        [btnComfirm setBackgroundImage:[UIImage imageNamed:@"button"]
                       forState:UIControlStateNormal];
        [toolView addSubview:btnComfirm];
        [btnComfirm addTarget:self action:@selector(btnConfirmEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        
        // 添加取消按钮
        UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"button2"]
                       forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(20, 8, 56, 23) ;
        [btnCancel addTarget:self
                      action:@selector(btnCancelEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:btnCancel];
        
//      self.backgroundColor = [UIColor colorWithHex:OVERLAYCOLOR];
        frame = container.frame;
        frame.origin.y = DEVICERECT.size.height - frame.size.height;
        container.frame = frame;
        [self addSubview:container];
        
        [self.parentView addSubview:self];
        
    }
    return self;
}
-(void)show{
    [self.parentView bringSubviewToFront:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.parentView bringSubviewToFront:self];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
    self.isViewHiden = NO;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

}
-(void)hiden{
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    CGRect frame = self.frame;
    frame.origin.y =  DEVICERECT.size.height;
    self.frame = frame;
    self.isViewHiden = YES;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)btnConfirmEvent:(id)sender{
}
-(void)btnCancelEvent:(id)sender{
    [self hiden];
}

-(Boolean) isHide{
    return self.isViewHiden;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
