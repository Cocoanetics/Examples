//
//  DTAppDelegate.h
//  threedee2
//
//  Created by Oliver Drobnik on 11.08.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTViewController;

@interface DTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DTViewController *viewController;

@end
