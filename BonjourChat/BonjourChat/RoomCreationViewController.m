//
//  RoomCreationViewController.m
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "RoomCreationViewController.h"


@implementation RoomCreationViewController

- (void)viewDidAppear:(BOOL)animated
{
	[self.roomNameField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate roomCreationViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender
{
	[self.delegate roomCreationViewControllerDidSave:self];
}

#pragma mark - UITextField Delegate

- (IBAction)textFieldChanged:(id)sender
{
	self.navigationItem.rightBarButtonItem.enabled = ([self.roomNameField.text length]>0);
}


@end
