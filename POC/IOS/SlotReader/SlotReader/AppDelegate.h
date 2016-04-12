//
//  AppDelegate.h
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoardThemeSelector <NSObject>

- (void) changeBoardTheme;

@end

@protocol LanguageSelector <NSObject>

- (void) changeLanguage;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) id <BoardThemeSelector> themeSelectorDelegate;
@property (nonatomic, assign) id <LanguageSelector> languageSelectorDelegate;


@end

