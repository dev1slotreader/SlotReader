//
//  WordPickerHelperViewController.m
//  SlotReader
//
//  Created by User on 3/17/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "WordPickerHelperViewController.h"
#include <AudioToolbox/AudioToolbox.h>

@interface WordPickerHelperViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation WordPickerHelperViewController

- (id) init {
	self = [super init];
	self.alphabet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
					  @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
	self.numberOfLetters = [NSNumber numberWithInt:5];
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void) setNumberOfLetters:(NSNumber *)numberOfLetters andLanguage: (NSString *) language {
	self.numberOfLetters = numberOfLetters;
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [self.numberOfLetters intValue];
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return UINT16_MAX;
}


- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 50;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [self.alphabet objectAtIndex:row % [self.alphabet count]];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
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
