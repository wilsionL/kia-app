//
//  UIPopDatePickerView.m
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopDatePickerView.h"
#define DATEPICKER_IDENTITY  1001
@interface UIPopDatePickerView()

@end
@implementation UIPopDatePickerView
-(instancetype) initWithParent:(UIView*)parentView{
    CGRect frame = CGRectMake(0, 0, DEVICERECT.size.width, 216);
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:frame];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.tag = DATEPICKER_IDENTITY;
    return [self initWithParent:parentView ContainerView:datePicker];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
