//
//  WAHashMap.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef const struct _WAHashMap * WAHashMapRef;

FOUNDATION_EXTERN WAHashMapRef WAHashMapCreate(void);

FOUNDATION_EXTERN void WAHashMapRelease(WAHashMapRef theMap);

FOUNDATION_EXTERN void WAHashMapSetKeyValue(WAHashMapRef theMap, int32_t key, const void *value);

FOUNDATION_EXTERN void WAHashMapRemoveArrayAtKey(WAHashMapRef theMap, int32_t key);

FOUNDATION_EXTERN unsigned long WAHashMapGetCount(WAHashMapRef theMap);

FOUNDATION_EXTERN const void * WAHashMapGetValue(WAHashMapRef theMap, int32_t key);

NS_ASSUME_NONNULL_END
