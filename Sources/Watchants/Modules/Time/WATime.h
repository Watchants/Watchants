//
//  WATime.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN uint64_t WATimeGetForkTime(void);

FOUNDATION_EXTERN uint64_t WATimeGetOffsetTime(void);

FOUNDATION_EXTERN uint64_t WATimeGetMachTime(void);

FOUNDATION_EXTERN uint64_t WATimeGetNumberID(void);

NS_ASSUME_NONNULL_END
