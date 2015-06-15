//
//  UIPopDateTimePickerView.m
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopDateTimePickerView.h"
#define DATEPICKER_IDENTITY  1001
#define TIMEPICKER_IDENTITY  1002
@interface UIPopDateTimePickerView()

@end
@implementation UIPopDateTimePickerView

-(instancetype) initWithParent:(UIView*)parentView{
    CGFloat dateHeight = 216;
    CGFloat timeHeight = 216;
    
    if(DEVICERECT.size.height <= 480){
        dateHeight = 160;
        timeHeight = 160;
    }
    UIView* container =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICERECT.size.width, dateHeight + timeHeight)];
    
    CGRect frame = CGRectMake(0, 0, DEVICERECT.size.width, dateHeight);
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:frame];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.tag = DATEPICKER_IDENTITY;
    [container addSubview:datePicker];
    
    frame = CGRectMake(0, dateHeight, DEVICERECT.size.width, timeHeight);
    UIDatePicker* timePicker = [[UIDatePicker alloc] initWithFrame:frame];
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    timePicker.tag = TIMEPICKER_IDENTITY;
    [container addSubview:timePicker];
    [datePicker setDate:[NSDate date]];
    [timePicker setDate:[NSDate date]];
    return [self initWithParent:parentView ContainerView:container];
}
-(void)btnConfirmEvent:(id)sender{
    UIDatePicker* datePicker = (UIDatePicker*)[self viewWithTag:DATEPICKER_IDENTITY];
    UIDatePicker* timePicker = (UIDatePicker*)[self viewWithTag:TIMEPICKER_IDENTITY];
    if(self.delegate != nil &&
       [self.delegate respondsToSelector:@selector(UIPopDateTimePickerView:andSelectedDate:andTime:)]){
        [self.delegate UIPopDateTimePickerView:self andSelectedDate:datePicker.date andTime:timePicker.date];
    }
    [self hiden];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
