//
//  LocalizationUnitTest.m
//  LocalizationUnitTest
//
//  Created by Oliver Drobnik on 19.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "LocalizationUnitTest.h"

#import "DTLocalizableStringAggregator.h"
#import "DTLocalizableStringsParser.h"
#import "DTLocalizableStringTable.h"

@interface LocalizationUnitTest () <DTLocalizableStringsParserDelegate>

@end


@implementation LocalizationUnitTest
{
    DTLocalizableStringTable *_localizableTable;
    
    NSMutableDictionary *_currentTestedStringFileDictionary;
}

/**
 Determines the main project path during runtime
 */
- (NSString *)_projectPath
{
    NSString *pathOfFolderOfCurrentSourceFile = [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] stringByDeletingLastPathComponent];
    
    NSString *currentPath = [pathOfFolderOfCurrentSourceFile copy];
    
    BOOL foundIt = NO;
    
    do
    {
        NSString *testPath = [currentPath stringByAppendingPathComponent:@"LocalizationDemo.xcodeproj"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:testPath])
        {
            // found it
            foundIt = YES;
            break;
        }
        
        if ([currentPath isEqualToString:@"/"])
        {
            // cannot go further up
            break;
        }
        
        currentPath = [currentPath stringByDeletingLastPathComponent];
    } while ([currentPath length]);
    
    
    if (!foundIt)
    {
        return nil;
    }
    
    return currentPath;
}

/**
 Creates a list of all source file URLs at this project path
 */
- (NSArray *)_sourceFilesAtProjectPath:(NSString *)projectPath
{
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    NSArray *keys = @[NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtURL:[NSURL fileURLWithPath:projectPath]
                                         includingPropertiesForKeys:keys
                                         options:(NSDirectoryEnumerationSkipsPackageDescendants
                                                  | NSDirectoryEnumerationSkipsHiddenFiles)
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             STFail(@"%@", [error localizedDescription]);
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return NO;
                                         }];
    
    // enumerator goes into depth too!
    for (NSURL *url in enumerator)
    {
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        if (![isDirectory boolValue])
        {
            if ([[[url path] pathExtension] isEqualToString:@"m"])
            {
                [tmpArray addObject:[url path]];
            }
        }
    }
    
    return [tmpArray copy];
}

/**
 Builds up the string table of entries that require localization
 */
- (void)_scanSourceCodeFiles:(NSArray *)sourceCodePaths
{
    // create the aggregator
    DTLocalizableStringAggregator *localizableStringAggregator = [[DTLocalizableStringAggregator alloc] init];

    // feed all source files to the aggregator
    for (NSString *oneFile in sourceCodePaths)
    {
        NSURL *URL = [NSURL fileURLWithPath:oneFile];
        [localizableStringAggregator beginProcessingFile:URL];
    }
    
    // wait for completion
    NSArray *stringTables = [localizableStringAggregator aggregatedStringTables];
    
    STAssertTrue([stringTables count]==1, @"Only one string table supported");
    
    _localizableTable = [stringTables lastObject];
}


- (void)setUp
{
    [super setUp];
    
    // get the project folder
    NSString *projectFolder = [self _projectPath];

    // gets file URLs for all the 
    NSArray *sourceFiles = [self _sourceFilesAtProjectPath:projectFolder];
    
    // scans the source files and adds the resulting to the string table
    [self _scanSourceCodeFiles:sourceFiles];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)_testMissingLocalizationsForStringsFileAtPath:(NSString *)path
{
    // copy the macro strings into a lookup dictionary for this test
    _currentTestedStringFileDictionary = [[NSMutableDictionary alloc] init];
    
    // transfer entries to dictionary
    for (DTLocalizableStringEntry *oneEntry in _localizableTable.entries)
    {
        NSCharacterSet *quoteSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        NSString *key = [[oneEntry cleanedKey] stringByTrimmingCharactersInSet:quoteSet];
        NSString *value = [[oneEntry cleanedValue] stringByTrimmingCharactersInSet:quoteSet];
        
        [_currentTestedStringFileDictionary setObject:value forKey:key];
    }
    
    // create URL for Localizable.string to test
    NSURL *stringsFileURL = [NSURL fileURLWithPath:path];
    
    // parse the strings file, this emits a parser:foundKey:value: for each token.
    // These encountered tokens we remove from the dictionary
    DTLocalizableStringsParser *parser = [[DTLocalizableStringsParser alloc] initWithFileURL:stringsFileURL];
    parser.delegate = self;
    
    STAssertTrue([parser parse], @"Failed to parse: %@", parser.parseError);
    
    // any left over tokens are missing localizations
    [_currentTestedStringFileDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        BOOL isNoPlaceholder = ([obj rangeOfString:@"_"].length==0);
        STAssertTrue(isNoPlaceholder, @"Key %@ is not localized and is probably a placeholder", key);
    }];
}


- (void)testGermanStrings
{
    NSString *stringsPath = [[self _projectPath] stringByAppendingPathComponent:
                             @"LocalizationDemo/de.lproj/Localizable.strings"];
   
    [self _testMissingLocalizationsForStringsFileAtPath:stringsPath];
}

- (void)testEnglishStrings
{
    NSString *stringsPath = [[self _projectPath] stringByAppendingPathComponent:
                             @"LocalizationDemo/en.lproj/Localizable.strings"];
    
    [self _testMissingLocalizationsForStringsFileAtPath:stringsPath];
}

#pragma mark - DTLocalizableStringsParserDelegate

- (void)parser:(DTLocalizableStringsParser *)parser foundKey:(NSString *)key value:(NSString *)value
{
    [_currentTestedStringFileDictionary removeObjectForKey:key];
}

@end
