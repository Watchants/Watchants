//
//  WARunLoop.m
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import "WARunLoop.h"

#import "WAKeyArray.h"

#import <Watchants/WATime.h>

#pragma mark 'C'
#pragma mark Private vars

static NSThread *_thread = nil;
static NSRunLoop *_runLoop = nil;
static dispatch_semaphore_t _semaphore = NULL;

static uint64_t _number = 0;
static uint64_t _initiailze = 0;
static WAKeyArrayRef _keyArrayRef = NULL;

#pragma mark 'Objective-C'
#pragma mark Private Class

@interface WatchantsRunLoop : NSObject @end

@implementation WatchantsRunLoop

+ (void)threadFire {
    _WARunLoopRunLoopCreate();
}

+ (void)timerFire:(NSTimer *)timer {
    uint32_t key = timer.timeInterval;
    _number = WATimeGetNumberID();
    
    if (WAKeyArrayForEachAtKey(_keyArrayRef, key, _WARunLoopTimerFireCallback, NULL) == 0) {
        [timer invalidate];
    }
}

static inline void _WARunLoopTimeCreate() {
    WATimeGetForkTime();
    WATimeGetOffsetTime();
    _initiailze = WATimeGetMachTime();
}

static inline void _WARunLoopThreadCreate() {
    _semaphore = dispatch_semaphore_create(0);
    _thread = [[NSThread alloc] initWithTarget:WatchantsRunLoop.class selector:@selector(threadFire) object:nil];
    _thread.name = @"com.watchants.main-thread";
    [_thread start];
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

static inline void _WARunLoopRunLoopCreate() {
    dispatch_semaphore_t semaphore = _semaphore;
    NSRunLoop *runloop = NSRunLoop.currentRunLoop;
    _semaphore = NULL;
    _runLoop = runloop;
    _keyArrayRef = WAKeyArrayCreate();
    dispatch_semaphore_signal(semaphore);
    [runloop addPort:NSMachPort.port forMode:NSDefaultRunLoopMode];
    @autoreleasepool { while ([runloop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]); }
}

static inline void _WARunLoopTimerFireCallback(const void *value, const void *content) {
    typedef void(* _Nonnull _callback)(uint64_t number);
    _callback func = (_callback)value;
    func(_number);
}

static inline void _WARunLoopTimerCreate(uint32_t interval, void(* _Nonnull _callback)(uint64_t number)) {
    if (_runLoop == NULL) return;
    if (_keyArrayRef == NULL) return;
    
    bool empty = WAKeyArrayGetCountAtKey(_keyArrayRef, interval) == 0;
    WAKeyArrayAppendKeyValue(_keyArrayRef, interval, _callback);
    
    if (empty) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:WatchantsRunLoop.class selector:@selector(timerFire:) userInfo:nil repeats:true];
        [_runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

static inline void _WARunLoopTimerRelease(uint32_t interval, void(* _Nonnull _callback)(uint64_t number)) {
    if (_keyArrayRef == NULL) return;
    
    WAKeyArrayRemoveArrayAtKeyValue(_keyArrayRef, interval, _callback);
}

@end

#pragma mark 'C'
#pragma mark Public

void WARunLoopStart() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _WARunLoopTimeCreate();
        _WARunLoopThreadCreate();
    });
}

NSThread * _Nullable WARunLoopThread() {
    return _thread;
}

NSRunLoop * _Nullable WARunLoopRunLoop() {
    return _runLoop;
}

void WARunLoopRunBlock(void (^ _Nonnull block)(void)) {
    CFRunLoopRef runLoop = _runLoop.getCFRunLoop;
    if (runLoop == NULL) return;
    CFRunLoopPerformBlock(runLoop, kCFRunLoopDefaultMode, block);
    CFRunLoopWakeUp(runLoop);
}

void WARunLoopAddEvent(uint32_t interval, void(* _Nonnull _callback)(uint64_t number)) {
    if (interval < 1) return;
    
    CFRunLoopRef runLoop = _runLoop.getCFRunLoop;
    if (runLoop == NULL) return;
    CFRunLoopPerformBlock(runLoop, kCFRunLoopDefaultMode, ^{
        _WARunLoopTimerCreate(interval, _callback);
    });
    CFRunLoopWakeUp(runLoop);
}

void WARunLoopRemoveEvent(uint32_t interval, void(* _Nonnull _callback)(uint64_t number)) {
    if (interval < 1) return;
    
    CFRunLoopRef runLoop = _runLoop.getCFRunLoop;
    if (runLoop == NULL) return;
    CFRunLoopPerformBlock(runLoop, kCFRunLoopDefaultMode, ^{
        _WARunLoopTimerRelease(interval, _callback);
    });
    CFRunLoopWakeUp(runLoop);
}
