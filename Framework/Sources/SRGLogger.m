//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLogger.h"

#import "NSBundle+SRGLogger.h"

#import <os/log.h>

// DDLog levels
typedef NS_OPTIONS(NSUInteger, SRGLogger_DDLogFlag){
    SRGLogger_DDLogFlagError = (1 << 0),
    SRGLogger_DDLogFlagWarning = (1 << 1),
    SRGLogger_DDLogFlagInfo = (1 << 2),
    SRGLogger_DDLogFlagDebug = (1 << 3),
    SRGLogger_DDLogFlagVerbose = (1 << 4)
};

// DDLog interface excerpt
@protocol SRGLogger_DDLog

+ (void)log:(BOOL)asynchronous message:(NSString *)message level:(NSUInteger)level flag:(NSUInteger)flag context:(NSInteger)context file:(const char *)file function:(const char *)function line:(NSUInteger)line tag:(id)tag;

@end

static SRGLogHandler s_logHandler = nil;

SRGLogHandler SRGCocoaLumberjackHandler(void)
{
    static SRGLogHandler s_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NSClassFromString(@"DDLog")) {
            s_handler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line) {
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
                
                // Display the subsystem and the category directly in the message
                NSString *fullMessage = nil;
                if (subsystem && category) {
                    fullMessage = [NSString stringWithFormat:@"(%@|%@) %@", subsystem, category, message()];
                }
                else if (subsystem) {
                    fullMessage = [NSString stringWithFormat:@"(%@) %@", subsystem, message()];
                }
                else if (category) {
                    fullMessage = [NSString stringWithFormat:@"(%@) %@", category, message()];
                }
                else {
                    fullMessage = message();
                }
                [NSClassFromString(@"DDLog") log:YES message:fullMessage level:NSUIntegerMax flag:flag context:0 file:file function:function line:line tag:nil];
            };
        }
    });
    return s_handler;
}

SRGLogHandler SRGUnifiedLoggingHandler(void)
{
    static SRGLogHandler s_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (os_log_type_enabled != NULL) {
            s_handler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
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
                
                // If the os_log_t already exists, it is simply reused. No bookkeeping must be made on our side,
                // therefore no thread-safety issues to fear
                os_log_t log = os_log_create(subsystem.UTF8String, category.UTF8String);
                os_log_with_type(log, type, "%{public}@", message());
            };
        }
    });
    return s_handler;
}

SRGLogHandler SRGNSLogHandler(void)
{
    static SRGLogHandler s_handler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
    {
        static NSDictionary<NSNumber *, NSString *> *s_levelNames;
        static dispatch_once_t s_onceToken;
        dispatch_once(&s_onceToken, ^{
            s_levelNames = @{ @(SRGLogLevelVerbose) : @"VERB",
                              @(SRGLogLevelDebug) : @"DEBUG",
                              @(SRGLogLevelInfo) : @"INFO",
                              @(SRGLogLevelWarning) : @"WARN",
                              @(SRGLogLevelError) : @"ERROR" };
        });
        
        if (subsystem && category) {
            NSLog(@"[%@] (%@|%@) %@", s_levelNames[@(level)], subsystem, category, message());
        }
        else if (subsystem) {
            NSLog(@"[%@] (%@) %@", s_levelNames[@(level)], subsystem, message());
        }
        else if (category) {
            NSLog(@"[%@] (%@) %@", s_levelNames[@(level)], category, message());
        }
        else {
            NSLog(@"%@", message());
        }
    };
    return s_handler;
}

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
    s_logHandler = SRGCocoaLumberjackHandler();
    if (s_logHandler) {
        return;
    }
    
    s_logHandler = SRGUnifiedLoggingHandler();
    if (s_logHandler) {
        return;
    }
    
    s_logHandler = SRGNSLogHandler();
}

NSString *SRGLoggerMarketingVersion(void)
{
    return [NSBundle srg_loggerBundle].infoDictionary[@"CFBundleShortVersionString"];
}
