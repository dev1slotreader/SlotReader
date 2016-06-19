//
//  LanguageHelper.h
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 13.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageHelper : NSObject

- (NSArray *) getAllTheLanguages;
- (NSArray *) getAllTheLanguagesNames;
- (NSString *) getCurrentLanguage;
- (void) setCurrentLanguage: (NSString *) newLanguage;

@end
