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
	return [[allData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"], size]];
}

@end
