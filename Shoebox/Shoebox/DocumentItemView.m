//
//  DocumentCollectionItemView.m
//  Shoebox
//
//  Created by Oliver Drobnik on 9/20/12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

#import "DocumentItemView.h"

@implementation DocumentItemView
{
	BOOL _selected;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
	NSRect drawRect = NSInsetRect(self.bounds, 5, 5);
	
	if (self.selected)
	{
		[[NSColor blueColor] set];
		[NSBezierPath strokeRect:drawRect];
	}
}

#pragma mark Properties

- (void)setSelected:(BOOL)selected
{
	_selected = selected;
	[self setNeedsDisplay:YES];
}

@synthesize selected = _selected;

@end
