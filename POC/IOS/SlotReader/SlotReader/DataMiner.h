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
+ (NSArray *) getLanguages;
- (void) initSource;

@property (nonatomic, strong) NSDictionary *allWords;
- (NSDictionary *) getWords;
- (NSArray *) getWordsOfSize: (int) size;
- (NSArray *) getLanguages;
- (BOOL) addNewWord: (NSString *) word;
- (BOOL) deleteWordsAtIndexes: (NSIndexSet *) indexSet;
- (BOOL) updateWordAtIndex: (NSArray *) index withNewWord: (NSString *)newWord;

@end
