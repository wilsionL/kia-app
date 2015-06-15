//
//  NewClue2TableViewCell.m
//  kia-app
//
//  Created by jieyeh on 14/11/3.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "NewClue2TableViewCell.h"
#import "RadioButton.h"
@interface NewClue2TableViewCell()
@property (nonatomic, strong) IBOutlet RadioButton* maleButton;
@end
@implementation NewClue2TableViewCell

- (void)awakeFromNib {
    // Initialization code
   
}
-(IBAction)onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.tag == 112){
        [self.itemValue setValue:@"m" forKey:@"val"];
    }
    else{
        [self.itemValue setValue:@"f" forKey:@"val"];
    }
}
-(void)setItemValue:(NSMutableDictionary *)itemValue{
    [itemValue setValue:@"m" forKey:@"val"];
    _itemValue = itemValue;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
