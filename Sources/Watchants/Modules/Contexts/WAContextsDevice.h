//
//  WAContextsDevice.h
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#ifndef WACONTEXTSDEVICE_H
#define WACONTEXTSDEVICE_H
#ifdef __cplusplus
extern "C" {
#endif
// BEGIN

typedef struct {
    int flag;
} WAContextsDevice;

const WAContextsDevice * WAContextsDeviceGetDevice(void);

// END
#ifdef __cplusplus
}
#endif
#endif /* WACONTEXTSDEVICE_H */
