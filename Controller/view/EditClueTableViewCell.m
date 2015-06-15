//
//  EditClueTableViewCell.m
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "EditClueTableViewCell.h"
#import "UIColor+HexColor.h"
@interface EditClueTableViewCell()
@property (nonatomic, weak) IBOutlet UIButton* btnIn;
@property (nonatomic, weak) IBOutlet UIButton* btnLeave;
@end
@implementation EditClueTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)btnInEvent:(id)sender{
    self.iscome = @"1";
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(SetComeState:andState:)]){
        [self.delegate SetComeState:self andState:self.iscome];
    }
}

-(IBAction)btnLeaveEvent:(id)sender{
    self.iscome = @"0";
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(SetComeState:andState:)]){
        [self.delegate SetComeState:self andState:self.iscome];
    }
}
-(void)setIscome:(NSString *)iscome{
    _iscome = iscome;
    if([_iscome isEqualToString:@"1"]){
        [self.btnIn setBackgroundImage:[UIImage imageNamed:@"btn_selected"]
                              forState:UIControlStateNormal];
        [self.btnIn setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        [self.btnLeave setBackgroundImage:[UIImage imageNamed:@"btn_unselected"]
                                 forState:UIControlStateNormal];
        [self.btnLeave setTitleColor:[UIColor blackColor]
                              forState:UIControlStateNormal];
    }
    else{
        [self.btnLeave setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [self.btnIn setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];

        [self.btnLeave setBackgroundImage:[UIImage imageNamed:@"btn_selected"]
                                 forState:UIControlStateNormal];
        [self.btnIn setBackgroundImage:[UIImage imageNamed:@"btn_unselected"]
                              forState:UIControlStateNormal];
    }
}
@end
