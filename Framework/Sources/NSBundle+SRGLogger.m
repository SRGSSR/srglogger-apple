//
//  Copyright (c) SRG. All rights reserved.
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
        bundle = [NSBundle bundleForClass:[SRGLogger class]];
    });
    return bundle;
}

@end
