//
//  TestCheckerDelegate.h
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 04.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestCheckerDelegate <NSObject>

- (NSInteger) getRightAnswerForTheQuestion: (NSInteger) questionNumber;

@end
