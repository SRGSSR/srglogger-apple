//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLogger.h"

#import "NSBundle+SRGLogger.h"

NSString *SRGLoggerMarketingVersion(void)
{
    return [NSBundle srg_loggerBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static SRGLogHandler s_logHandler = ^(NSString *(^message)(void), SRGLogLevel level, NSString * const subsystem, NSString * const category, const char *file, const char *function, NSUInteger line)
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
