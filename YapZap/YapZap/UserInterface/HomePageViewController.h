//
//  HomePageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilteredImageView;

@interface HomePageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIView *pageControlViewArea;
@property (weak, nonatomic) IBOutlet FilteredImageView *backgroundImage;
@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic, retain) UIPopoverController *poc;

@end
