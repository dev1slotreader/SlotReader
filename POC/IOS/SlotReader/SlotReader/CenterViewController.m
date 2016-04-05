//
//  ViewController.m
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "CenterViewController.h"
#import "WordPickerHelperViewController.h"
#import "MenuPanelViewController.h"

@interface CenterViewController () <MenuPanelViewControllerDelegate>{
	WordPickerHelperViewController *pickerHelper;
	SWRevealViewController *revealViewController;
	MenuPanelViewController *menuPanelViewController;
}

@end

@implementation CenterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	pickerHelper = [[WordPickerHelperViewController alloc] init];
	menuPanelViewController = [[MenuPanelViewController alloc] init];

	self.picker.delegate = pickerHelper;
	self.picker.dataSource = pickerHelper;
	
	[self getDataFromStorage];
	
	//self.navigationController.navigationBar.translucent = YES;
	//self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1];
	self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];
	//[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];
	self.navigationItem.title = @"Slot Reader";
	
	//[self.toolbar setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		
		[self.showMenuButton setTarget: self.revealViewController];
		[self.showMenuButton setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
	
}

- (void) viewDidAppear:(BOOL)animated{
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Getting data

- (void) getDataFromStorage {
	NSError *error = nil;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slot_reader_source" ofType:@"txt"];
	NSURL *url = [NSURL fileURLWithPath:filePath];

	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
															 options:kNilOptions
															   error:&error];
	if (error != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Couldn't load the data"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	} else {
		self.alphabet = [[jsonData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@1",[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]]];
		NSLog(@"OK");
	}
}

#pragma mark - Displaying letters and words

- (void) setNumberOfLetters:(NSNumber *)numberOfLetters andLanguage: (NSString *) language {
	[pickerHelper setNumberOfLetters:numberOfLetters andLanguage:nil];
	[self.picker reloadAllComponents];
}

- (void) displayWord:(NSString *)word animated:(BOOL)animated {
	pickerHelper.pickerWorkingAutomatically = YES;
	for (NSUInteger i = 0; i < [word length]; i++) {
		NSString *letter = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
		[self displayLetter:letter
				atComponent:i
				   animated:animated];
	}
	pickerHelper.pickerWorkingAutomatically = NO;
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

- (IBAction)switchToAlphabet:(id)sender {
	self.picker.hidden = NO;
	self.fivepluslabel.hidden = YES;
	
	[self setNumberOfLetters:[NSNumber numberWithInt:1] andLanguage:nil];
}

- (IBAction)switchTo3:(id)sender {
	self.picker.hidden = NO;
	self.fivepluslabel.hidden = YES;
	
	[self setNumberOfLetters:[NSNumber numberWithInt:3] andLanguage:nil];
	[self displayWord:@"CAT" animated:YES];
}

- (IBAction)switchTo4:(id)sender {
	self.picker.hidden = NO;
	self.fivepluslabel.hidden = YES;
	
	[self setNumberOfLetters:[NSNumber numberWithInt:4] andLanguage:nil];
	[self displayWord:@"TREE" animated:YES];
}

- (IBAction)switchTo5:(id)sender {
	self.picker.hidden = NO;
	self.fivepluslabel.hidden = YES;
	
	[self setNumberOfLetters:[NSNumber numberWithInt:5] andLanguage:nil];
	[self displayWord:@"HELLO" animated:YES];
}

- (IBAction)switchToBigWords:(id)sender {
	//[self setNumberOfLetters:[NSNumber numberWithInt:6] andLanguage:nil];
	//[self displayWord:@"RABBIT" animated:YES];
	self.picker.hidden = YES;
	self.fivepluslabel.hidden = NO;
}

- (IBAction)wordChanged:(id)sender {
	[self.dictionaryButton setImage:[UIImage imageNamed: @"plus"] forState:UIControlStateNormal];
}

- (IBAction)wordChanged2:(id)sender {
	[self.dictionaryButton setImage:[UIImage imageNamed: @"dictionary"] forState:UIControlStateNormal];
}
- (IBAction)changeMenuVisibility:(id)sender {
	self.b1.hidden = !self.b1.hidden;
	self.b2.hidden = !self.b2.hidden;
	self.b3.hidden = !self.b3.hidden;
}

- (IBAction)setDarkBoard:(id)sender {
	self.board.image = [UIImage imageNamed:@"Blackboard-dark"];
	pickerHelper.lightTheme = NO;
	[self.picker reloadAllComponents];
}

- (IBAction)setLightBoard:(id)sender {
	self.board.image = [UIImage imageNamed:@"Blackboard-light"];
	pickerHelper.lightTheme = YES;
	[self.picker reloadAllComponents];
}

- (IBAction)setGreenBoard:(id)sender {
	self.board.image = [UIImage imageNamed:@"Blackboard"];
	pickerHelper.lightTheme = NO;
	[self.picker reloadAllComponents];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)btnMovePanelRight:(id)sender
{
	
	UIButton *button = sender;
	
	switch (button.tag) {
		case 0:
			[self.delegate movePanelToOriginalPosition];
			break;
		case 1:
			[self.delegate movePanelRight];
		default:
			break;
	}
}


@end
