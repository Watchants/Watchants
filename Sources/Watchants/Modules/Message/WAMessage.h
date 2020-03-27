//
//  WAMessage.h
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import <Foundation/Foundation.h>

#import <Watchants/WAMonitor.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct _WAMessageBytes WAMessageBytes;
typedef struct _WAMessageHeader WAMessageHeader;
typedef struct _WAMessageBytesBody WAMessageBytesBody;

struct _WAMessageHeader {
    uint8_t bits;
    uint32_t size;
    uint16_t port;
    uint64_t number;
    uint8_t level;
};

struct _WAMessageBytesBody {
    const uint8_t * bytes;
};

struct _WAMessageBytes {
    WAMessageHeader header;
    WAMessageBytesBody body;
};

static inline const WAMessageBytes WAMessageBytesMake(uint8_t level, const uint8_t * bytes, uint32_t size) {
    static uint8_t bits = sizeof(void *);
    static uint16_t port = 0;
    static uint64_t number = 0;
    WAMessageBytes msg = {
        .header = {
            .bits = bits,
            .size = size,
            .port = port,
            .number = number,
            .level = level
        },
        .body = {
            .bytes = bytes
        }
    };
    return msg;
}

FOUNDATION_EXTERN int WAMessageBytesSendTo(WAMonitorRef monitor, const WAMessageBytes msg);

FOUNDATION_EXTERN uint8_t * WAMessageBytesCreate(const WAMessageBytes msg, uint32_t *len);

FOUNDATION_EXTERN void WAMessageBytesRelease(uint8_t * bytes, uint32_t len);

NS_ASSUME_NONNULL_END
