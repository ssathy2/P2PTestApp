//
//  DDDHelpers.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

//
// Keypath Macros -- taken from libextobjc by jspahrsummers: https://github.com/jspahrsummers/libextobjc
//
// @key -- stringifies the last method of a dot-notation method chain:
//      @key(model.submodel.title) -> @"title"
//
// @keypath -- stringifies the keypath from the root of a dot-notation method chain:
//      @keypath(model.submodel.title) -> @"submodel.title"
//

#define key(_path) (((void)(NO && ((void)_path, NO)), strrchr(# _path, '.') + 1))
#define keypath(_path) (((void)(NO && ((void)_path, NO)), strchr(# _path, '.') + 1))

#ifdef DEBUG
#define IS_DEVICE ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator" options:NSCaseInsensitiveSearch].location == NSNotFound)
#else
#define IS_DEVICE YES
#endif