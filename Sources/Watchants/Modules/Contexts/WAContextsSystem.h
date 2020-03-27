//
//  WAContextsSystem.h
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#ifndef WACONTEXTSSYSTEM_H
#define WACONTEXTSSYSTEM_H
#ifdef __cplusplus
extern "C" {
#endif
// BEGIN

typedef struct {
    int flag;
} WAContextsSystem;

const WAContextsSystem * WAContextsSystemGetSystem(void);

// END
#ifdef __cplusplus
}
#endif
#endif /* WACONTEXTSSYSTEM_H */
