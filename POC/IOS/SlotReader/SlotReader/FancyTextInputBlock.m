//
//  FancyTextInputBlock.m
//  SlotReader
//
//  Created by User on 4/14/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "FancyTextInputBlock.h"
#import <QuartzCore/QuartzCore.h>

@implementation FancyTextInputBlock


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
	self.layer.cornerRadius = self.cornerRadius;
	self.layer.masksToBounds = YES;
	self.button.layer.cornerRadius = _cornerRadius/2;
	//self.backgroundColor = self.backColor;
	//self.button.backgroundColor = self.buttonColor;
	[super drawRect:rect];
}


@end
