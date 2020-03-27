//
//  WAKeyArray.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WAKeyArray.h"

#import <vector>
#import <unordered_map>

struct _WAKeyArray {
    std::unordered_map<int32_t, std::vector<const void *> *> *unordered_map;
};

WAKeyArrayRef WAKeyArrayCreate() {
    struct _WAKeyArray *theKeyArray = (struct _WAKeyArray *)malloc(sizeof(struct _WAKeyArray));
    theKeyArray->unordered_map = new std::unordered_map<int32_t, std::vector<const void *> *>();
    return theKeyArray;
}

void WAKeyArrayRelease(WAKeyArrayRef theKeyArray) {
    if (theKeyArray == nullptr) return;
    
    struct _WAKeyArray *_theKeyArray = (struct _WAKeyArray *)theKeyArray;
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator iterator = theKeyArray->unordered_map->begin();
    for(;iterator != theKeyArray->unordered_map->end();) {
        delete iterator->second;
        iterator = theKeyArray->unordered_map->erase(iterator);
    }
    delete theKeyArray->unordered_map;
    free(_theKeyArray);
}

void WAKeyArrayAppendKeyValue(WAKeyArrayRef theKeyArray, int32_t key, const void *value) {
    if (theKeyArray == nullptr) return;
    
    std::vector<const void *> *vector = nullptr;
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator find = theKeyArray->unordered_map->find(key);
    if (find == theKeyArray->unordered_map->cend()) {
        vector = new std::vector<const void *>();
        std::pair<int32_t, std::vector<const void *> *> pair(key, vector);
        theKeyArray->unordered_map->insert(pair);
    } else {
        vector = find->second;
    }
    vector->push_back(value);
}

bool WAKeyArrayRemoveArrayAtKey(WAKeyArrayRef theKeyArray, int32_t key) {
    if (theKeyArray == nullptr) return false;
    
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator del = theKeyArray->unordered_map->find(key);
    if (del == theKeyArray->unordered_map->cend()) return false;
    
    delete del->second;
    theKeyArray->unordered_map->erase(del);
    return true;
}

bool WAKeyArrayRemoveArrayAtKeyValue(WAKeyArrayRef theKeyArray, int32_t key, const void *value) {
    if (theKeyArray == nullptr) return false;
    
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator find = theKeyArray->unordered_map->find(key);
    if (find == theKeyArray->unordered_map->cend()) return false;
    
    std::vector<const void *> *vector = find->second;
    std::vector<const void *>::iterator iterator = vector->begin();
    for (;iterator != vector->end();) {
        if (*iterator.base() == value) {
            break;
        }
        iterator ++;
    }
    
    if (iterator == vector->end()) return false;
    vector->erase(iterator);
    if (vector->empty()) {
        theKeyArray->unordered_map->erase(find);
        delete vector;
    }
    return true;
}

unsigned long WAKeyArrayGetCountAtKey(WAKeyArrayRef theKeyArray, int32_t key) {
    if (theKeyArray == nullptr) return 0;
    
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator find = theKeyArray->unordered_map->find(key);
    if (find == theKeyArray->unordered_map->cend()) return 0;
    return find->second->size();
}

unsigned long WAKeyArrayForEachAtKey(WAKeyArrayRef theKeyArray, int32_t key, void (*_callback)(const void *value, const void * content), const void * _Nullable content) {
    if (theKeyArray == nullptr) return 0;
    if (_callback == nullptr) return 0;
    
    std::unordered_map<int32_t, std::vector<const void *> *>::const_iterator find = theKeyArray->unordered_map->find(key);
    if (find == theKeyArray->unordered_map->cend()) return 0;
    
    std::vector<const void *> *vector = find->second;
    std::vector<const void *>::iterator iterator = vector->begin();
    for (;iterator != vector->end();) {
        _callback(*iterator.base(), content);
        iterator ++;
    }
    return vector->size();
}
