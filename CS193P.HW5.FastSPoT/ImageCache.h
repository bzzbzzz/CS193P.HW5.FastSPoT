//
//  ImageCache.h
//  CS193P.HW5.FastSPoT
//
//  Created by Felix Vigl on 27.02.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

  @property (nonatomic) NSUInteger maxCacheSize;
  @property (nonatomic) NSUInteger cacheSize;

+ (ImageCache *)sharedInstance;

- (BOOL)cacheData:(NSData *)data withIdentifier:(NSString *)identifier;

- (NSData *)dataInCacheForIdentifier:(NSString *)identifier;



@end
