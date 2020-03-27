//
//  WATypes.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define WALEVEL_UNDEFINED 0
#define WALEVEL_ERROR 1
#define WALEVEL_WARN 2
#define WALEVEL_INFO 3
#define WALEVEL_DEBUG 4
#define WALEVEL_TRACE 5
#define WALEVEL_FATAL 6

static inline const char * WAStringFromWALEVEL(uint8_t level) {
    switch (level) {
        case WALEVEL_ERROR:
            return "error";
        case WALEVEL_WARN:
            return "warn";
        case WALEVEL_INFO:
            return "info";
        case WALEVEL_DEBUG:
            return "debug";
        case WALEVEL_TRACE:
            return "trace";
        case WALEVEL_FATAL:
            return "fatal";
        default:
            return "undefined";
    }
}

static inline uint8_t WALEVELFromString(const char * level) {
    if (level == NULL) return WALEVEL_UNDEFINED;
    if (strncmp("error", level, 10) == 0) return WALEVEL_ERROR;
    if (strncmp("warn", level, 10) == 0) return WALEVEL_WARN;
    if (strncmp("info", level, 10) == 0) return WALEVEL_INFO;
    if (strncmp("debug", level, 10) == 0) return WALEVEL_DEBUG;
    if (strncmp("trace", level, 10) == 0) return WALEVEL_TRACE;
    if (strncmp("fatal", level, 10) == 0) return WALEVEL_FATAL;
    return WALEVEL_UNDEFINED;
}

NS_ASSUME_NONNULL_END
