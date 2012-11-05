//
//  BonjourChatServer.m
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "BonjourChatServer.h"
#import "NSString+DTUtilities.h"
#import "DTBonjourDataConnection.h"

@implementation BonjourChatServer
{
	NSString *_roomName;
	NSString *_identifier;
}

- (id)initWithRoomName:(NSString *)roomName
{
	self = [super initWithBonjourType:@"_BonjourChatDemo._tcp."];
	
	if (self)
	{
		_roomName = [roomName copy];
		
		_identifier = [NSString stringWithUUID];

		[self _updateTXTRecord];
	}
	
	return self;
}

- (void)_updateTXTRecord
{
	self.TXTRecord = @{@"ID" : [_identifier dataUsingEncoding:NSUTF8StringEncoding], @"RoomName" : [_roomName dataUsingEncoding:NSUTF8StringEncoding]};
}

- (void)connection:(DTBonjourDataConnection *)connection didReceiveObject:(id)object
{
	// need to call super because this forwards the object to the server delegate
	[super connection:connection didReceiveObject:object];
	
	// we need to pass the object to all other connections so that they also see the messages
	for (DTBonjourDataConnection *oneConnection in self.connections)
	{
		if (oneConnection!=connection)
		{
			[oneConnection sendObject:object error:NULL];
		}
	}
}

@end
