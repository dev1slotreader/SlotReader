//
//  AppDelegate.m
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "AppDelegate.h"
#import "DataMiner.h"

typedef enum {
	green,
	light,
	dark
} ColorScheme;

@interface AppDelegate () {
	NSUserDefaults *defaults;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	defaults = [NSUserDefaults standardUserDefaults];
	
	static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";
	if ([defaults boolForKey:hasRunAppOnceKey] == NO)
	{
		NSString *language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
		
		DataMiner *dataMiner = [DataMiner sharedDataMiner];
				
		NSArray *languagesArray = [dataMiner getLanguages];
		if ([languagesArray containsObject:language]) {
			[defaults setObject:language forKey:@"language"];
		}
		else {
			[defaults setObject:@"en" forKey:@"language"];
		}
		
		[defaults setObject:[NSNumber numberWithInt:green] forKey:@"colorScheme"];
		[defaults setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:0], nil] forKey:@"currentPositon"];
		
		
		[defaults synchronize];
		
		[defaults setBool:YES forKey:hasRunAppOnceKey];
	}
	
	[defaults addObserver:self forKeyPath:@"colorScheme" options:NSKeyValueObservingOptionNew context:nil];
	[defaults addObserver:self forKeyPath:@"language" options:NSKeyValueObservingOptionNew context:nil];
		
	return YES;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"colorScheme"] && (self.themeSelectorDelegate != nil)) {
		[self.themeSelectorDelegate changeBoardTheme];
	} else if ([keyPath isEqualToString:@"language"] && (self.languageSelectorDelegate != nil)) {
		[self.languageSelectorDelegate changeLanguage];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
