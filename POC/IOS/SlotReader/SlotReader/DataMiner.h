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

@property (nonatomic, strong) NSDictionary *allWords;
- (NSDictionary *) getWords;
- (NSArray *) getWordsOfSize: (int) size;
- (NSArray *) getLanguages;
- (void) addNewWord: (NSString *) word;

@end
