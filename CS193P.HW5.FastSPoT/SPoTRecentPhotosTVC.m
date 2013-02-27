//
//  SPoTRecentPhotosViewController.m
//  CS193P.4.SPoT
//
//  Created by Felix Vigl on 20.02.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#import "SPoTRecentPhotosTVC.h"

@interface SPoTRecentPhotosTVC ()

@end


@implementation SPoTRecentPhotosTVC

@synthesize photoDataDictionaries = _photoDataDictionaries;

# pragma mark - Accessors

- (NSMutableArray *)photoDataDictionaries
{
	if (!_photoDataDictionaries) _photoDataDictionaries = self.history;
	return _photoDataDictionaries;
}


# pragma mark - TableView


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[self.photoDataDictionaries removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[self saveArray:self.photoDataDictionaries];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	[self.tableView beginUpdates];
	[self.tableView reloadData];
	[self.tableView endUpdates];
	
}

# pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"History";
}


@end
