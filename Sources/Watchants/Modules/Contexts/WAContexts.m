//
//  WAContexts.m
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#import "WAContexts.h"

const WAContexts * WAContextsGetContexts(void) {
    static WAContexts *_contexts = NULL;
    if (_contexts == NULL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WAContexts * contexts = (WAContexts *)malloc(sizeof(WAContexts));
            contexts->app = WAContextsAppGetApp();
            contexts->device = WAContextsDeviceGetDevice();
            contexts->system = WAContextsSystemGetSystem();
            _contexts = contexts;
        });
    }
    return _contexts;
}
