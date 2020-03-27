//
//  _WAMonitor.h
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import <Foundation/Foundation.h>

#import "WAStream.h"

#import <Watchants/WAMessage.h>

NS_ASSUME_NONNULL_BEGIN

struct _WAMonitor {
    const char *name;
    uint32_t port;
    bool threadsafe;
    
    struct {
         WAStreamRef write;
    } stream;
    
    struct {
        int (*write)(WAMonitorRef monitor, const WAMessageBytes msg);
    } pipe;
};

NS_ASSUME_NONNULL_END
