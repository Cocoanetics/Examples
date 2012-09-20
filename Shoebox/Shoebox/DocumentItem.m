#import "DocumentItem.h"
#import "Document.h"

@implementation DocumentItem

- (NSImage *)thumbnailImage
{
	return [self.document thumbnailImageForName:self.fileName];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	if (self)
	{
		self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.fileName forKey:@"fileName"];
}

#pragma mark NSPasteboardWriting
- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
	// support sending of index for local and file URL for external dragging
	return [NSArray arrayWithObjects:@"com.drobnik.shoebox.item", kUTTypeFileURL, nil];
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
	if ([type isEqualToString:@"com.drobnik.shoebox.item"])
	{
		// get index from Document
		NSUInteger index = [self.document indexOfItem:self];
		
		// simplicty: just put the item index in a string
		return [NSString stringWithFormat:@"%ld", index];
	}
	
	if ([type isEqualToString:(NSString *)kUTTypeFileURL])
	{
		NSURL *URL = [self.document URLforTemporaryCopyOfFile:self.fileName];
		
		return [URL pasteboardPropertyListForType:(id)kUTTypeFileURL];
	}
	
	return nil;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
	return 0; // all types immediately written
}


@synthesize fileName;
@synthesize document;

@end
