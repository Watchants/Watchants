//
//  WAArray.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef const struct _WAArray * WAArrayRef;

FOUNDATION_EXTERN WAArrayRef WAArrayCreate(void);

FOUNDATION_EXTERN void WAArrayRelease(WAArrayRef theArray);

FOUNDATION_EXTERN void WAArrayAppendValue(WAArrayRef theArray, const void *value);

FOUNDATION_EXTERN bool WAArrayRemoveValue(WAArrayRef theArray, const void *value);

FOUNDATION_EXTERN unsigned long WAArrayGetCount(WAArrayRef theArray);

FOUNDATION_EXTERN unsigned long WAArrayForEach(WAArrayRef theArray, void (*_callback)(const void *value, const void * content), const void * content);

NS_ASSUME_NONNULL_END
