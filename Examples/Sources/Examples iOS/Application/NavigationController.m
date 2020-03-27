//
//  NavigationController.m
//  Examples iOS
//
//  Created by panghu on 3/27/20.
//

#import "NavigationController.h"

#import <mach/mach_time.h>
#import <Watchants/Watchants.h>

static NSString *string = @"New Thread";

@interface NavigationController ()

@end

@implementation NavigationController

+ (void)load {
    WARunLoopStart();
    WARunLoopAddEvent(1, runLoopEvent1);
    WARunLoopAddEvent(3, runLoopEvent3);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int index = 0; index < 0; index ++) {
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
            thread.name = [NSString stringWithFormat:@"%d", index];
            [thread start];
        }
    });
}

+ (void)start {
    @autoreleasepool {
        while (true) {
            @autoreleasepool {
             __autoreleasing NSString *str = [NSString stringWithFormat:@"%@ %llu\n", string, WATimeGetNumberID()];
                [NavigationController test:str.UTF8String];
            }
            [NSThread sleepForTimeInterval:0.2];
            if (WATimeGetNumberID() > 30) return;
        }
    }
}

- (void)test {
    [NavigationController test:[NSString stringWithFormat:@"0: RunLoopEvent: %llu\n", WATimeGetNumberID()].UTF8String];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [NavigationController test:[NSString stringWithFormat:@"0: RunLoopEvent: %llu\n", WATimeGetNumberID()].UTF8String];
    }];
}

+ (void)test:(const char *)string {
    static uint64_t t = 0;
    static WAMonitorRef monitor = NULL;
    if (monitor == NULL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            monitor = WAMonitorCreate("TestPostman", 0, true);
        });
    }
    uint64_t t1 = mach_absolute_time();
    WAMessageBytes msg = WAMessageBytesMake(WALEVEL_ERROR, (const uint8_t *)string, (uint32_t)strlen(string));
    int result = WAMessageBytesSendTo(monitor, msg);
    uint64_t t2 = mach_absolute_time();
    uint64_t t3 = t2 - t1;
    @synchronized (self) {
        t = MAX(t, t3);
    }
    WALog(WALEVEL_DEBUG, "duration: %llu result: %d max: %llu", t2 - t1, result, t);
}

static inline void runLoopEvent1(uint64_t elapsed) {
    [NavigationController test:[NSString stringWithFormat:@"2: %@: %llu\n", string, elapsed].UTF8String];
}

static inline void runLoopEvent3(uint64_t elapsed) {
    [NavigationController test:[NSString stringWithFormat:@"5: %@: %llu\n", string, elapsed].UTF8String];
}

@end
