//
//  EditClue2TableViewCell.m
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "EditClue2TableViewCell.h"
@interface EditClue2TableViewCell()<UITextViewDelegate>
@end
@implementation EditClue2TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView{
    if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(changeTextView:andText:)]){
        [self.delegate changeTextView:self andText:textView.text];
    }
}
@end
