//
//  BonjourChatServer.h
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "DTBonjourServer.h"

@interface BonjourChatServer : DTBonjourServer

- (id)initWithRoomName:(NSString *)roomName;

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *roomName;

@end
