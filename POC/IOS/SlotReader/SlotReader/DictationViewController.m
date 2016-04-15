//
//  DictationViewController.m
//  SlotReader
//
//  Created by User on 4/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DictationViewController.h"
#import "DataMiner.h"
#import "SWRevealViewController.h"

@interface DictationViewController () {
	DataMiner *dataMiner;
	NSInteger numberOfLetters;
	NSMutableArray *words;
	SWRevealViewController *revealViewController;
	AppDelegate *appDelegate;
}

@end

@implementation DictationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	numberOfLetters = 1;
	[self getDataFromSource];
	self.tableView.frame = self.view.bounds;
	
	self.fancyTextInputBlock.button = self.addButton;
	self.fancyTextInputBlock.cornerRadius = 10;
	self.textField.delegate = self;
	
	revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		
		[self.showMenuButton setTarget: self.revealViewController];
		[self.showMenuButton setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
	
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	appDelegate.languageSelectorDelegate = self;	
}

- (void) viewWillDisappear:(BOOL)animated {
	appDelegate.languageSelectorDelegate = nil;
	[super viewWillDisappear:animated];
}

- (void) getDataFromSource {
	dataMiner = [DataMiner sharedDataMiner];
	words = [[NSMutableArray alloc] initWithArray:[dataMiner getWordsOfSize:numberOfLetters]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [words count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	cell.textLabel.text = [words objectAtIndex:indexPath.row];
	return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	return NO;
}

- (IBAction)changeNumberOfLetters:(id)sender {
	numberOfLetters = (int)((UIBarButtonItem *)sender).tag;
	[self getDataFromSource];
	[self.tableView reloadData];
	//[self.view setNeedsDisplay];
	NSLog(@"%d", numberOfLetters);
}

- (IBAction)addNewWord:(id)sender {
	self.fancyTextInputBlock.hidden = !self.fancyTextInputBlock.isHidden;
	
}

- (IBAction)insertNewWordIntoBase:(id)sender {
	DataMiner *dataMiner = [DataMiner sharedDataMiner];
	[dataMiner addNewWord:self.textField.text];
}

- (void) changeLanguage {
	[self getDataFromSource];
	[self.tableView reloadData];
	
	NSLog(@"changeLanguage");
}
@end
