//
//  DataMiner.m
//  SlotReader
//
//  Created by User on 4/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DataMiner.h"

@implementation DataMiner {
	NSMutableDictionary *allData;
	NSString *sourcePath;
	NSUserDefaults *defaults;
}

+ (id) sharedDataMiner {
	static DataMiner * sharedDataMiner = nil;
	static dispatch_once_t onceTocken;
	dispatch_once(&onceTocken, ^{
		sharedDataMiner = [[self alloc] init];
	});
	return sharedDataMiner;
}

- (id) init {
	if (self = [super init]) {
		
		defaults = [NSUserDefaults standardUserDefaults];
		
		NSString* const commitingCUDOperationKey = @"commitingCUDOperationKey";
		[defaults setBool:NO forKey:commitingCUDOperationKey];
		
		static NSString* const hasInitAppSourceOnceKey = @"hasInitAppSourceOnceKey";
		if ([defaults boolForKey:hasInitAppSourceOnceKey] == NO) {
			[self initSource];
		}
				
		NSError *error = nil;
		NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES);
		sourcePath =  [NSString stringWithFormat:@"%@/slot_reader_source.txt",
                                                [pathList  objectAtIndex:0]];
		NSMutableData* data = [NSMutableData dataWithContentsOfFile:sourcePath];
		allData = [[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data
																								  options:kNilOptions
																									error:&error]];
        NSLog(@"%@", error);
		
	}
	
	return self;
}

- (void) initSource {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slot_reader_source" ofType:@"txt"];
	
	NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* sourcePath =  [NSString stringWithFormat:@"%@/slot_reader_source.txt", [pathList  objectAtIndex:0]];
	
	NSMutableData* data = [NSMutableData dataWithContentsOfFile:filePath];
	[data writeToFile:sourcePath atomically:NO];
}

- (NSArray *) getLanguages {
	return [allData objectForKey:@"languages"];
}

- (NSArray *) getLocales {
    return [allData objectForKey:@"languagesFull"];
}

- (NSString *) getCurrentLocale {
    int index = [[self getLanguages] indexOfObject:[defaults objectForKey:@"language"]];
    return [[self getLocales] objectAtIndex:index];
}


- (NSDictionary *) getWords {
	NSLog(@"%@", [allData description]);
	return [allData objectForKey:@"words"];
	
}

- (NSArray *) getWordsOfSize: (int) size {
	NSLog(@"%@",[defaults objectForKey:@"language"]);
	return [[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", [defaults objectForKey:@"language"], size]];
}

- (BOOL) addNewWord: (NSString *) word toIndex: (NSNumber *) index {
	NSString* const commitingCUDOperationKey = @"commitingCUDOperationKey";
	[defaults setBool:YES forKey:commitingCUDOperationKey];
	
	NSString *language = [defaults objectForKey:@"language"];
	NSArray *alphabet = [[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", [defaults objectForKey:@"language"], 1]];
	NSMutableString *aphabetString = [[NSMutableString alloc] initWithCapacity:1];
	for (NSString *letter in alphabet) {
		[aphabetString appendString:letter];
	}
	NSCharacterSet *allowedSymbols = [NSCharacterSet characterSetWithCharactersInString:aphabetString];
	word = [[[word componentsSeparatedByCharactersInSet:allowedSymbols] componentsJoinedByString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	NSInteger size = [word length];
	NSMutableArray *thisSizeLangWordsBuffer = [[NSMutableArray alloc] initWithArray:[[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", language, size]]];
    if (index && ([index integerValue]!= NSNotFound)) {
        [thisSizeLangWordsBuffer insertObject:word atIndex:[index integerValue]];
    } else {
        [thisSizeLangWordsBuffer addObject:word];
    }
	
	NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:[allData objectForKey:@"words"]];

	[newData setObject:thisSizeLangWordsBuffer forKey:[NSString stringWithFormat:@"%@%d", [defaults objectForKey:@"language"], size]];
	NSMutableDictionary *newAllData = [[NSMutableDictionary alloc] initWithDictionary:allData];
	[newAllData setObject:newData forKey:@"words"];
	[allData setDictionary:newAllData];
	NSError* error = nil;
	NSMutableData* data = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:newAllData options:NSJSONWritingPrettyPrinted error:nil]];
	
	[defaults setBool:NO forKey:commitingCUDOperationKey];
	
	return [data writeToFile:sourcePath options:NSDataWritingAtomic error: &error];
}


- (BOOL) deleteWordsAtIndexes: (NSIndexSet *) indexSet {
	NSString* const commitingCUDOperationKey = @"commitingCUDOperationKey";
	[defaults setBool:YES forKey:commitingCUDOperationKey];
	
	NSInteger numberOfLetters = [[[defaults objectForKey:@"currentPositon"] objectAtIndex:0] integerValue];
	NSMutableArray *words = [NSMutableArray arrayWithArray:[self getWordsOfSize:numberOfLetters]];
	[words removeObjectsAtIndexes:indexSet];
	
	NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:[allData objectForKey:@"words"]];
	
	[newData setObject:words forKey:[NSString stringWithFormat:@"%@%d", [defaults objectForKey:@"language"], numberOfLetters]];
	NSMutableDictionary *newAllData = [[NSMutableDictionary alloc] initWithDictionary:allData];
	[newAllData setObject:newData forKey:@"words"];
	[allData setDictionary:newAllData];
	
	NSError* error = nil;
	NSMutableData* data = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:newAllData options:NSJSONWritingPrettyPrinted error:nil]];
	
	
	[defaults setBool:NO forKey:commitingCUDOperationKey];
	return [data writeToFile:sourcePath options:NSDataWritingAtomic error: &error];
}

- (BOOL) updateWordAtIndex: (NSUInteger) index withNewWord: (NSString *)newWord {
	NSString* const commitingCUDOperationKey = @"commitingCUDOperationKey";
	[defaults setBool:YES forKey:commitingCUDOperationKey];
	
	BOOL result = NO;
	
	//NSInteger newWordSizeIndexComponent = [newWord length];
    NSIndexSet *oldWordIndexSet = [NSIndexSet indexSetWithIndex: index];
	if ([self deleteWordsAtIndexes:oldWordIndexSet]) {
        
        result = [self addNewWord:newWord toIndex:[NSNumber numberWithInteger:index]];
	} else {
		result = NO;
	}
	
	[defaults setBool:NO forKey:commitingCUDOperationKey];
	return result;
}

@end
