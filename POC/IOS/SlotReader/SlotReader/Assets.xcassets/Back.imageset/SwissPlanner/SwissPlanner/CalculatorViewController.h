//
//  CalculatorViewController.h
//  SwissPlanner
//
//  Created by User on 4/12/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlanLabel;
@property (strong, nonatomic) NSNumber *selectedPlanNumber;

@property (weak, nonatomic) IBOutlet UIView *textDisplayView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerLevel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPartnerLevel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPrepayment;
@property (weak, nonatomic) IBOutlet UIView *pickerViewPrepayment;

@property (weak, nonatomic) IBOutlet UILabel *euroSign;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIView *orderSelectionMenuView;

@property (strong, nonatomic) NSString *selectedPlan;

@property (strong, nonatomic) NSNumber *viewControllerIsInSecondaryLine;

- (IBAction)countIncomeButtonTapped:(id)sender;

@end
