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
	BOOL addingMode;
	
}

@end

@implementation DictationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.cellSelectionCounter = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	addingMode = YES;
	[self addObserver:self forKeyPath:@"cellSelectionCounter" options:NSKeyValueObservingOptionNew context:nil];
	
	//self.addDeleteButton.layer.cornerRadius = self.addDeleteButton.frame.size.width/2;
	
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
	[self removeObserver:self forKeyPath:@"cellSelectionCounter"];
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
	self.fancyTextInputBlock.hidden = YES;
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Success"
										  message:@"New word was added"
										  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction
							   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction *action)
							   {
								   NSLog(@"OK action");
							   }];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
	[self.tableView reloadData];
}

- (void) changeLanguage {
	[self getDataFromSource];
	[self.tableView reloadData];
	
	NSLog(@"changeLanguage");
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.addDeleteButton setImage:[UIImage imageNamed:@"ic_clear_white"] forState:UIControlStateNormal];
	addingMode = NO;
	UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	switch (self.cellSelectionCounter) {
  case 0:
			[self.addDeleteButton setImage:[UIImage imageNamed:@"ic_add_white"] forState:UIControlStateNormal];
			self.editButton.hidden= YES;
			break;
	case 1:
			[self.addDeleteButton setImage:[UIImage imageNamed:@"ic_cancel_white"] forState:UIControlStateNormal];
			self.editButton.hidden = NO;
  default:
			self.editButton.hidden = NO;			break;
	}
}

- (IBAction)editButtonClicked:(id)sender {
}

- (IBAction)addDeleteButtonClicked{
	//NSString *buttonImageName = addingMode ? @"ic_add_white" : @"ic_clear_white";
	//[self.addDeleteButton setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
	//self.addDeleteButton
	//addingMode = !addingMode;
}

@end
