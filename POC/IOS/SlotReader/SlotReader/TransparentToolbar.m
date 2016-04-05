//
//  TransparentToolbar.m
//  SlotReader
//
//  Created by User on 3/23/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "TransparentToolbar.h"

@implementation TransparentToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) applyTransulentBackground {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.translucent = YES;
}

- (id) init {
	self = [super init];
	//[self setBarStyle:UIBarStyleBlackTranslucent];
	[self applyTransulentBackground];
	return self;
}

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	//[self setBarStyle:UIBarStyleBlackTranslucent];
	[self applyTransulentBackground];
	return self;
}

@end
