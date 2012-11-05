//
//  ChatTableViewController.m
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "ChatTableViewController.h"
#import "BonjourChatServer.h"
#import "BonjourChatClient.h"
#import "DTBonjourDataConnection.h"

@interface ChatTableViewController () <DTBonjourDataConnectionDelegate, DTBonjourServerDelegate>

@end

@implementation ChatTableViewController
{
	BonjourChatServer *_server;
	BonjourChatClient *_client;
	
	NSMutableArray *_messages;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
	_messages = [[NSMutableArray alloc] init];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(keyboardDidShow:)
						name:UIKeyboardDidShowNotification object:nil];
	[center addObserver:self selector:@selector(keyboardWillHide:)
						name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	if ([self.chatRoom isKindOfClass:[BonjourChatServer class]])
	{
		_server = self.chatRoom;
		_server.delegate = self;
		self.navigationItem.title = _server.roomName;
	}
	else if ([self.chatRoom isKindOfClass:[NSNetService class]])
	{
		NSNetService *service = self.chatRoom;
		
		_client = [[BonjourChatClient alloc] initWithService:service];
		_client.delegate = self;
		[_client open];
		
		self.navigationItem.title = _client.roomName;
	}
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (_server)
	{
		[_server broadcastObject:textField.text];
	}
	else if (_client)
	{
		NSError *error;
		if (![_client sendObject:textField.text error:&error])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			return NO;
		}
	}

	[_messages insertObject:textField.text atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
	
	textField.text = nil;
	
	return YES;
}

#pragma mark - DTBonjourServer Delegate (Server)

- (void)bonjourServer:(DTBonjourServer *)server didReceiveObject:(id)object onConnection:(DTBonjourDataConnection *)connection
{
	[_messages insertObject:object atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - DTBonjourConnection Delegate (Client)

- (void)connection:(DTBonjourDataConnection *)connection didReceiveObject:(id)object
{
	[_messages insertObject:object atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)connectionDidClose:(DTBonjourDataConnection *)connection
{
	if (connection == _client)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Room Closed" message:@"The Server has closed the room." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate / Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
		return 1;
	}
	
	return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
		return cell;
	}
	else
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
		cell.textLabel.font = [UIFont systemFontOfSize:14.0];
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.text = _messages[indexPath.row];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		return 70;
	}
	
	NSString *message = _messages[indexPath.row];
	
	// calculate ideal height
	CGSize neededSize = [message sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
	
	return neededSize.height+20;
}

#pragma mark - Notifications

- (void)keyboardWillHide:(NSNotification *)notification
{
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	// keyboard frame is in window coordinates
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	// convert own frame to window coordinates, frame is in superview's coordinates
	CGRect ownFrame = [self.view.window convertRect:self.view.frame fromView:self.view.superview];
	
	// calculate the area of own frame that is covered by keyboard
	CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);
	
	// now this might be rotated, so convert it back
	coveredFrame = [self.view.window convertRect:coveredFrame toView:self.view.superview];
	
	// set inset to make up for covered array at bottom
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, coveredFrame.size.height, 0);
	self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

@end
