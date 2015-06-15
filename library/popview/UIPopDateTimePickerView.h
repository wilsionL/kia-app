//
//  UIPopDateTimePickerView.h
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopOverlayView.h"
@class UIPopDateTimePickerView;
@protocol UIPopDateTimePickerViewDelegate<NSObject>
-(void)UIPopDateTimePickerView:(UIPopDateTimePickerView*)pickerView
               andSelectedDate:(NSDate*) date
                       andTime:(NSDate*) time;
@end
@interface UIPopDateTimePickerView : UIPopOverlayView
-(instancetype) initWithParent:(UIView*)parentView;
@property (nonatomic, assign) id delegate;
@end
