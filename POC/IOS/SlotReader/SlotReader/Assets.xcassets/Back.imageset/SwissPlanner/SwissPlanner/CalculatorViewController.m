//
//  CalculatorViewController.m
//  SwissPlanner
//
//  Created by User on 4/12/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "CalculatorViewController.h"
#import "SWRevealViewController.h"

#import "PlatformTypeChecker.h"

@interface CalculatorViewController () {
	NSArray *levelsArray;
    NSArray *prepaymentArray;
	NSArray *prepaymentValuesArray;
    NSArray *plansArray;
	NSArray *bonusForLevelsArray;
   
    BOOL checkBoxSelected;
    BOOL orderSelecting;
    
    NSInteger selectedPlan;
	NSInteger myLevel;
	NSInteger partnersLevel;
}

@property (weak, nonatomic) IBOutlet UILabel *yourLevelPickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnersLevelePickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *prepaymentPickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDirectLabel;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self updateViewBackground];
	
	// setting navigation bar
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];

	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	self.navigationItem.title = NSLocalizedString(@"calculator.title", nil);
	
    if ((self.viewControllerIsInSecondaryLine == nil)||([self.viewControllerIsInSecondaryLine boolValue] == NO)) {
        // adding navigation capabilities
        self.navigationItem.leftBarButtonItem = menuButton;
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
            [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }

    // setting the checkbox
    [_checkbox setBackgroundImage:[UIImage imageNamed:@"notselectedcheckbox.png"]
                        forState:UIControlStateNormal];
    [_checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
                        forState:UIControlStateSelected];
    [_checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
                        forState:UIControlStateHighlighted];
    _checkbox.adjustsImageWhenHighlighted=YES;

	// making fancy corners
	self.calculateButton.clipsToBounds = YES;
	self.calculateButton.layer.cornerRadius = 65 / 2.0 ;
	self.textDisplayView.layer.cornerRadius = self.textDisplayView.frame.size.width / 40;
	self.pickerLevel.layer.cornerRadius = 5;
	self.pickerPartnerLevel.layer.cornerRadius = 5;
	self.pickerPrepayment.layer.cornerRadius = 5;
	self.pickerViewPrepayment.layer.cornerRadius = 5;

	levelsArray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11",nil];
    prepaymentArray = [NSArray arrayWithObjects:@"220", @"720", @"1050", @"2800", @"3550", @"9850", nil];
	prepaymentValuesArray = [NSArray arrayWithObjects:@220, @720, @1050, @2800, @3550, @9850, nil];
    plansArray = [NSArray arrayWithObjects:
				  NSLocalizedString(@"calculator.order.preOrder", nil),
				  NSLocalizedString(@"calculator.order.mainOrder", nil),
				  NSLocalizedString(@"calculator.order.preVipOrder", nil),
				  NSLocalizedString(@"calculator.order.vipOrder", nil),
				  NSLocalizedString(@"calculator.order.preVipPlusOrder", nil),
				  NSLocalizedString(@"calculator.order.vipPlusOrder", nil),
				  nil];
	
	bonusForLevelsArray = [NSArray arrayWithObjects: @0, @15, @20, @25, @30, @35, @40, @43, @45, @47, @49, @50, nil];
    
	self.yourLevelPickerLabel.text = NSLocalizedString(@"calculator.content.yourLevel", nil);
	self.partnersLevelePickerLabel.text = NSLocalizedString(@"calculator.content.partnersLevel", nil);
	self.prepaymentPickerLabel.text = NSLocalizedString(@"calculator.content.prepayment", nil);
	self.isDirectLabel.text = NSLocalizedString(@"calculator.content.isDirect", nil);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    selectedPlan = [self.selectedPlanNumber isEqual:nil] ? 1 : [self.selectedPlanNumber integerValue];
	if (selectedPlan) {
		self.selectedPlanLabel.text = [plansArray objectAtIndex:selectedPlan];
		[self.pickerPrepayment selectRow:selectedPlan inComponent:0 animated:YES];
    } else {
        self.selectedPlanLabel.text = [plansArray objectAtIndex:0];
    }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self updateViewBackground];
    } completion:^(id  _Nonnull context) {
		[self.textView setNeedsDisplay];
		
        // after rotation
    }];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.selectedPlan = nil;
    self.viewControllerIsInSecondaryLine = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) getFontSize {
    NSString *platform = [PlatformTypeChecker platformType];
    if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"iPhone 6 Plus"]||[platform isEqualToString:@"iPhone 6S Plus"]||[platform isEqualToString:@"Simulator"]) {
        return 16;
    } else if ([platform isEqualToString:@"iPhone 4"]||[platform isEqualToString:@"iPhone 4S"]){
        return 15;
    } else {
        return 15;
    }
}

