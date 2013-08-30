//
//  TagCollectionViewCell.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)drawRect:(CGRect)rect
{
	// inset by half line width to avoid cropping where line touches frame edges
	CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/2.0];
	
	// white background
	[[UIColor whiteColor] setFill];
	[path fill];

	// red outline
	[[UIColor redColor] setStroke];
	[path stroke];
}

@end
