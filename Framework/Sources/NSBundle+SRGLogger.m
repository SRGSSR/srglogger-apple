//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSBundle+SRGLogger.h"

#import "SRGLogger.h"

@implementation NSBundle (SRGMediaPlayer)

+ (NSBundle *)srg_loggerBundle
{
    static NSBundle *s_bundle;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSString *bundlePath = [[NSBundle bundleForClass:[SRGLogger class]].bundlePath stringByAppendingPathComponent:@"SRGLogger.bundle"];
        s_bundle = [NSBundle bundleWithPath:bundlePath];
        NSAssert(s_bundle, @"Please add SRGLogger.bundle to your project resources");
    });
    return s_bundle;
}

@end
