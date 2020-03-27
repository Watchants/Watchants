//
//  WAMessage.m
//  Watchants iOS
//
//  Created by Panghu on 4/9/20.
//

#import "WAMessage.h"

#import "_WATypes.h"
#import "_WAMonitor.h"

#import <Watchants/WATime.h>

int WAMessageBytesSendTo(WAMonitorRef monitor, const WAMessageBytes msg) {
    return monitor->pipe.write(monitor, msg);
}

uint8_t * WAMessageBytesCreate(const WAMessageBytes msg, uint32_t *len) {
    uint64_t number = WATimeGetNumberID();
    size_t bits_size = watchants::bytes::number_sizeof(msg.header.bits);
    size_t size_size = watchants::bytes::number_sizeof(msg.header.size);
    size_t port_size = watchants::bytes::number_sizeof(msg.header.port);
    size_t number_size = watchants::bytes::number_sizeof(number);
    size_t level_size = watchants::bytes::number_sizeof(msg.header.level);
    size_t bytes_bytes = msg.header.size;
    
    size_t cpy_point = 0;
    size_t tatol_size = bits_size + size_size + port_size + number_size + level_size + bytes_bytes;
    uint8_t * buffer = (uint8_t *)malloc(tatol_size);
    
    watchants::bytes::number_to_bytes(msg.header.bits, buffer + cpy_point, bits_size);
    cpy_point += bits_size;
    
    watchants::bytes::number_to_bytes(msg.header.size, buffer + cpy_point, size_size);
    cpy_point += size_size;
    
    watchants::bytes::number_to_bytes(msg.header.port, buffer + cpy_point, port_size);
    cpy_point += port_size;
    
    watchants::bytes::number_to_bytes(number, buffer + cpy_point, number_size);
    cpy_point += number_size;
    
    watchants::bytes::number_to_bytes(msg.header.level, buffer + cpy_point, level_size);
    cpy_point += level_size;
    
    memcpy((void *)(buffer + cpy_point), msg.body.bytes, bytes_bytes);
    cpy_point += bytes_bytes;
    
    *len = (uint32_t)tatol_size;
    return buffer;
}

void WAMessageBytesRelease(uint8_t * bytes, uint32_t len) {
    free((void *)bytes);
}
