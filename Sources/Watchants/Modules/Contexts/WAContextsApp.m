//
//  WAContextsApp.m
//  Watchants
//
//  Created by panghu on 4/8/20.
//

#import "WAContextsApp.h"

#import <Foundation/Foundation.h>

const WAContextsApp * WAContextsAppGetApp() {
    static WAContextsApp *_app = NULL;
    
    return _app;
}
