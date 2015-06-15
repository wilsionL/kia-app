//
//  EditClue3TableViewCell.m
//  kia-app
//
//  Created by wewin-mac on 14/12/24.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "EditClue3TableViewCell.h"

@implementation EditClue3TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textViewDidChange:(UITextView *)textView{
    if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(changeTextView3:andText:)]){
        if (self.vinText.text.length>17) {
            self.vinText.text=[self.vinText.text substringToIndex:17];
        }else{
            [self.delegate changeTextView3:self andText:textView.text];
        }
    }
}


@end
