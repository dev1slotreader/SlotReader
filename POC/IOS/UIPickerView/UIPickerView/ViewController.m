//
//  ViewController.m
//  UIPickerView
//
//  Created by User on 3/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.alphabet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
					  @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
	self.colorsArray = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], nil];

	unsigned rgbValue = 0;
	NSScanner *scanner = [NSScanner scannerWithString:@"#37433B"];
	[scanner setScanLocation:1]; // bypass '#' character
	[scanner scanHexInt:&rgbValue];
	[self.picker setBackgroundColor:[UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated {
	//[self.picker selectRow:0 inComponent:0 animated:YES];
	//[self.picker selectRow:1 inComponent:1 animated:YES];
	//[self.picker selectRow:2 inComponent:2 animated:YES];
	//[self.picker selectRow:3 inComponent:3 animated:YES];
	//[self.picker selectRow:4 inComponent:4 animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 5;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return UINT16_MAX;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 80;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [self.alphabet objectAtIndex:row % [self.alphabet count]];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	self.colorLabel.text = [self.alphabet objectAtIndex:row % [self.alphabet count]];
	
	//self.colorLabel.textColor = [self.colorsArray objectAtIndex:row % [self.colorsArray count]];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *pickerLabel = [UILabel new];
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[self.alphabet objectAtIndex:row % [self.alphabet count]]];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
	[text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
	
	pickerLabel.attributedText = text;
	pickerLabel.font = [UIFont systemFontOfSize:40];
	
	//pickerLabel.backgroundColor = [self.colorsArray objectAtIndex:row % [self.colorsArray count]];
	return pickerLabel;
}

#pragma mark Displaying the words

- (void) displayWord:(NSString *)word animated:(BOOL)animated {
	for (NSUInteger i = 0; i < [word length]; i++) {
		NSString *letter = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
		[self displayLetter:letter
				atComponent:i
				   animated:animated];
	}
}

- (void) displayLetter:(NSString *)letter atComponent:(NSUInteger)component animated:(BOOL)animated {
	NSUInteger row;
	if (animated){
		NSUInteger selectedRow = [self.picker selectedRowInComponent:component];
		row = selectedRow + ([self.alphabet count] - selectedRow % [self.alphabet count]) + [self.alphabet indexOfObject:letter];
	}
	else
		row = ((UINT16_MAX) / (2 * [self.alphabet count]) * [self.alphabet count]) + [self.alphabet indexOfObject:letter];
	[self.picker selectRow:row
					 inComponent:component
						animated:animated];
}

@end
