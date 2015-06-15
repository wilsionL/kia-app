//
//  AssignClueTableViewCell.m
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "AssignClueTableViewCell.h"
@interface AssignClueTableViewCell()
@property (nonatomic, weak) IBOutlet UIView* btnAsigned;
@end
@interface AssignClueTableViewCell()<UICheckDelegate>

@end
@implementation AssignClueTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.btnAsigned.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAsignedEvent:)];
    [self.btnAsigned addGestureRecognizer:tapGesture];
    self.checkbox.delegate = self;
    [self.checkbox setCheckedImage:@"rdo_selected" andUncheckedImage:@"rdo_unselected"];
    self.checkbox.text = @"选择";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)btnAsignedEvent:(id)sender{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(SelectSales:)]){
        [self.delegate SelectSales:self];
    }
}
-(void)CheckChange:(UICheckbox *)checkbox andIsCheck:(BOOL)check{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(SelectClueInfo:andIsChecked:)]){
        [self.delegate SelectClueInfo:self andIsChecked:check];
    }
}
@end
