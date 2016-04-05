//
//  BoardViewController.h
//  SlotReader
//
//  Created by User on 3/25/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	greenColorScheme,
	darkColorScheme,
	lightColorScheme,
} ColorScheme;

@interface BoardViewController : UIView{
	
}

- (void) setBoardColorScheme: (ColorScheme) colorScheme;

@end
