//
//  WAStream.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef const struct _WAStream *WAStreamRef;

WAStreamRef _Nullable WAStreamOpen(const char * filepath);

void WAStreamClose(WAStreamRef this_stream);

int WAStreamWrite(WAStreamRef this_stream, const uint8_t * buffer, size_t len);

NS_ASSUME_NONNULL_END
