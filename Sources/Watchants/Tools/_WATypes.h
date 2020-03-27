//
//  _WATypes.h
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

namespace watchants {
namespace bytes {

template<typename _Numeric>
static inline _Numeric bytes_to_number(const uint8_t * bytes) {
    _Numeric number = 0;
    memcpy(&number, bytes, sizeof(_Numeric));
    return number;
}

template<typename _Numeric>
static inline size_t number_sizeof(_Numeric number) {
    return sizeof(number);
}

template<typename _Numeric>
static inline void number_to_bytes(_Numeric number, uint8_t * bytes, size_t size) {
    memcpy((void *)bytes, &number, size);
}

};
};

NS_ASSUME_NONNULL_END
