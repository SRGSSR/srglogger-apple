//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import SRGLoggerSwift
import XCTest

func TestLogError(category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogError(subsystem: "ch.srgssr.logger-tests", category: category, message: message, file: file, function: function, line: line);
}

class LoggerSwiftTestCase: XCTestCase 
    func testLogging() {
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error!")
        SRGLogWarning(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Warning!")
        
        let string = "Hello, World!"
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error with string '\(string)'")
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error with dictionary \([ "key" : "value" ])")
        
        TestLogError(category: "Test-Swift", message: "Error!")
    }
}
