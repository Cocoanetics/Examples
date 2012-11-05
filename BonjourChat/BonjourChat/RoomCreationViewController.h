//
//  RoomCreationViewController.h
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomCreationViewController;

@protocol RoomCreationViewControllerDelegate <NSObject>

- (void)roomCreationViewControllerDidSave:(RoomCreationViewController *)roomCreationViewController;
- (void)roomCreationViewControllerDidCancel:(RoomCreationViewController *)roomCreationViewController;

@end

@interface RoomCreationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *roomNameField;
@property (nonatomic, weak) id <RoomCreationViewControllerDelegate> delegate;

@end
