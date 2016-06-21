//
//  TestBaseHelper.m
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 06.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "TestBaseHelper.h"
#import "LanguageHelper.h"

@implementation TestBaseHelper {
    NSString *currentLanguage;
    NSDictionary *currentTestsDictionary;
    NSArray *dictionaryIndexesArray;
    LanguageHelper *languageHelper;
}

- (id) init {
    if (self == nil) {
        self = [super init];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    languageHelper = [[LanguageHelper alloc] init];
    currentLanguage = [languageHelper getCurrentLanguage];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tests_source" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSDictionary *buffer = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0];
    currentTestsDictionary = [buffer objectForKey:([[buffer allKeys] containsObject:currentLanguage])?currentLanguage:@"en"];
    dictionaryIndexesArray = [[currentTestsDictionary allKeys]  sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    return self;
}

- (NSDictionary *) getAllQuestions {
    return currentTestsDictionary;
}

- (NSInteger) getNumberOfQuestions {
    return [currentTestsDictionary count];
}

- (NSString *) getTestQuestionWithIndex: (NSInteger) questionIndex {
    NSString *rawAnswer = [dictionaryIndexesArray objectAtIndex:questionIndex];
    NSRange extraRange = [rawAnswer rangeOfString:@". "];
    NSRange trashRange = NSMakeRange(0, (extraRange.location + extraRange.length));
    
    if (NSNotFound != trashRange.location) {
        rawAnswer = [rawAnswer
                    stringByReplacingCharactersInRange: trashRange
                    withString:                         @""];
    }
    return rawAnswer;
}

- (NSArray *) getTestAnswersForQuestionWithIndex: (NSInteger) questionIndex {
    NSString *key = [dictionaryIndexesArray objectAtIndex:questionIndex];
    NSArray *keysArray = [[currentTestsDictionary objectForKey:key] allKeys];
    
    return [keysArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
- (NSInteger) getRightTestAnswerForQuestionWithIndex: (NSInteger) questionIndex {
    NSDictionary *questionAnswersDictionary = [currentTestsDictionary objectForKey:[dictionaryIndexesArray objectAtIndex:questionIndex]];
    NSString *rightAnswer = [questionAnswersDictionary allKeysForObject:[NSNumber numberWithBool:YES]][0];
    return [[self getTestAnswersForQuestionWithIndex:questionIndex] indexOfObject:rightAnswer];
}

@end
