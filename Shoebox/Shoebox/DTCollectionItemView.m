//
//  DTCollectionItemView.m
//  Shoebox
//
//  Created by Oliver Drobnik on 9/20/12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

#import "DTCollectionItemView.h"
#import "DocumentItemView.h"

@implementation DTCollectionItemView

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
	
	// forward selection to the prototype view
	[(DocumentItemView *)self.view setSelected:selected];
}

@end
