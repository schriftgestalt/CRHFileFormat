//
//  testCHR.m
//  testCHR
//
//  Created by Georg Seifert on 08.04.18.
//  Copyright © 2018 Georg Seifert. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CRHFileFormat.h"

@interface testCHR : XCTestCase

@end

@implementation testCHR

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSURL* testFile = [bundle URLForResource:@"BOLD" withExtension:@"CHR"];
	GlyphsFileFormatCRHFileFormat* plugin = [GlyphsFileFormatCRHFileFormat new];
	NSError* error;
	GSFont* font = [plugin fontFromURL:testFile ofType:@"" error:&error];
	XCTAssertNotNil(font);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
