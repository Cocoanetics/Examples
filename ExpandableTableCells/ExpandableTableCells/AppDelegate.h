//
//  AppDelegate.h
//  ExpandableTableCells
//
//  Created by Oliver Drobnik on 12.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewControllerWithExpandoSection;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITableViewControllerWithExpandoSection *viewController;

@end
