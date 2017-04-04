//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGLogger/SRGLogger.h>
#import <XCTest/XCTest.h>

#define TestLogError(category, format, ...)   SRGLogError(@"ch.srgssr.logger-tests", category, format, ##__VA_ARGS__)

@interface LoggerTestCase : XCTestCase

@end

@implementation LoggerTestCase

- (void)testLogging
{
    SRGLogError(@"ch.srgssr.logger-tests", @"Test", @"Error!");
    SRGLogWarning(@"ch.srgssr.logger-tests", @"Test", @"Warning!");
    
    NSString *string = @"Hello, World!";
    SRGLogError(@"ch.srgssr.logger-tests", @"Test", @"Error with string '%@'", string);
    SRGLogError(@"ch.srgssr.logger-tests", @"Test", @"Error with dictionary %@", @{ @"key" : @"value" });
    
    TestLogError(@"Test", @"Error!");
}

@end
