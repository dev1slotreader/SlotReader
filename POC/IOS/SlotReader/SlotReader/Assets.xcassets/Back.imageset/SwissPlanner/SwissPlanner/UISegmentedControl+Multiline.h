//
//  UISegmentedControl+Multiline.h
//  SwissPlanner
//
//  Created by User on 5/23/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (Multiline)

- (void)insertSegmentWithMultilineTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated;

- (void)insertSegmentWithMultilineAttributedTitle:(NSAttributedString *)attributedTitle atIndex:(NSUInteger)segment animated:(BOOL)animated;

@end

@interface UIView (LayerShot)

- (UIImage *)imageFromLayer;

@end
