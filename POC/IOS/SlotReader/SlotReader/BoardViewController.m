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
	
	colorShemesCollection = [[NSArray alloc] initWithObjects: greenScheme, lightScheme , darkScheme, nil];
	
	return self;
}

- (void) drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	NSInteger colorScheme = [[[NSUserDefaults standardUserDefaults] objectForKey:@"colorScheme"] integerValue];
    [self setBoardColorScheme:colorScheme];
	}

- (void) setBoardColorScheme:(ColorScheme)colorScheme {
    self.boardImage.image = [UIImage imageNamed:[[colorShemesCollection objectAtIndex:colorScheme] objectForKey:[NSString stringWithFormat:@"%d", board]]];
    [self.prevButton setImage:[UIImage imageNamed:[[colorShemesCollection objectAtIndex:colorScheme] objectForKey:[NSString stringWithFormat:@"%d", prevButton]]] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:[[colorShemesCollection objectAtIndex:colorScheme] objectForKey:[NSString stringWithFormat:@"%d", nextButton]]] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

@end
