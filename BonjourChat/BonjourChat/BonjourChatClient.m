//
//  BonjourChatClient.m
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "BonjourChatClient.h"

@implementation BonjourChatClient

- (id)initWithService:(NSNetService *)service
{
	self = [super initWithService:service];
	
	if (self)
	{
		// assume that TXT data is already avaliable
		
		NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
		_roomName = [[NSString alloc] initWithData:dict[@"RoomName"] encoding:NSUTF8StringEncoding];
	}
	
	return self;
}

@end
