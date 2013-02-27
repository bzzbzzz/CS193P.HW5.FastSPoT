//
//  SPoTMasterViewController.h
//  CS193P.4.SPoT
//
//  Created by Felix Vigl on 20.02.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@class ImageViewController;

@interface SPoTTitleTVC : UITableViewController

  @property (strong, nonatomic) ImageViewController *detailViewController;

  @property (strong, nonatomic) NSMutableArray *photoDataDictionaries;
  @property (strong, nonatomic) NSMutableArray *history;

- (void)setPhotoDataDictionaries:(NSMutableArray *)photoDataDictionaries;

- (void)saveArray:(NSMutableArray *)array;
- (void)addToHistory:(NSDictionary *)detailItem;

@end
