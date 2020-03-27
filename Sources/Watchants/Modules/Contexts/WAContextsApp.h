//
//  WAContextsApp.h
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#ifndef WACONTEXTSAPP_H
#define WACONTEXTSAPP_H
#ifdef __cplusplus
extern "C" {
#endif
// BEGIN

typedef struct {
    int flag;
} WAContextsApp;

const WAContextsApp * WAContextsAppGetApp(void);

// END
#ifdef __cplusplus
}
#endif
#endif /* WACONTEXTSAPP_H */

