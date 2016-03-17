//
//  ViewController.m
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "ViewController.h"
#import "WordPickerHelperViewController.h"

@interface ViewController (){
	WordPickerHelperViewController *pickerHelper;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	pickerHelper = [[WordPickerHelperViewController alloc] init];
	
	//[self.picker setDelegate:pickerHelper];
	//[self.picker setDataSource:pickerHelper];
	self.picker.delegate = pickerHelper;
	self.picker.dataSource = pickerHelper;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
