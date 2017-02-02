//
//  DataMiner.h
//  SlotReader
//
//  Created by User on 4/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataMiner : NSObject

+ (id) sharedDataMiner;
- (NSArray *) getLanguages;
- (NSArray *) getLocales;
- (NSString *) getCurrentLocale;
- (void) initSource;

@property (nonatomic, strong) NSDictionary *allWords;
- (NSDictionary *) getWords;
- (NSArray *) getWordsOfSize: (int) size;
- (NSArray *) getLanguages;
- (BOOL) addNewWord: (NSString *) word toIndex: (NSNumber *) index;
- (BOOL) deleteWordsAtIndexes: (NSIndexSet *) indexSet;
- (BOOL) updateWordAtIndex: (NSUInteger) index withNewWord: (NSString *)newWord;

@end
