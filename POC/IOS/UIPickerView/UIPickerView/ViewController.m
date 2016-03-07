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
	self.colorNamesArray = [[NSArray alloc] initWithObjects:@"Red", @"Orange", @"Yellow", @"Green", @"Blue", @"Purple", nil];
	self.colorsArray = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[self.picker selectRow:0 inComponent:0 animated:YES];
	[self.picker selectRow:1 inComponent:1 animated:YES];
	[self.picker selectRow:2 inComponent:2 animated:YES];
	[self.picker selectRow:3 inComponent:3 animated:YES];
	[self.picker selectRow:4 inComponent:4 animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 5;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [self.colorNamesArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [self.colorNamesArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	self.colorLabel.text = [self.colorNamesArray objectAtIndex:row];
	self.colorLabel.textColor = [self.colorsArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *pickerLabel = [UILabel new];
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[self.colorNamesArray objectAtIndex:row]];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
	pickerLabel.attributedText = text;
	pickerLabel.backgroundColor = [self.colorsArray objectAtIndex:row];
	return pickerLabel;
}

@end
