//
//  WAFileManager.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * WAFileManagerHomeDirectory(void);

FOUNDATION_EXTERN NSString * WAFileManagerCurrentTargetDirectory(void);

FOUNDATION_EXTERN bool WAFileManagerAccess(const char * path);

FOUNDATION_EXTERN NSString * WAFileManagerGetNewStreamThreadPath(void);

FOUNDATION_EXTERN NSString * WAFileManagerGetNewStreamPortPath(uint32_t port);

NS_ASSUME_NONNULL_END
