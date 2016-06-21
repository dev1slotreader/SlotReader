//
//  TestPageViewController.m
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 02.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "TestPageViewController.h"
#import "TestsPageContentViewController.h"

#import "PlatformTypeChecker.h"
#import "TestBaseHelper.h"

typedef enum {
    questionItem,
    answersArrayItem
} pageContentItems;

@implementation TestPageViewController {
    NSInteger lastTestQuestion;
    NSInteger currentTestResult;
    NSUserDefaults *defaults;
    
    NSInteger nextFlag;
    
    NSInteger selectedCheckboxTag;
    TestBaseHelper *testBaseHelper;
    BOOL answerAccepted;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    [self updateViewBackground];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    self.navigationController.navigationBar.translucent = NO;
    [self setCheckboxes];
	
	for (UIView * view in self.roundedCorners) {
		view.layer.cornerRadius = 15;
	}
	
    defaults = [NSUserDefaults standardUserDefaults];
    testBaseHelper = [[TestBaseHelper alloc] init];
	
	[self setTextSizes];
	
	
}

- (void) setTextSizes {
	NSString *platform = [PlatformTypeChecker platformType];
	if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"iPhone 6 Plus"]||[platform isEqualToString:@"iPhone 6S Plus"]) {
		for (UILabel *label in self.answerLabels) {
			label.font = [UIFont systemFontOfSize:18];
		}
		self.questionTextLabel.font = [UIFont systemFontOfSize:20];
	} else if ([platform isEqualToString:@"iPhone 4"]||[platform isEqualToString:@"iPhone 4S"]){
		for (UILabel *label in self.answerLabels) {
			label.font = [UIFont systemFontOfSize:15];
		}
	}
}

- (void) setCheckboxes {
    for (UIButton *checkbox in self.checkboxButtons) {
        // setting the checkbox
        [checkbox setBackgroundImage:[UIImage imageNamed:@"answer_not_selected"]
                             forState:UIControlStateNormal];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"answer_selected"]
                             forState:UIControlStateSelected];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"answer_selected"]
                             forState:UIControlStateHighlighted];
        checkbox.adjustsImageWhenHighlighted=YES;
    }
}

- (IBAction)checkboxButtonClicked:(id)sender {
    UIButton *currentlySelectedCheckbox = (UIButton *)sender;
    NSInteger currentlySelectedCheckboxTag = currentlySelectedCheckbox.tag;
    selectedCheckboxTag = currentlySelectedCheckboxTag;

	[self updateCheckBoxesWithSelectedTagNumber:selectedCheckboxTag];
}

- (void) updateCheckBoxesWithSelectedTagNumber: (NSInteger) selectedTagNumber {
	// every checkbox has its unique tag set by the developer
	// the range is 1..n
	// 0 means no checkbox selected
	for (UIButton *checkbox in self.checkboxButtons) {
		BOOL isCurrentCheckboxSelected = (checkbox.tag==selectedTagNumber);
		[checkbox setSelected: isCurrentCheckboxSelected];
	}
}

- (void) indicateRightAnswerWithTagNumber: (NSInteger) rightTagNumber andWrongTagNumber: (NSInteger) wrongTagNumber{
	// every label has its unique tag set by the developer
	// the range is 1..n
	// 0 means no label should be indicated
	for (UILabel *label in self.answerLabels) {
		if (label.tag == rightTagNumber) {
			label.textColor = [UIColor colorWithRed:(50.0/255.0) green:(129.0/255.0) blue:(11.0/255.0) alpha:1];
		} else if (label.tag == wrongTagNumber) {
			label.textColor = [UIColor colorWithRed:(128.0/255.0) green:(0) blue:(0) alpha:1];
		} else {
			label.textColor = [UIColor blackColor];
		}
	}
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    lastTestQuestion = [[defaults objectForKey:@"lastTestQuestion"] integerValue];
	currentTestResult = lastTestQuestion?[[defaults objectForKey:@"lastTestResult"] integerValue]:0;
    
    [self jumpToTheLastVisitedSlide];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	NSInteger bestTestResult = [[defaults objectForKey:@"bestTestResult"] integerValue];
	if (bestTestResult < currentTestResult) {
		[defaults setObject:[NSNumber numberWithInteger:currentTestResult] forKey:@"bestTestResult"];
	}
    [defaults setObject:[NSNumber numberWithInteger:lastTestQuestion] forKey:@"lastTestQuestion"];
	[defaults setObject:[NSNumber numberWithInteger:currentTestResult] forKey:@"lastTestResult"];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    lastTestQuestion = [(TestsPageContentViewController *)[pendingViewControllers objectAtIndex:0] pageIndex];
}

- (void) jumpToTheLastVisitedSlide {
    [self jumpToQuestion:lastTestQuestion];
    
}

- (void) jumpToQuestion: (NSInteger) questionNumber {
    
    self.questionNumberIndicatorLabel.text = [NSString stringWithFormat:NSLocalizedString(@"testing.slide.questionLabel", nil), (lastTestQuestion + 1), [testBaseHelper getNumberOfQuestions]];
    
    //setting the layout
    self.questionTextLabel.text = [testBaseHelper getTestQuestionWithIndex:lastTestQuestion];
    self.question1Label.text = [[testBaseHelper getTestAnswersForQuestionWithIndex:lastTestQuestion] objectAtIndex:0];
    self.question2Label.text = [[testBaseHelper getTestAnswersForQuestionWithIndex:lastTestQuestion] objectAtIndex:1];
    self.question3Label.text = [[testBaseHelper getTestAnswersForQuestionWithIndex:lastTestQuestion] objectAtIndex:2];

}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self updateViewBackground];
    } completion:^(id  _Nonnull context) {
        
        // after rotation
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateViewBackground {
	NSString *platform = [PlatformTypeChecker platformType];
	if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"Simulator"]) {
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)_iphone6"]];
		
		UIImage *back = [[UIImage imageNamed:@"nav_bar_iphone6"]
						 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
		[self.navigationController.navigationBar setBackgroundImage:back forBarMetrics:UIBarMetricsDefault];
		
	} else {
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)"]];
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
	}
}



- (IBAction)activeButtonClicked:(id)sender {
   
    [self.activeButton setBackgroundImage:[UIImage imageNamed:(!answerAccepted?@"next_question":@"accept_answer")] forState:UIControlStateNormal];
   
    if (answerAccepted) {
        if ([testBaseHelper getNumberOfQuestions]==(lastTestQuestion+1)) {
            lastTestQuestion = 0;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            lastTestQuestion ++;
            [self jumpToQuestion:lastTestQuestion];
			
			[UIView animateWithDuration:0.5 animations:^{
				self.questionBlockView.alpha = 0.5;
                
                selectedCheckboxTag = 0;
                [self indicateRightAnswerWithTagNumber:0 andWrongTagNumber:0];
                [self updateCheckBoxesWithSelectedTagNumber:selectedCheckboxTag];
			} completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.questionBlockView.alpha = 1;
                }];
			}];
        }
		
    } else {
		// the answers are in range 0..n-1
		// but the tags are in 1..n
        NSInteger rightAnswer = [testBaseHelper getRightTestAnswerForQuestionWithIndex:lastTestQuestion] + 1;
		
		[self indicateRightAnswerWithTagNumber:rightAnswer andWrongTagNumber:(rightAnswer == selectedCheckboxTag)?0:selectedCheckboxTag];

		currentTestResult += (rightAnswer == selectedCheckboxTag)?1:0;
    }
     answerAccepted = !answerAccepted;
}



@end
