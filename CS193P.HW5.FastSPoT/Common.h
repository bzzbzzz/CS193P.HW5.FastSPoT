//
//  Common.h
//  CS193P.HW5.FastSPoT
//
//  Created by Felix Vigl on 02.03.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#ifndef CS193P_HW5_FastSPoT_Common_h
#define CS193P_HW5_FastSPoT_Common_h
#endif

#ifdef DEBUG
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)

// http://www.cimgf.com/2010/05/02/my-current-prefix-pch-file/
