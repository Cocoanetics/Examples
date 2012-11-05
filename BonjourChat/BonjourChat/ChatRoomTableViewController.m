//
//  ChatRoomTableViewController.m
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "ChatRoomTableViewController.h"
#import "RoomCreationViewController.h"
#import "BonjourChatServer.h"
#import "ChatTableViewController.h"

@interface ChatRoomTableViewController() <RoomCreationViewControllerDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@end


@implementation ChatRoomTableViewController
{
	NSMutableSet *_unidentifiedServices;
	NSMutableArray *_foundServices;
	NSMutableArray *_createdRooms;
	NSNetServiceBrowser *_serviceBrowser;
}

- (void)awakeFromNib
{
	_foundServices = [[NSMutableArray alloc] init];
	_createdRooms = [[NSMutableArray alloc] init];
	_unidentifiedServices = [[NSMutableSet alloc] init];
	
	
	_serviceBrowser = [[NSNetServiceBrowser alloc] init];
	_serviceBrowser.delegate = self;
	[_serviceBrowser searchForServicesOfType:@"_BonjourChatDemo._tcp." inDomain:@""];
}

- (BOOL)_isLocalServiceIdentifier:(NSString *)identifier
{
	for (BonjourChatServer *server in _createdRooms)
	{
		if ([server.identifier isEqualToString:identifier])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)_updateFoundServices
{
	BOOL didUpdate = NO;
	
	for (NSNetService *service in [_unidentifiedServices copy])
	{
		NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
		
		if (!dict)
		{
			continue;
		}
		
		NSString *identifier = [[NSString alloc] initWithData:dict[@"ID"] encoding:NSUTF8StringEncoding];
		
		if (![self _isLocalServiceIdentifier:identifier])
		{
			[_foundServices addObject:service];
			didUpdate = YES;
		}
		
		[_unidentifiedServices removeObject:service];
	}
	
	if (didUpdate)
	{
		[self.tableView reloadData];
	}
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"CreateChatRoom"])
	{
		RoomCreationViewController *destination = (RoomCreationViewController *)[[segue destinationViewController] topViewController];
		
		destination.delegate = self;
	}
	else 	if ([[segue identifier] isEqualToString:@"ChatRoom"])
	{
		ChatTableViewController *destination = (ChatTableViewController *)[segue destinationViewController];
		
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		
		if (indexPath.section==0)
		{
			// own server
			destination.chatRoom = _createdRooms[indexPath.row];
		}
		else
		{
			// other person's server
			destination.chatRoom = _foundServices[indexPath.row];
		}
	}
}

#pragma mark - NetServiceBrowser Delegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
			  didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	aNetService.delegate = self;
	[aNetService startMonitoring];
	
	[_unidentifiedServices addObject:aNetService];
	
	NSLog(@"found: %@", aNetService);
	
	if (!moreComing)
	{
		[self _updateFoundServices];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
			didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	[_foundServices removeObject:aNetService];
	[_unidentifiedServices removeObject:aNetService];
	
	NSLog(@"removed: %@", aNetService);
	
	if (!moreComing)
	{
		[self.tableView reloadData];
	}
}

#pragma mark - NSNetService Delegate
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
	[self _updateFoundServices];
	
	[sender stopMonitoring];
}

#pragma mark - RoomCreationTableViewController Delegate

- (void)roomCreationViewControllerDidSave:(RoomCreationViewController *)roomCreationViewController
{
	BonjourChatServer *newServer = [[BonjourChatServer alloc] initWithRoomName:roomCreationViewController.roomNameField.text];
	[_createdRooms addObject:newServer];
	[newServer start];
	
	[self.tableView reloadData];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)roomCreationViewControllerDidCancel:(RoomCreationViewController *)roomCreationViewController
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView Delegate / Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return @"My Rooms";
	}
	
	return @"Other People's Rooms";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
		return [_createdRooms count];
	}
	
	return [_foundServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCell"];
	
	if (indexPath.section == 0)
	{
		BonjourChatServer *server = _createdRooms[indexPath.row];
		cell.textLabel.text = server.roomName;
		cell.detailTextLabel.text = nil;
	}
	else
	{
		NSNetService *service = _foundServices[indexPath.row];
		
		NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
		NSString *roomName = [[NSString alloc] initWithData:dict[@"RoomName"] encoding:NSUTF8StringEncoding];
		cell.textLabel.text = roomName;
		cell.detailTextLabel.text = [service name];
	}
	
	return cell;
}


@end
