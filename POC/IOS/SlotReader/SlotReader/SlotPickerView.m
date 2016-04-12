//
//  SlotPickerView.m
//  SlotReader
//
//  Created by User on 4/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "SlotPickerView.h"

@implementation SlotPickerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[self.pickerDelegate showTheFirstWord];
}

@end
