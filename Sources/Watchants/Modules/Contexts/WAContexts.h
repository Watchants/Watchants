//
//  WAContexts.h
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

#import <Watchants/WAContextsApp.h>
#import <Watchants/WAContextsDevice.h>
#import <Watchants/WAContextsSystem.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    const WAContextsSystem * system;
    const WAContextsDevice * device;
    const WAContextsApp * app;
} WAContexts;

const WAContexts * WAContextsGetContexts(void);

NS_ASSUME_NONNULL_END
