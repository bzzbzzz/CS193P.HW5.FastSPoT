//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"
#import "FlickrFetcher.h"

@interface ImageViewController () <UIScrollViewDelegate>

  @property (strong, nonatomic) UIPopoverController *masterPopoverController;
  @property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

  @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

  @property (strong, nonatomic) UIImageView *imageView;
  @property (strong, nonatomic) NSData *imageData;

@end


@implementation ImageViewController


//----------------------------------------------------------------
# pragma mark   -   Accessors
//----------------------------------------------------------------

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
		
		[self.activityIndicatorView startAnimating];

		[self downloadImage];
    }
	
    if (self.masterPopoverController != nil) [self.masterPopoverController dismissPopoverAnimated:YES];
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
	if (!_activityIndicatorView) _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	return _activityIndicatorView;
}


//----------------------------------------------------------------
# pragma mark   -   ScrollView / ImageView
//----------------------------------------------------------------

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image

- (void)downloadImage
{
	self.scrollView.contentSize = CGSizeZero;
	self.imageView.image = nil;
	id detailItemBeingDownloaded = self.detailItem;
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	
		NSURL *imageURL = [FlickrFetcher urlForPhoto:self.detailItem format:FlickrPhotoFormatLarge];
        self.imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			app.networkActivityIndicatorVisible = NO;
			
			if ([detailItemBeingDownloaded isEqual:self.detailItem]) {
				[self resetImage];
			}
		});
	});
}

- (void)resetImage
{
    if (self.scrollView && self.detailItem) {
		
        UIImage *image = [[UIImage alloc] initWithData:self.imageData];
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
			
			[self.activityIndicatorView stopAnimating];
			[self relayoutScrollView];
        }
    }
}

- (void)relayoutScrollView
{
	if (self.imageView.image) {
		
		float heightRatio = self.view.bounds.size.height / self.imageView.bounds.size.height;
		float widthRatio = self.view.bounds.size.width / self.imageView.bounds.size.width;
		/*
		 if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) && self.interfaceOrientation == (UIDeviceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight)) {
		 widthRatio = self.view.bounds.size.width / (self.imageView.bounds.size.width - [[[[self.splitViewController.viewControllers objectAtIndex:0] viewControllers] lastObject] topViewController].view.bounds.size.width );
		 }
		 */
		
		self.scrollView.minimumZoomScale = MIN(heightRatio, widthRatio);
		
		[self.scrollView zoomToRect:self.imageView.bounds animated:YES];
		
		NSLog(@"\n self.imageView.frame:%@ \n self.imageView.bounds: %@", NSStringFromCGRect(self.imageView.frame), NSStringFromCGRect(self.imageView.bounds));
		NSLog(@"\n scr.frame:%@ \n scr.bounds: %@", NSStringFromCGRect(self.scrollView.frame), NSStringFromCGRect(self.scrollView.bounds));
		
	} else { self.activityIndicatorView.center = self.scrollView.center; }
}


// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


//----------------------------------------------------------------
# pragma mark   -   ViewController Lifecycle
//----------------------------------------------------------------

// add the image view to the scroll view's content area
// setup zooming by setting min and max zoom scale
//   and setting self to be the scroll view's delegate
// resets the image in case URL was set before outlets (e.g. scroll view) were set

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Photo";
    [self.scrollView addSubview:self.imageView];
	[self.scrollView addSubview:self.activityIndicatorView];
    self.scrollView.minimumZoomScale = 0.2; //temporary
    self.scrollView.maximumZoomScale = 5.0; //temporary
    self.scrollView.delegate = self;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[self relayoutScrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (self.detailItem) {
		
		[self.activityIndicatorView startAnimating];
		[self downloadImage];
	}
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Photos", @"Photos");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
