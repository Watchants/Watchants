//
//  WALog.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WALog.h"

#import <Watchants/WATime.h>
#import <Watchants/WATypes.h>

static inline void _WALogWriteFile(const char * log) {
    printf("%s", log);
}

void WALog(uint8_t level, const char * __restrict format, ...) {
    if (format == NULL) {
        char string[1024];
        sprintf(string, "[%llu][%s] (null)\n", WATimeGetNumberID(), WAStringFromWALEVEL(level));
        _WALogWriteFile(string);
    } else {
        char buffer[1024];
        va_list args;
        va_start(args, format);
        vsprintf(buffer, format, args);
        va_end(args);
        
        char string[1024];
        sprintf(string, "[%llu][%s] %s\n", WATimeGetNumberID(), WAStringFromWALEVEL(level), buffer);
        _WALogWriteFile(string);
    }
}

void WALogSymbol(uint8_t level, const char *file, int line, const char *function, const char * __restrict format, ...) {
    if (format == NULL) {
        char string[1024];
        sprintf(string, "[%llu][%s] %s (in %s:%d)\n", WATimeGetNumberID(), WAStringFromWALEVEL(level), function, file, line);
        _WALogWriteFile(string);
    } else {
        char buffer[1024];
        va_list args;
        va_start(args, format);
        vsprintf(buffer, format, args);
        va_end(args);
        
        char string[1024];
        sprintf(string, "[%llu][%s] %s (in %s:%d) %s\n", WATimeGetNumberID(), WAStringFromWALEVEL(level), function, file, line, buffer);
        _WALogWriteFile(string);
    }
}
