//
//  WARunLoop.h
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN void WARunLoopStart(void);

FOUNDATION_EXTERN NSThread * _Nullable WARunLoopThread(void);

FOUNDATION_EXTERN NSRunLoop * _Nullable WARunLoopRunLoop(void);

FOUNDATION_EXTERN void WARunLoopRunBlock(void (^ _Nonnull block)(void));

FOUNDATION_EXTERN void WARunLoopAddEvent(uint32_t interval, void(* _Nonnull _callback)(uint64_t elapsed));

FOUNDATION_EXTERN void WARunLoopRemoveEvent(uint32_t interval, void(* _Nonnull _callback)(uint64_t elapsed));

NS_ASSUME_NONNULL_END
