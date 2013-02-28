//
//  SPoTMasterViewController.m
//  CS193P.4.SPoT
//
//  Created by Felix Vigl on 20.02.13.
//  Copyright (c) 2013 Felix Vigl. All rights reserved.
//

#import "SPoTTitleTVC.h"

#import "FlickrFetcher.h"

@interface SPoTTitleTVC ()

  @property (strong, nonatomic) NSString *plistPath;

@end

@implementation SPoTTitleTVC

- (void)setPhotoDataDictionaries:(NSMutableArray *)photoDataDictionaries
{
	_photoDataDictionaries = [[photoDataDictionaries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending:YES]]] mutableCopy];
}

- (NSString *)titleForRow:(NSInteger)row
{
	
	return [self.photoDataDictionaries[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *)descriptionForRow:(NSInteger)row
{
	return [[self.photoDataDictionaries[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
}

- (NSString *)plistPath
{
	if(!_plistPath) {
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		_plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
	}
	return _plistPath;
}

- (NSMutableArray *)history
{
	if (!_history) _history =  [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
	if (!_history) {
		NSLog(@"Error reading plist or no plist existing (yet)");
		_history = [[NSMutableArray alloc] init];
	}
	return _history;
}

- (void)saveArray:(NSMutableArray *)array
{
	[array writeToFile:self.plistPath atomically:YES] ? NSLog(@"recentPhotos saved") : NSLog(@"error saving recentPhotos");
}

- (void)addToHistory:(NSDictionary *)detailItem
{
	[self.history removeObject:detailItem];
	[self.history insertObject:detailItem atIndex:0];
	if (self.history.count > 20) [self.history removeLastObject];
	
	[self saveArray:self.history];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.photoDataDictionaries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];

	cell.textLabel.text = [self titleForRow:indexPath.row];
	cell.detailTextLabel.text = [self descriptionForRow:indexPath.row];
    return cell;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		self.detailViewController = (ImageViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        NSDictionary *photoDataDictionary = self.photoDataDictionaries[indexPath.row];
        self.detailViewController.detailItem = photoDataDictionary;
		[self addToHistory:photoDataDictionary];
    }
}


#pragma mark - ViewController Lifecylce

- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	}
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	//self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *photoDataDictionary = self.photoDataDictionaries[indexPath.row];
		[self addToHistory:photoDataDictionary];
		
		ImageViewController *imageViewController = (ImageViewController *)[segue destinationViewController];
        imageViewController.detailItem = photoDataDictionary;
		imageViewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
