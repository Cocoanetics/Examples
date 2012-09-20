//
//  DocumentItem.h
//  Shoebox
//
//  Created by Oliver Drobnik on 9/19/12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

@class Document;

@interface DocumentItem : NSObject <NSCoding, NSPasteboardWriting>

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, weak) Document *document;

- (NSImage *)thumbnailImage;

@end
