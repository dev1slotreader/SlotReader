//
//  WordPickerHelperViewController.m
//  SlotReader
//
//  Created by User on 3/17/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "WordPickerHelperViewController.h"
#include <AudioToolbox/AudioToolbox.h>
#import "DataMiner.h"

@interface WordPickerHelperViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation WordPickerHelperViewController

- (id) init {
	self = [super init];
	/*self.alphabet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
					  @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]; */
    self.alphabet = [[NSMutableArray alloc] init];
	[self getDataFromStorage];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void) reloadData {
    self.alphabet = nil;
	[self getDataFromStorage];
}

#pragma mark - Getting data

- (void) getDataFromStorage {

	//self.alphabet = [NSMutableArray arrayWithArray:[[DataMiner sharedDataMiner] getWordsOfSize: 1]];
    self.alphabet = [[[DataMiner sharedDataMiner] getWordsOfSize: 1] mutableCopy];
    int numberOfLetters = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPositon"] objectAtIndex:0] intValue];
	self.numberOfLettersToShow = [NSNumber numberWithInt:(numberOfLetters == 0)?6:numberOfLetters];
}


- (void) setNumberOfLettersToShow:(NSNumber *)numberOfLetters andLanguage: (NSString *) language {
	self.numberOfLettersToShow = numberOfLetters;
	
}

- (void) addNewLetterToAlphabet: (NSString *)letter {
    [self.alphabet addObject:letter];
    //[self.alphabet setObject:letter atIndexedSubscript:[self.alphabet count]];
}

- (void) removeTheLetterFromAlphabet: (NSString *)letter {
    [self.alphabet removeObject:letter];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [self.numberOfLettersToShow intValue];
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return UINT16_MAX;
	//return (3* [self.alphabet count]);
}


- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return pickerView.frame.size.height / 3;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [self.alphabet objectAtIndex:row % [self.alphabet count]];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	/*int count = [self.alphabet count];
	if ((row <  count)	||  (row > (count * 2)) ){
		[pickerView selectRow: (row % count) inComponent: component animated: NO];
	}*/
	if (!self.pickerWorkingAutomatically) {
		NSLog(@"Hurraw");
	}
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *pickerLabel = [UILabel new];
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[self.alphabet objectAtIndex:row % [self.alphabet count]]];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
	[text addAttribute:NSForegroundColorAttributeName value:self.lightTheme?[UIColor blueColor]:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
	
	pickerLabel.attributedText = text;
	pickerLabel.font = [UIFont systemFontOfSize:30];
	
	return pickerLabel;
}



@end
