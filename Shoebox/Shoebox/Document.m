//
//  Document.m
//  Shoebox
//
//  Created by Oliver Drobnik on 9/19/12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

#import "Document.h"
#import "DocumentItem.h"

@implementation Document
{
	NSFileWrapper *_fileWrapper;
	NSMutableArray *_items;
}

- (id)init
{
    self = [super init];
    if (self)
	{
		// start out with an empty array
		_items = [[NSMutableArray alloc] init];
		
		// start with an empty file wrapper
		_fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
	
	// register types that we accept
    NSArray *supportedTypes = [NSArray arrayWithObjects:@"com.drobnik.shoebox.item", NSFilenamesPboardType, nil];
    [self.collectionView registerForDraggedTypes:supportedTypes];
	
	// from external we always add
	[self.collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
	
	// from internal we always move
	[self.collectionView setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError
{
	if (![fileWrapper isDirectory])
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Illegal Document Format" forKey:NSLocalizedDescriptionKey];
		*outError = [NSError errorWithDomain:@"Shoebox" code:1 userInfo:userInfo];
		return NO;
	}
	
	// store reference for later image access
	_fileWrapper = fileWrapper;

	// decode the index
	NSFileWrapper *indexWrapper = [fileWrapper.fileWrappers objectForKey:@"index.plist"];
	NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:indexWrapper.regularFileContents];
	
	// set document property for all items
	[array makeObjectsPerformSelector:@selector(setDocument:) withObject:self];
	
	// set the property
	self.items = [array mutableCopy];

	// YES because of successful reading
	return YES;
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
	// this holds the files to be added
	NSMutableDictionary *files = [NSMutableDictionary dictionary];
	
	// encode the index
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.items];
	NSFileWrapper *indexWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
	
	// add it to the files
	[files setObject:indexWrapper forKey:@"index.plist"];
	
	// copy all other referenced files too
	for (DocumentItem *oneItem in self.items)
	{
		NSString *fileName = oneItem.fileName;
		NSFileWrapper *existingFile = [_fileWrapper.fileWrappers objectForKey:fileName];
		[files setObject:existingFile forKey:fileName];
	}
	
	// create a new fileWrapper for the bundle
	NSFileWrapper *newWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:files];
	
	return newWrapper;
}

- (NSImage *)thumbnailImageForName:(NSString *)fileName
{
	// get the correct fileWrapper for the image
	NSFileWrapper *fileWrapper = [_fileWrapper.fileWrappers objectForKey:fileName];
	
	// create an image
	NSImage *image = [[NSImage alloc] initWithData:fileWrapper.regularFileContents];
	return image;
}

- (NSUInteger)indexOfItem:(DocumentItem *)item
{
	return [self.items indexOfObject:item];
}

- (NSURL *)URLforTemporaryCopyOfFile:(NSString *)fileName
{
	// get the correct fileWrapper for the image
	NSFileWrapper *fileWrapper = [_fileWrapper.fileWrappers objectForKey:fileName];
	
	// temp file name
	NSString *tmpFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
	
	// write it there
	[fileWrapper.regularFileContents writeToFile:tmpFileName atomically:NO];
	
	return [NSURL fileURLWithPath:tmpFileName];
}

#pragma mark Drag/Drop

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
	if (!draggingInfo.draggingSource)
	{
		// comes from external
		return NSDragOperationCopy;
	}

	// comes from internal
	return NSDragOperationMove;
}

- (void)insertFiles:(NSArray *)files atIndex:(NSInteger)index
{
	NSMutableArray *insertedObjects = [NSMutableArray array];
	
	for (NSURL *URL in files)
	{
		// add file to our bundle
		[_fileWrapper addFileWithPath:[URL path]];
		
		// create model object for it
		DocumentItem *newItem = [[DocumentItem alloc] init];
		newItem.fileName = [[URL path] lastPathComponent];
		newItem.document = self;
		
		// add to our items
		[insertedObjects addObject:newItem];
	}
	
	// send KVO message so that the array controller updates itself
	[self willChangeValueForKey:@"items"];
	
	for (DocumentItem *oneItem in insertedObjects)
	{
		[self.items insertObject:oneItem atIndex:index];
		index++;
	}
	
	[self didChangeValueForKey:@"items"];
	
	// mark document as dirty
	[self updateChangeCount:NSChangeDone];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id < NSDraggingInfo >)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
{
	NSPasteboard *pasteboard = [draggingInfo draggingPasteboard];
	
	if ([pasteboard.types containsObject:@"com.drobnik.shoebox.item"])
	{
		// internal drag, an array of indexes
		
		NSMutableArray *draggedItems = [NSMutableArray array];
		NSMutableIndexSet *draggedIndexes = [NSMutableIndexSet indexSet];
		
		for (NSPasteboardItem *oneItem in [pasteboard pasteboardItems])
		{
			NSUInteger itemIndex = [[oneItem stringForType:@"com.drobnik.shoebox.item"] integerValue];
			[draggedIndexes addIndex:itemIndex];

			// removing items before insertion reduces it
			if (index>itemIndex)
			{
				index--;
			}
			
			DocumentItem *item = [self.items objectAtIndex:itemIndex];
			[draggedItems addObject:item];
		}
		
		[self willChangeValueForKey:@"items"];
		[self.items removeObjectsAtIndexes:draggedIndexes];
		
		for (DocumentItem *oneItem in draggedItems)
		{
			[self.items insertObject:oneItem atIndex:index];
		}
		
		[self didChangeValueForKey:@"items"];
		
		// mark document as dirty
		[self updateChangeCount:NSChangeDone];
		
		return YES;
	}

	
	// drop from external, list of file URLs
	NSMutableArray *files = [NSMutableArray array];
	
	for (NSPasteboardItem *oneItem in [pasteboard pasteboardItems])
	{
		NSString *urlString = [oneItem stringForType:(id)kUTTypeFileURL];
		NSURL *URL = [NSURL URLWithString:urlString];
		
		if (URL)
		{
			[files addObject:URL];
		}
	}
	
	if ([files count])
	{
		[self insertFiles:files atIndex:index];
	}
	
	// mark document as dirty
	[self updateChangeCount:NSChangeDone];

	return YES;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
{
	return YES;
}

- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSMutableArray *objects = [NSMutableArray array];
	
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
	 {
		 DocumentItem *item = [[cv content] objectAtIndex:idx];
		 
		 [objects addObject:item];
	 }];
	
    if (![objects count])
	{
		return NO;
	}

	[pasteboard clearContents];
		
    return [pasteboard writeObjects:objects];
}

#pragma mark Properties

@synthesize items = _items;

@end
