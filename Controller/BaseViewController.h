//
//  BaseViewController.h
//  kia-app
//
//  Created by jieyeh on 14/11/2.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)setNavigationView:(UIColor*)bgColor;
-(void)buildLeftView:(UIView*)lv;
-(void)buildCenterView:(UIView*)lv;

-(void)buildRightView:(UIView*)lv;
-(void)setBackButton;
-(void)setNavigationTitle:(NSString*)title;
-(IBAction)btnBackEvent:(id)sender;
@end
