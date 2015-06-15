//
//  UIPopView.h
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIPopOverlayView : UIView
-(instancetype)initWithParent:(UIView*)parentView ContainerView:(UIView*) container;
-(void) show;
-(void) hiden;
-(Boolean) isHide;
@end
