//
//  UISegmentedControl+Multiline.m
//  SwissPlanner
//
//  Created by User on 5/23/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "UISegmentedControl+Multiline.h"

@implementation UIView (LayerShot)

- (UIImage *)imageFromLayer {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end

@implementation UISegmentedControl (Multiline)

- (void)insertSegmentWithMultilineTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setTextColor:[self tintColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont systemFontOfSize:13]];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	[label setNumberOfLines:0];
	
	[label setText:title];
	[label sizeToFit];
	
	[self insertSegmentWithImage:[label imageFromLayer] atIndex:segment animated:animated];
}

- (void)insertSegmentWithMultilineAttributedTitle:(NSAttributedString *)attributedTitle atIndex:(NSUInteger)segment animated:(BOOL)animated {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setTextColor:[self tintColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont systemFontOfSize:13]];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	[label setNumberOfLines:0];
	
	[label setAttributedText:attributedTitle];
	[label sizeToFit];
	
	[self insertSegmentWithImage:[label imageFromLayer] atIndex:segment animated:animated];
}

@end
