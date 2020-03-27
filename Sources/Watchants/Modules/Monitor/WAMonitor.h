//
//  WAMonitor.h
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef const struct _WAMonitor * WAMonitorRef;

FOUNDATION_EXTERN WAMonitorRef WAMonitorCreate(const char *name, const uint32_t port, bool threadsafe);

FOUNDATION_EXTERN void WAMonitorRelease(WAMonitorRef thisMonitor);

FOUNDATION_EXTERN const char * WAMonitorGetName(WAMonitorRef thisMonitor);

FOUNDATION_EXTERN uint32_t WAMonitorGetPort(WAMonitorRef thisMonitor);

NS_ASSUME_NONNULL_END
