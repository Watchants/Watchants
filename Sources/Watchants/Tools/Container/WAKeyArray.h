//
//  WAKeyArray.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef const struct _WAKeyArray * WAKeyArrayRef;

FOUNDATION_EXTERN WAKeyArrayRef WAKeyArrayCreate(void);

FOUNDATION_EXTERN void WAKeyArrayRelease(WAKeyArrayRef theKeyArray);

FOUNDATION_EXTERN void WAKeyArrayAppendKeyValue(WAKeyArrayRef theKeyArray, int32_t key, const void *value);

FOUNDATION_EXTERN bool WAKeyArrayRemoveArrayAtKey(WAKeyArrayRef theKeyArray, int32_t key);

FOUNDATION_EXTERN bool WAKeyArrayRemoveArrayAtKeyValue(WAKeyArrayRef theKeyArray, int32_t key, const void *value);

FOUNDATION_EXTERN unsigned long WAKeyArrayGetCountAtKey(WAKeyArrayRef theKeyArray, int32_t key);

FOUNDATION_EXTERN unsigned long WAKeyArrayForEachAtKey(WAKeyArrayRef theKeyArray, int32_t key, void (*_callback)(const void *value, const void * content), const void * _Nullable content);

NS_ASSUME_NONNULL_END
