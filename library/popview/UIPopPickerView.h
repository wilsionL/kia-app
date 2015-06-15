//
//  UIPopPickerView.h
//  kia-app
//
//  Created by jieyeh on 14/11/7.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "UIPopOverlayView.h"
@class UIPopPickerView;
@protocol UIPopPickerViewDelegate <NSObject>
-(NSString*)UIPopPickerView:(NSArray*)dataSource
                titleForRow:(NSInteger)row
               forComponent:(NSInteger)component;

-(void)UIPopPickerView:(UIPopPickerView*)pickerView
       andSelectedItem:(id)item;
@optional
-(void)Cancel:(UIPopPickerView*)pickerView;
@end
@interface UIPopPickerView : UIPopOverlayView
@property (nonatomic, weak) NSArray* dataSource;
@property (nonatomic, assign) id<UIPopPickerViewDelegate> delegate;
@property (nonatomic, assign) id initValue;
-(instancetype) initWithParent:(UIView*)parentView;
-(void)reload;
@end
