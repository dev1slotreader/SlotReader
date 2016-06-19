//
//  TestBaseHelper.h
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 06.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestBaseHelper : NSObject

- (NSDictionary *) getAllQuestions;
- (NSInteger) getNumberOfQuestions;
- (NSString *) getTestQuestionWithIndex: (NSInteger) questionIndex;
- (NSArray *) getTestAnswersForQuestionWithIndex: (NSInteger) questionIndex;
- (NSInteger) getRightTestAnswerForQuestionWithIndex: (NSInteger) questionIndex;

@end
