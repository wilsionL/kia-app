//
//    UICheckbox.m
//
//    Author:    Brayden Wilmoth
//    Co-Author: Jordan Perry
//    Edited:    07/17/2012
//
//    Copyright (c) 2012 Brayden Wilmoth.  All rights reserved.
//    http://www.github.com/brayden/
//    http://www.github.com/jordanperry/
//

#import "UICheckbox.h"

@interface UICheckbox (){
    BOOL loaded;
}

@property(nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong) NSString* checkedImagePath;

@property (nonatomic, strong) NSString* unCheckedImagePath;
@end



@implementation UICheckbox
@synthesize checked = _checked;
@synthesize disabled = _disabled;
@synthesize text = _text;
@synthesize textLabel = _textLabel;

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect {
    if(self.checkedImagePath == nil) self.checkedImagePath = @"uicheckbox_checked.png";
    if(self.unCheckedImagePath == nil) self.unCheckedImagePath = @"uicheckbox_unchecked.png";
    
    UIImage *image = [UIImage imageNamed:self.checked ? self.checkedImagePath : self.unCheckedImagePath];
//    
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"uicheckbox_%@checked.png", (self.checked) ? @"" : @"un"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    if(self.disabled) {
        self.userInteractionEnabled = FALSE;
        self.alpha = 0.7f;
    } else {
        self.userInteractionEnabled = TRUE;
        self.alpha = 1.0f;
    }
    
    if(self.text) {
        if(!loaded) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width + 5, 0, 1024, 20)];
            _textLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_textLabel];

            loaded = TRUE;
        }
        
        _textLabel.text = self.text;
    }
}
-(void)setCheckedImage:(NSString*)checkedImg andUncheckedImage:(NSString*) uncheckedImg{
    self.checkedImagePath = checkedImg;
    self.unCheckedImagePath = uncheckedImg;
    [self setNeedsDisplay];
}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setChecked:!self.checked];
    return TRUE;
}
-(void)setChecked:(BOOL)boolValue {
    _checked = boolValue;
    if([self.delegate respondsToSelector:@selector(CheckChange:andIsCheck:)]){
        [self.delegate CheckChange:self andIsCheck:boolValue];
    }
    [self setNeedsDisplay];
}
-(void)setDisabled:(BOOL)boolValue {
    _disabled = boolValue;
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)stringValue {
    _text = stringValue;
    [self setNeedsDisplay];
}

@end