[![SRG Logger logo](README-images/logo.png)](https://github.com/SRGSSR/srglogger-apple)

[![GitHub releases](https://img.shields.io/github/v/release/SRGSSR/srglogger-apple)](https://github.com/SRGSSR/srglogger-apple/releases) [![platform](https://img.shields.io/badge/platfom-ios%20%7C%20tvos%20%7C%20watchos-blue)](https://github.com/SRGSSR/srglogger-apple) [![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager) [![Build Status](https://travis-ci.org/SRGSSR/srglogger-apple.svg?branch=master)](https://travis-ci.org/SRGSSR/srglogger-apple/branches) [![GitHub license](https://img.shields.io/github/license/SRGSSR/srglogger-apple)](https://github.com/SRGSSR/srglogger-apple/blob/master/LICENSE)

## About

The SRG Logger library provides a simple way to unify logging between SRG SSR libraries and applications, but can be used by any other application or library as well.

Five logging levels are available, which should match most needs:

* `Verbose` for detailed technical information.
* `Debug` for debugging information.
* `Info` for information that may be helpful for troubleshooting errors.
* `Warning` for information about conditions which might lead to a failure.
* `Error` for information about failures.

The library automatically bridges with standard logging frameworks, in the following order:

* If your project uses [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack), messages will be forwarded to it.
* If your project can use [Apple unified logging](https://developer.apple.com/reference/os/1891852-logging), available starting from iOS 10, tvOS 10 and watchOS 3, messages will be forwarded to the system console.

If neither is available, no logging will take place. You can install a verbose `NSLog` based logger, provided as well, if you need a quick way to setup logging (this logger logs all messages and can slow down your application).

The library does not provide any logging to [NSLogger](https://github.com/fpillet/NSLogger). You can namely automatically bridge CocoaLumberjack into NSLogger using [Cédric Luthi's interface](https://github.com/0xced/XCDLumberjackNSLogger) between them.

## Compatibility

The library is suitable for applications running on iOS 9, tvOS 12, watchOS 5 and above. The project is meant to be compiled with the latest Xcode version.

## Contributing

If you want to contribute to the project, have a look at our [contributing guide](CONTRIBUTING.md).

## Integration

The library must be integrated using [Swift Package Manager](https://swift.org/package-manager) directly [within Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). You can also declare the library as a dependency of another one directly in the associated `Package.swift` manifest.

## Usage

When you want to use classes or functions provided by the library in your code, you must import it from your source files first. In Objective-C:

```objective-c
@import SRGLogger;
```

or in Swift:

```swift
import SRGLoggerSwift
```

## Logging messages

To log a message, simply call the macro corresponding to the desired level. In Objective-C:

```objective-c
SRGLogInfo(@"com.myapp", @"Weather", @"The temperature is %@", @(temperature));
```

or in Swift:

```swift
SRGLogInfo(subsystem: "com.myapp", category: "Weather", message: "The temperature is \(temperature)")
```

You can provide two optional arguments when logging a message:

* A subsystem, here `com.myapp`, which identifies the library or application you log from.
* A category, here `Weather`, which identifies which part of the code the log is related to.

To avoid specifiying the subsystem in your application or library each time you call the macro, you can define your own set of helpers which always set this value consistently, for example in Objective-C:

```objective-c
#define MyAppLogVerbose(category, format, ...) SRGLogVerbose(@"com.myapp", category, format, ##__VA_ARGS__)
#define MyAppLogDebug(category, format, ...)   SRGLogDebug(@"com.myapp", category, format, ##__VA_ARGS__)
#define MyAppLogInfo(category, format, ...)    SRGLogInfo(@"com.myapp", category, format, ##__VA_ARGS__)
#define MyAppLogWarning(category, format, ...) SRGLogWarning(@"com.myapp", category, format, ##__VA_ARGS__)
#define MyAppLogError(category, format, ...)   SRGLogError(@"com.myapp", category, format, ##__VA_ARGS__)
```

or in Swift:

```swift
func MyAppLogVerbose(category : String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogVerbose(subsystem: "com.myapp", category: category, message: message, file: file, function: function, line: line);
}

func MyAppLogDebug(category : String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogDebug(subsystem: "com.myapp", category: category, message: message, file: file, function: function, line: line);
}

func MyAppLogInfo(category : String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogInfo(subsystem: "com.myapp", category: category, message: message, file: file, function: function, line: line);
}

func MyAppLogWarning(category : String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogWarning(subsystem: "com.myapp", category: category, message: message, file: file, function: function, line: line);
}

func MyAppLogError(category : String?, message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    SRGLogError(subsystem: "com.myapp", category: category, message: message, file: file, function: function, line: line);
}
```

## Interfacing with other loggers

If the default log handler does not suit your needs (or if you simply want to inhibit logging), set a new handler to forward the messages and contextual information to your other logger. In Objective-C:

```objective-c
[SRGLogger setLogHandler:^(NSString * _Nonnull (^ _Nonnull message)(void), SRGLogLevel level, NSString *const  _Nullable subsystem, NSString *const  _Nullable category, const char * _Nonnull file, const char * _Nonnull function, NSUInteger line) {
    // Foward information to another logger
}];
```

or in Swift:

```swift
SRGLogger.setLogHandler { (message, level, subsystem, category, file, function, line) in
    // Foward information to another logger
}
```

## Thread-safety

Logging can be performed from any thread.

## Apple unified logging troubleshooting

If you are using Apple unified logging and do not see the logs:

1. Check that the scheme you use does not have the `OS_ACTIVITY_MODE` environment variable set to `disable`, or `OS_ACTIVITY_DT_MODE` set to `NO`.
1. If you do not see lower level logs in the `Console.app`, ensure that the items _Include Info Messages_ and `Include Debug Messages` are checked in the console `Action` menu. If these options are grayed out, try updating the logging configuration for your subsystem first by running the following command from a terminal:

	```
	$ sudo log config --mode "level:debug" --subsystem <subsystem>
	```
	
1. Use the search to locate entries for your application name, and right-click on an entry to filter by application, subsystem or category
1. Read the [official documentation](https://developer.apple.com/documentation/os/logging) if you still have issues

## Credits

This logger implementation is heavily based on [a Cédric Luthi's Stack Overflow post](http://stackoverflow.com/questions/34732814/how-should-i-handle-logs-in-an-objective-c-library/34732815#).

## License

See the [LICENSE](../LICENSE) file for more information.
