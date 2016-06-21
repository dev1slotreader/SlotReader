//
//  AppDelegate.m
//  SwissPlanner
//
//  Created by User on 4/10/16.
//  Copyright © 2016 Elena Boychuk. All rights reserved.
//

#import "AppDelegate.h"
#import "LanguageHelper.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[NSThread sleepForTimeInterval:3.0];
	[self.window setTintColor:[UIColor whiteColor]];
	
	[[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor blackColor]];
    
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    if ([version isEqualToString:@"1.4"] ) {
        //if new version of the app
        //Clean user defaults
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce1"])
        {
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //[[NSUserDefaults standardUserDefaults] setObject:version forKey:@"appVersion"];
    }

	
    NSString * language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    LanguageHelper *helper = [[LanguageHelper alloc] init];
	//[helper setCurrentLanguage:language];
    NSLog(@"%@", [helper getCurrentLanguage]);
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:language forKey:@"currentLanguage"];
	
	
		
	
	return YES;
}

/*
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	return UIInterfaceOrientationMaskAll;
}*/

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
