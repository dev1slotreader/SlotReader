//
//  BaseViewController.h
//  SlotReader
//
//  Created by Anastasiia on 23.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface BaseViewController : UIViewController <LanguageSelector, BoardThemeSelector>

@property (strong, nonatomic) NSString *pageTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
