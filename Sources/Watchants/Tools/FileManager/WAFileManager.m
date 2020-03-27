//
//  WAFileManager.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WAFileManager.h"

#import <sys/stat.h>

#import <Watchants/WATime.h>

static inline bool _WAFileManagerMakeDirectoryFrom(const char * path, unsigned long from) {
    bool success = false;
    char * cpy_path = strdup(path);
    for (unsigned long index = from + 1; cpy_path[index] != '\0'; index ++) {
        if (cpy_path[index] == '/') {
            cpy_path[index] = '\0';
            if(mkdir(cpy_path, S_IRWXU) < 0 && errno != EEXIST) {
                goto done;
            }
            cpy_path[index] = '/';
        }
    }
    if(mkdir(cpy_path, S_IRWXU) < 0 && errno != EEXIST) {
        goto done;
    }
    
done:
    if (cpy_path != NULL)
        free(cpy_path);
    return success;
}

static inline bool _WAFileManagerMakeDirectory(const char * path) {
    if (mkdir(path, S_IRWXU) < 0 && errno != EEXIST) {
        return false;
    } else {
        return true;
    }
}

static inline NSString * _WAFileManagerHomeDirectory() {
    static NSString * home = NULL;
    if (home == NULL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            home = [cache stringByAppendingPathComponent:@"com.watchants"];
            _WAFileManagerMakeDirectoryFrom(home.UTF8String, strlen(cache.UTF8String));
        });
    }
    return home;
}

static inline NSString * _WAFileManagerCurrentTargetDirectory() {
    static NSString * target = NULL;
    if (target == NULL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            target = [_WAFileManagerHomeDirectory() stringByAppendingFormat:@"/%llu", WATimeGetForkTime() / 1000];
            _WAFileManagerMakeDirectory(target.UTF8String);
        });
    }
    return target;
}

NSString * WAFileManagerHomeDirectory() {
    return _WAFileManagerHomeDirectory();
}

NSString * WAFileManagerCurrentTargetDirectory() {
    return _WAFileManagerCurrentTargetDirectory();
}

bool WAFileManagerAccess(const char * path) {
    return access(path, R_OK | W_OK) == 0;
}

NSString * WAFileManagerGetNewStreamThreadPath() {
    return [_WAFileManagerCurrentTargetDirectory() stringByAppendingFormat:@"/thread-%llu%u.log", WATimeGetNumberID(), arc4random()];
}

NSString * WAFileManagerGetNewStreamPortPath(uint32_t port) {
    return [_WAFileManagerCurrentTargetDirectory() stringByAppendingFormat:@"/port-%d-%u.log", port, arc4random()];
}
