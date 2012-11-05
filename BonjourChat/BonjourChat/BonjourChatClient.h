//
//  BonjourChatClient.h
//  BonjourChat
//
//  Created by Oliver Drobnik on 04.11.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "DTBonjourDataConnection.h"

@interface BonjourChatClient : DTBonjourDataConnection

@property (nonatomic, readonly) NSString *roomName;

@end
