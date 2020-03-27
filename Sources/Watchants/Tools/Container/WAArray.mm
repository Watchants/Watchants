//
//  WAArray.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WAArray.h"

#import <vector>

struct _WAArray {
    std::vector<const void *> *vector;
};

WAArrayRef WAArrayCreate(void) {
    struct _WAArray *theArray = (struct _WAArray *)malloc(sizeof(struct _WAArray));
    theArray->vector = new std::vector<const void *>();
    return theArray;
}

void WAArrayRelease(WAArrayRef theArray) {
    if (theArray == nullptr) return;
    
    struct _WAArray *_theArray = (struct _WAArray *)theArray;
    delete _theArray->vector;
    free(_theArray);
}

void WAArrayAppendValue(WAArrayRef theArray, const void *value) {
    if (theArray == nullptr) return;
    theArray->vector->push_back(value);
}

bool WAArrayRemoveValue(WAArrayRef theArray, const void *value) {
    if (theArray == nullptr) return false;
    
    std::vector<const void *>::iterator iterator = theArray->vector->begin();
    for (;iterator != theArray->vector->end();) {
        if (*iterator.base() == value) {
            theArray->vector->erase(iterator);
            return true;
        }
        iterator ++;
    }
    return false;
}

unsigned long WAArrayGetCount(WAArrayRef theArray) {
    if (theArray == nullptr) return 0;
    
    return theArray->vector->size();
}

unsigned long WAArrayForEach(WAArrayRef theArray, void (*_callback)(const void *value, const void * content), const void * content) {
    if (theArray == nullptr) return 0;
    if (_callback == nullptr) return 0;
    
    std::vector<const void *>::iterator iterator = theArray->vector->begin();
    for (;iterator != theArray->vector->end();) {
        _callback(*iterator.base(), content);
        iterator ++;
    }
    return theArray->vector->size();
}
