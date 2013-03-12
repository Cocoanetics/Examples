//
//  UnitTest.m
//  UnitTest
//
//  Created by Oliver Drobnik on 3/6/13.
//
//

#import "UnitTest.h"
#import "NSObject+DTRuntime.h"

@implementation UnitTest


+ (void)initialize
{
	// Load test case list
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestCases" ofType:@"plist"];
	NSArray *testCases = [NSArray arrayWithContentsOfFile:path];
	
	for (NSString *oneCase in testCases)
	{
		// prepend test_ so that it gets found by introspection
		NSString *selectorName = [@"test_" stringByAppendingString:oneCase];
		
		[UnitTest addInstanceMethodWithSelectorName:selectorName block:^(UnitTest *myself) {
			[myself internalTestCase:oneCase];
		}];
	}
}

- (void)internalTestCase:(NSString *)testCase
{
	// this performs the actual test
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// traditional static test
- (void)testExample
{
	// no fail = success
}

@end
