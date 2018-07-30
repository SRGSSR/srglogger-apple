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
    static NSBundle *bundle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *bundlePath = [[NSBundle bundleForClass:[SRGLogger class]].bundlePath stringByAppendingPathComponent:@"SRGLogger.bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
        NSAssert(bundle, @"Please add SRGLogger.bundle to your project resources");
    });
    return bundle;
}

@end
