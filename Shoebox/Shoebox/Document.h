//
//  Document.h
//  Shoebox
//
//  Created by Oliver Drobnik on 9/19/12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DocumentItem;

@interface Document : NSDocument

@property (nonatomic, strong) NSMutableArray *items;
@property (weak) IBOutlet NSCollectionView *collectionView;

- (NSImage *)thumbnailImageForName:(NSString *)fileName;
- (NSURL *)URLforTemporaryCopyOfFile:(NSString *)fileName;
- (NSUInteger)indexOfItem:(DocumentItem *)item;

@end
