//
//  DataMiner.m
//  SlotReader
//
//  Created by User on 4/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DataMiner.h"

@implementation DataMiner {
	NSDictionary *allData;
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
		NSError *error = nil;
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slot_reader_source" ofType:@"txt"];
		NSURL *url = [NSURL fileURLWithPath:filePath];
		
		NSData *data = [NSData dataWithContentsOfFile:filePath];
		allData = [NSJSONSerialization JSONObjectWithData:data
																 options:kNilOptions
																   error:&error];
	}
	return self;
}

- (NSArray *) getLanguages {
	return [allData objectForKey:@"languages"];
}

- (NSDictionary *) getWords {
	return [allData objectForKey:@"words"];
}

- (NSArray *) getWordsOfSize: (int) size {
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]);
	return [[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"], size]];
}

- (void) addNewWord: (NSString *) word {
	NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
	NSArray *alphabet = [[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"], 1]];
	NSMutableString *aphabetString = [[NSMutableString alloc] initWithCapacity:1];
	for (NSString *letter in alphabet) {
		[aphabetString appendString:letter];
	}
	NSCharacterSet *allowedSymbols = [NSCharacterSet characterSetWithCharactersInString:aphabetString];
	word = [[word componentsSeparatedByCharactersInSet:allowedSymbols] componentsJoinedByString:@""];
	
	NSInteger size = [word length];
	NSMutableArray *thisSizeLangWordsBuffer = [[NSMutableArray alloc] initWithArray:[[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", language, size]]];
	[thisSizeLangWordsBuffer addObject:word];
	NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:allData];
#warning Why not?
	[[newData objectForKey:@"words"] setObject:thisSizeLangWordsBuffer forKey:[NSString stringWithFormat:@"%@%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"], size]];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slot_reader_source" ofType:@"txt"];
	NSURL *url = [NSURL fileURLWithPath:filePath];
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newData options:NSJSONWritingPrettyPrinted error:nil];
	NSString *newText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
}

@end
