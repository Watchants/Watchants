//
//  WATime.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WATime.h"

#import <mach/mach.h>
#import <sys/sysctl.h>

static inline uint64_t _WATimeCurrentForkTimeCreate() {
    struct kinfo_proc proc;
    pid_t pid = getpid();
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(proc);
    if (sysctl(cmd, sizeof(cmd)/sizeof(*cmd), &proc, &size, NULL, 0) != KERN_SUCCESS) {
        return time(NULL) * 1000;
    }
    struct timeval time_v = proc.kp_proc.p_un.__p_starttime;
    return time_v.tv_sec * 1000 + time_v.tv_usec / 1000;
}

static inline uint64_t _WATimeCurrentMachTimeCreate() {
    return mach_absolute_time() / 1000000;
}

uint64_t WATimeGetForkTime() {
    static uint64_t _time = 0;
    if (_time == 0)
        _time = _WATimeCurrentForkTimeCreate();
    return _time;
}

uint64_t WATimeGetOffsetTime() {
    static uint64_t _time = 0;
    if (_time == 0)
        _time = time(NULL) * 1000 - _WATimeCurrentMachTimeCreate();
    return _time;
}

uint64_t WATimeGetMachTime() {
    return _WATimeCurrentMachTimeCreate();
}

uint64_t WATimeGetNumberID(void) {
    return (WATimeGetMachTime() + WATimeGetOffsetTime() - WATimeGetForkTime()) / 1000;
}
