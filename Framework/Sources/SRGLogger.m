//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLogger.h"

#import "NSBundle+SRGLogger.h"

#import <os/log.h>

typedef NS_OPTIONS(NSUInteger, SRGLogger_DDLogFlag){
    SRGLogger_DDLogFlagError = (1 << 0),
    SRGLogger_DDLogFlagWarning = (1 << 1),
    SRGLogger_DDLogFlagInfo = (1 << 2),
    SRGLogger_DDLogFlagDebug = (1 << 3),
    SRGLogger_DDLogFlagVerbose = (1 << 4)
};

// DDLog interface
@protocol SRGLogger_DDLog

+ (void)log:(BOOL)asynchronous message:(NSString *)message level:(NSUInteger)level flag:(NSUInteger)flag context:(NSInteger)context file:(const char *)file function:(const char *)function line:(NSUInteger)line tag:(id)tag;

@end

static SRGLogHandler s_logHandler = nil;

static SRGLogHandler s_cocoaLumberjackHandler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
{
    NSUInteger flag;
    
    switch (level) {
        case SRGLogLevelVerbose: {
            flag = SRGLogger_DDLogFlagVerbose;
            break;
        }
            
        case SRGLogLevelDebug: {
            flag = SRGLogger_DDLogFlagDebug;
            break;
        }
            
        case SRGLogLevelInfo: {
            flag = SRGLogger_DDLogFlagInfo;
            break;
        }
            
        case SRGLogLevelWarning: {
            flag = SRGLogger_DDLogFlagWarning;
            break;
        }
            
        case SRGLogLevelError: {
            flag = SRGLogger_DDLogFlagError;
            break;
        }
    }
    
    [NSClassFromString(@"DDLog") log:YES message:message() level:NSUIntegerMax flag:flag context:0 file:file function:function line:line tag:nil];
};

static SRGLogHandler s_unifiedLoggingHandler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
{
    os_log_type_t type;
    
    switch (level) {
        case SRGLogLevelVerbose: {
            type = OS_LOG_TYPE_DEBUG;
            break;
        }
            
        case SRGLogLevelDebug: {
            type = OS_LOG_TYPE_DEBUG;
            break;
        }
            
        case SRGLogLevelInfo: {
            type = OS_LOG_TYPE_INFO;
            break;
        }
            
        case SRGLogLevelWarning: {
            type = OS_LOG_TYPE_DEFAULT;
            break;
        }
            
        case SRGLogLevelError: {
            type = OS_LOG_TYPE_ERROR;
            break;
        }
    }
    
    os_log_t log = os_log_create(subsystem.UTF8String, category.UTF8String);
    os_log_with_type(log, type, "%@", message());
};

static SRGLogHandler s_NSLogHandler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
{
    if (level == SRGLogLevelError || level == SRGLogLevelWarning) {
        if (subsystem && category) {
            NSLog(@"[%@|%@] %@", subsystem, category, message());
        }
        else if (subsystem) {
            NSLog(@"[%@] %@", subsystem, message());
        }
        else if (category) {
            NSLog(@"(%@) %@", category, message());
        }
        else {
            NSLog(@"%@", message());
        }
    }
};

@implementation SRGLogger

+ (SRGLogHandler)setLogHandler:(SRGLogHandler)logHandler
{
    SRGLogHandler previousHandler = s_logHandler;
    s_logHandler = logHandler;
    return previousHandler;
}

+ (void)logMessage:(NSString * (^)(void))message
             level:(SRGLogLevel)level
         subsystem:(NSString * const)subsystem
          category:(NSString * const)category
              file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
{
    s_logHandler ? s_logHandler(message, level, subsystem, category, file, function, line) : nil;
}

@end

__attribute__((constructor)) static void SRGLoggerInit(void)
{
    if (NSClassFromString(@"DDLog")) {
        s_logHandler = s_cocoaLumberjackHandler;
    }
    else if (os_log_type_enabled != NULL) {
        s_logHandler = s_unifiedLoggingHandler;
    }
    else {
        s_logHandler = s_NSLogHandler;
    }
}

NSString *SRGLoggerMarketingVersion(void)
{
    return [NSBundle srg_loggerBundle].infoDictionary[@"CFBundleShortVersionString"];
}

