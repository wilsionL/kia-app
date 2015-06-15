//
//  UIPopPickerView.m
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopPickerView.h"
#import "UIAlertView+Show.h"
#define PICKER_IDENTITY  105
@interface UIPopPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign) NSInteger selectedRow;
@end
@implementation UIPopPickerView
-(instancetype) initWithParent:(UIView*)parentView{
    self.selectedRow = 0;
    CGRect frame = CGRectMake(0, 0, DEVICERECT.size.width, 216);
    UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:frame];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.tag = PICKER_IDENTITY;
    return [super initWithParent:parentView ContainerView:pickerView];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return @"请选择";
    if(self.delegate != nil &&
       [self.delegate respondsToSelector:@selector(UIPopPickerView:titleForRow:forComponent:)]){
        return [self.delegate UIPopPickerView:self.dataSource
                                  titleForRow:row - 1
                                 forComponent:component];
    }
    return nil;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count + 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedRow = row;
}
-(void)btnConfirmEvent:(id)sender{
    
    [self hiden];
    if(self.selectedRow <= 0 || self.selectedRow > self.dataSource.count){
        [UIAlertView alert:@"请选择数据"];
        return;
    }
    else if(self.delegate != nil && [self.delegate respondsToSelector:@selector(UIPopPickerView:andSelectedItem:)]){
        [self.delegate UIPopPickerView:self
                       andSelectedItem:[self.dataSource objectAtIndex:self.selectedRow - 1]];
    }
}
-(void)btnCancelEvent:(id)sender{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(Cancel:)]){
        [self.delegate Cancel:self];
    }
     [self hiden];
}
-(void)setDataSource:(NSArray *)dataSource{
    self.selectedRow = 0;
    _dataSource = dataSource;
}
-(void)reload{
    UIPickerView* pv = (UIPickerView*)[self viewWithTag:PICKER_IDENTITY];
    if(pv != nil){
        [pv reloadAllComponents];
    }
    [pv selectRow:0 inComponent:0 animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
