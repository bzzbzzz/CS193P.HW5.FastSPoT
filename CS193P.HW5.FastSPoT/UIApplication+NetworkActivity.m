//
//  UIApplication+NetworkActivity.m
//  CS193P.HW5.FastSPoT
//
//  Created by Felix Vigl on 02.03.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#import "UIApplication+NetworkActivity.h"

@implementation UIApplication (NetworkActivity)

-(void)toggleNetworkActivityIndicatorVisible:(BOOL)visible {

    static int activityCount = 0;
    
	@synchronized (self) {
    
		visible ? activityCount++ : activityCount--;
        
		self.networkActivityIndicatorVisible = activityCount > 0;
    }
}
@end