//
//  BoardViewController.m
//  SlotReader
//
//  Created by User on 3/25/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "BoardViewController.h"

enum {
	board,
	prevButton,
	nextButton,
	textColor
};

@interface BoardViewController () {
	NSArray *colorShemesCollection;
}

@end

@implementation BoardViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
	
// Settings for the color schemes of the board
	
	NSDictionary *greenScheme = [NSDictionary dictionaryWithObjectsAndKeys:
								@"Blackboard", [NSString stringWithFormat:@"%d", board],
								@"up", [NSString stringWithFormat:@"%d", prevButton],
								@"down", [NSString stringWithFormat:@"%d", nextButton],
								@"whiteColor", [NSString stringWithFormat:@"%d", textColor],nil];
	
	NSDictionary *darkScheme = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Blackboard-dark", [NSString stringWithFormat:@"%d", board],
								@"up", [NSString stringWithFormat:@"%d", prevButton],
								@"down", [NSString stringWithFormat:@"%d", nextButton],
								@"whiteColor", [NSString stringWithFormat:@"%d", textColor],nil];
	
	NSDictionary *lightScheme = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Blackboard-light", [NSString stringWithFormat:@"%d", board],
							   @"up-blue", [NSString stringWithFormat:@"%d", prevButton],
							   @"down-blue", [NSString stringWithFormat:@"%d", nextButton],
							   @"blueColor", [NSString stringWithFormat:@"%d", textColor],nil];
	
	colorShemesCollection = [[NSArray alloc] initWithObjects: greenScheme, darkScheme, lightScheme ,nil];
	
	return self;
}

- (void) drawRect:(CGRect)rect {
	NSNumber *colorScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorScheme"];
#warning set the styles here
	self.boardImage.image = [UIImage imageNamed:[[colorShemesCollection objectAtIndex:[colorScheme integerValue]] objectForKey:[NSString stringWithFormat:@"%d", board]]];
	self.prevButton.imageView.image = [UIImage imageNamed:[[colorShemesCollection objectAtIndex:[colorScheme integerValue]] objectForKey:[NSString stringWithFormat:@"%d", prevButton]]];
	self.nextButton.imageView.image = [UIImage imageNamed:[[colorShemesCollection objectAtIndex:[colorScheme integerValue]] objectForKey:[NSString stringWithFormat:@"%d", nextButton]]];
	
	[super drawRect:rect];
}


@end
