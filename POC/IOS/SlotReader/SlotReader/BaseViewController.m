//
//  BaseViewController.m
//  SlotReader
//
//  Created by Anastasiia on 23.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController {
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
    SWRevealViewController *revealViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.pageTitle = @"ABC Reader";
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.languageSelectorDelegate = self;
    appDelegate.themeSelectorDelegate = self;

   // [self setStyleFromSettings];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];    
    self.navigationItem.title = self.pageTitle;
        
    revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        
        [self.showMenuButton setTarget: self.revealViewController];
        [self.showMenuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    

   // numberPickerCellIds = [[NSArray alloc] initWithObjects:@"cCell1", @"cCell3", @"cCell4", @"cCell5", @"cCell5+", nil];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

@end
