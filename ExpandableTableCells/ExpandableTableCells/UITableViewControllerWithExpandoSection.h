//
//  UITableViewControllerWithExpandoSection.h
//  ExpandableTableCells
//
//  Created by Oliver Drobnik on 12.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewControllerWithExpandoSection : UITableViewController
{
    NSMutableIndexSet *expandedSections;
}

@end
