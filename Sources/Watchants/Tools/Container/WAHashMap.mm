//
//  WAHashMap.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WAHashMap.h"

#include <unordered_map>

struct _WAHashMap {
    std::unordered_map<int32_t, const void *> *unordered_map;
};

WAHashMapRef WAHashMapCreate(void) {
    struct _WAHashMap *theMap = (struct _WAHashMap *)malloc(sizeof(struct _WAHashMap));
    theMap->unordered_map = new std::unordered_map<int32_t, const void *>();
    return theMap;
}

void WAHashMapRelease(WAHashMapRef theMap) {
    if (theMap == nullptr) return;
    
    struct _WAHashMap *_theMap = (struct _WAHashMap *)theMap;
    delete _theMap->unordered_map;
    free(_theMap);
}

void WAHashMapSetKeyValue(WAHashMapRef theMap, int32_t key, const void *value) {
    if (theMap == nullptr) return;
    
    std::pair<int32_t, const void *> pair(key, value);
    theMap->unordered_map->insert(pair);
}

void WAHashMapRemoveArrayAtKey(WAHashMapRef theMap, int32_t key) {
    if (theMap == nullptr) return;
    
    theMap->unordered_map->erase(key);
}

unsigned long WAHashMapGetCount(WAHashMapRef theMap) {
    if (theMap == nullptr) return 0;
    
    return theMap->unordered_map->size();
}

const void * WAHashMapGetValue(WAHashMapRef theMap, int32_t key) {
    if (theMap == nullptr) return nullptr;
    
    std::unordered_map<int32_t, const void *>::const_iterator find = theMap->unordered_map->find(key);
    if (find == theMap->unordered_map->cend()) return nullptr;
    return find->second;
}
