//
//  NewClue1TableViewCell.m
//  kia-app
//
//  Created by jieyeh on 14/11/3.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "NewClue1TableViewCell.h"
@interface NewClue1TableViewCell() <UITextFieldDelegate>
@end
@implementation NewClue1TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.lbValue addTarget:self
                    action:@selector(valueChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    self.maxLength = -1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)valueChange:(UITextField*)textField{
    
    if (textField == self.lbValue) {
        if (self.maxLength > 0 && textField.text.length > self.maxLength) {
            textField.text = [textField.text substringToIndex:self.maxLength];
        }
    }
    
    if(self.lbValue.isEnabled){
        [self.valDict setObject:self.lbValue.text forKey:@"text"];
    
        [self.valDict setObject:self.lbValue.text forKey:@"val"];
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(valueChange:andFieldName:andNewValue:)]){
        [self.delegate valueChange:self
                      andFieldName:self.fieldName
                       andNewValue:self.lbValue.text];
    }
}
@end
