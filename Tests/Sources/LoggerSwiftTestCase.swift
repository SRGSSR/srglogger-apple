//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import SRGLogger_Swift
import XCTest

class LoggerSwiftTestCase : XCTestCase {

    internal func testLogging() -> Void {
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error!")
        SRGLogWarning(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Warning!")
        
        let string = "Hello, World!"
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error with string '\(string)'")
        SRGLogError(subsystem: "ch.srgssr.logger-tests", category: "Test-Swift", message: "Error with dictionary \([ "key" : "value" ])")
    }
}
