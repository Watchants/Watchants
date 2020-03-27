//
//  WALog.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN void WALog(uint8_t level, const char * __restrict format, ...);

FOUNDATION_EXTERN void WALogSymbol(uint8_t level, const char *file, int line, const char *function, const char * __restrict format, ...);

NS_ASSUME_NONNULL_END
