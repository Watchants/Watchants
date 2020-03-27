//
//  WAMonitor.m
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import "WAMonitor.h"
#import "_WAMonitor.h"

#import "WAStream.h"
#import "WAFileManager.h"

#import <pthread.h>
#import <Watchants/WAMessage.h>

#pragma mark Private
#pragma mark stream

static inline void *_placeholder() {
    static uint8_t placeholder = 0;
    return &placeholder;
}

static inline void _destructor(void * args) {
    if (args == NULL) return;
    if (args == _placeholder()) return;
    WAStreamClose((WAStreamRef)args);
}

static inline pthread_key_t _pthread_key() {
    static pthread_key_t pthread_key = 0;
    if (pthread_key == 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{ pthread_key_create(&pthread_key, _destructor); });
    }
    return pthread_key;
}

static inline WAStreamRef _thread_stream(WAMonitorRef monitor) {
    pthread_key_t pthread_key = _pthread_key();
    void *objc = pthread_getspecific(pthread_key);

    if (_placeholder() == objc) return NULL;
    if (objc != NULL) return (WAStreamRef)objc;

    WAStreamRef stream = WAStreamOpen(WAFileManagerGetNewStreamThreadPath().UTF8String);
    pthread_setspecific(pthread_key, stream == NULL ? _placeholder() : (void *)stream);
    return stream;
}

static inline WAStreamRef _port_stream(WAMonitorRef monitor) {
    if (monitor->stream.write == NULL) {
        struct _WAMonitor *_monitor = (struct _WAMonitor *)monitor;
        _monitor->stream.write = WAStreamOpen(WAFileManagerGetNewStreamPortPath(monitor->port).UTF8String);
    }
    return monitor->stream.write;
}

static inline WAStreamRef _stream(WAMonitorRef monitor) {
    if (monitor == NULL)
        return NULL;

    if (monitor->threadsafe == false) {
        return _port_stream(monitor);
    } else {
        return _thread_stream(monitor);
    }
}

static inline int _write(WAMonitorRef monitor, const WAMessageBytes msg) {
    uint32_t len = 0;
    uint8_t * buffer = WAMessageBytesCreate(msg, &len);
    WAStreamRef stream = _stream(monitor);
    int result = WAStreamWrite(stream, buffer, len);
    WAMessageBytesRelease(buffer, len);
    return result;
}

#pragma mark Public methods

WAMonitorRef WAMonitorCreate(const char *name, const uint32_t port, bool threadsafe) {
    struct _WAMonitor *monitor = (struct _WAMonitor *)malloc(sizeof(struct _WAMonitor));
    monitor->name = name;
    monitor->port = port;
    monitor->threadsafe = threadsafe;
    monitor->pipe.write = _write;
    monitor->stream.write = NULL;
    return monitor;
}

void WAMonitorRelease(WAMonitorRef thisMonitor) {
    if (thisMonitor == NULL)
        return;
    
    struct _WAMonitor *monitor = (struct _WAMonitor *)thisMonitor;
    if (monitor->stream.write != NULL)
        WAStreamClose(monitor->stream.write);
    free(monitor);
}

const char * WAMonitorGetName(WAMonitorRef thisMonitor) {
    return thisMonitor->name;
}

uint32_t WAMonitorGetPort(WAMonitorRef thisMonitor) {
    return thisMonitor->port;
}
