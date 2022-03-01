//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import SRGLogger

/**
 *  Log a given message at the verbose level.
 */
public func SRGLogVerbose(subsystem: String?, category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogger.logMessage({ () -> String in
        return message
    }, level: SRGLogLevel.verbose, subsystem: subsystem, category: category, file: file, function: function, line: line)
}

/**
 *  Log a given message at the debug level.
 */
public func SRGLogDebug(subsystem: String?, category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogger.logMessage({ () -> String in
        return message
    }, level: SRGLogLevel.debug, subsystem: subsystem, category: category, file: file, function: function, line: line)
}

/**
 *  Log a given message at the info level.
 */
public func SRGLogInfo(subsystem: String?, category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogger.logMessage({ () -> String in
        return message
    }, level: SRGLogLevel.info, subsystem: subsystem, category: category, file: file, function: function, line: line)
}

/**
 *  Log a given message at the warning level.
 */
public func SRGLogWarning(subsystem: String?, category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogger.logMessage({ () -> String in
        return message
    }, level: SRGLogLevel.warning, subsystem: subsystem, category: category, file: file, function: function, line: line)
}

/**
 *  Log a given message at the error level.
 */
public func SRGLogError(subsystem: String?, category: String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogger.logMessage({ () -> String in
        return message
    }, level: SRGLogLevel.error, subsystem: subsystem, category: category, file: file, function: function, line: line)
}