- (void) updateViewBackground {
    NSString *platform = [PlatformTypeChecker platformType];
    if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"Simulator"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_iphone6"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_iphone6"] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Pickerview delegate methods

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return (pickerView.frame.size.height / 2.5);
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 2) {
        return [plansArray count];
    }
	return [levelsArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSArray *)getPickerSourceArrayByTag: (NSInteger) tag {
    switch (tag) {
        case 0:
        case 1:
            return levelsArray;
            break;
        case 2:
            return prepaymentArray;
            break;
        default:
            break;
    }
    return nil;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* pickerLabel = (UILabel*)view;
	
	if (!pickerLabel)
	{
		pickerLabel = [[UILabel alloc] init];
		
		pickerLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold"                size:16];
		pickerLabel.textColor = [UIColor whiteColor];
		pickerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		pickerLabel.textAlignment=NSTextAlignmentCenter;
	}
    
	[pickerLabel setText:[[self getPickerSourceArrayByTag:pickerView.tag] objectAtIndex:row]];
	
	[[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
	[[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
	
	return pickerLabel;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            selectedPlan = row;
            self.selectedPlanLabel.text = [plansArray objectAtIndex:selectedPlan];
            break;
        default:
            break;
    }
}

#pragma mark - TableView delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [plansArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (tableView.frame.size.height / [plansArray count]);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = [plansArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.backgroundColor = [UIColor clearColor];
	
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlan = indexPath.row;
    self.selectedPlanLabel.text = [plansArray objectAtIndex:selectedPlan];
	[self.pickerPrepayment selectRow:selectedPlan inComponent:0 animated:YES];
	[self updateOrderSelectionMenu];
}



#pragma mark - Checkbox methods

- (IBAction)isDirectButtonClicked:(id)sender {
    checkBoxSelected = !checkBoxSelected; /* Toggle */
    [_checkbox setSelected:checkBoxSelected];

    NSInteger level;
	NSInteger partnersLevel;
    if (checkBoxSelected) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        level = [[defaults objectForKey:@"userLevel"] integerValue];
		partnersLevel = 0;
    } else {
        level = 0;
		partnersLevel = 0;
    }
	
    [self.pickerLevel selectRow:level inComponent:0 animated:YES];
	[self.pickerPartnerLevel selectRow:partnersLevel inComponent:0 animated:YES];
}

- (IBAction)openOrderSelectionMenu:(id)sender {
	[self updateOrderSelectionMenu];
}

- (void) updateOrderSelectionMenu {
	orderSelecting =!orderSelecting;
	self.orderSelectionMenuView.hidden = !orderSelecting;
	[self.view setNeedsDisplay];
}



- (NSAttributedString *) countIncomeResult {
	NSInteger yourLevelBonus = [[bonusForLevelsArray objectAtIndex:[self.pickerLevel selectedRowInComponent:0]] integerValue];
    NSInteger partnerLevelBonus = (checkBoxSelected)? [[bonusForLevelsArray objectAtIndex:0] integerValue]:[[bonusForLevelsArray objectAtIndex:[self.pickerPartnerLevel selectedRowInComponent:0]] integerValue];
	
	// Showing the prepayment value
    NSInteger internetCommission = (selectedPlan>1)?50:20;
	NSNumber *prepaymentValue =  [NSNumber numberWithInteger:([[prepaymentValuesArray objectAtIndex:selectedPlan] integerValue] - internetCommission)];
	NSString *prepaymentString = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula1", nil), [[prepaymentValuesArray objectAtIndex:selectedPlan] stringValue], internetCommission, [prepaymentValue stringValue]];
    
    
    // Showing the turnover value
    
    NSNumber *turnoverValue0 =  [NSNumber numberWithDouble:( [prepaymentValue integerValue] *4 )];
    NSString *turnoverString0 = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula2", nil), [prepaymentValue stringValue], [turnoverValue0 stringValue]];
    
	// Showing the turnover value
	
	NSNumber *turnoverValue =  [NSNumber numberWithDouble:( [prepaymentValue integerValue] *3 )];
	NSString *turnoverString = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula3", nil), [turnoverValue0 stringValue], [prepaymentValue stringValue],[turnoverValue stringValue]];
    // Showing the turnover value
    
    NSNumber *turnoverValue2 =  [NSNumber numberWithDouble:( [turnoverValue doubleValue] * 0.9 )];
    NSString *turnoverString2 = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula4", nil), [turnoverValue stringValue],[turnoverValue2 stringValue]];
    
	// Showing the number of carier points value
	NSNumber *carierPointsValue =  [NSNumber numberWithDouble:( [turnoverValue2 doubleValue]/500)];
	NSString *carierPointsString = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula5", nil), [turnoverValue2 stringValue], [carierPointsValue stringValue]];
	// Showing the number of carier points value
	
	NSNumber *carierPointPriceValue =  [NSNumber numberWithInteger:(yourLevelBonus - partnerLevelBonus)];
	NSString *carierPointPriceString = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula6", nil), yourLevelBonus, partnerLevelBonus, [carierPointPriceValue stringValue]];
	// Showing the income value
	NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
	[nf setMaximumFractionDigits:3];
	NSNumber *incomeValue =  [NSNumber numberWithDouble:([carierPointPriceValue doubleValue]*[carierPointsValue doubleValue])];
	NSString *extraInfo = NSLocalizedString(@"calculator.content.formula7", nil);
	NSString *incomeString = [NSString stringWithFormat:NSLocalizedString(@"calculator.content.formula8", nil), [carierPointPriceValue stringValue], [carierPointsValue stringValue], [ nf stringFromNumber:incomeValue], ([incomeValue intValue]>0)?@"":extraInfo];
	
	NSMutableAttributedString *attributedResultsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@", turnoverString0, turnoverString, turnoverString2, carierPointsString, carierPointPriceString]];
	[attributedResultsString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[self getFontSize]] range:NSMakeRange(0, attributedResultsString.string.length)];
    
	NSMutableAttributedString *resultAppendix = [[NSMutableAttributedString alloc] initWithString:incomeString];
	[resultAppendix addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(128.0/255.0) green:(0) blue:(0) alpha:1] range:NSMakeRange(0, resultAppendix.string.length)];
	[resultAppendix addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:([self getFontSize] + 1)] range:NSMakeRange(0, resultAppendix.string.length)];
	
	[attributedResultsString appendAttributedString:resultAppendix];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    [attributedResultsString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedResultsString.length)];
	
	return attributedResultsString;
}

- (IBAction)countIncomeButtonTapped:(id)sender {
	
	[UIView animateWithDuration:1.3 animations:^{
        self.textView.alpha = 0.5;
	} completion:^(BOOL finished) {
        [self.textView setAttributedText:[self countIncomeResult]];
		[self.textView flashScrollIndicators];
        self.textView.alpha = 1;
	}];
}
@end
