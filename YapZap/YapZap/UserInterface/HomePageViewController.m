//
//  HomePageViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "HomePageViewController.h"
#import "EpisodeViewController.h"
#import "LoadingViewController.h"
#import "IndexedViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    
    CGRect frame = CGRectMake(0, 0, self.pageControlViewArea.frame.size.width, self.pageControlViewArea.frame.size.height);
    [[self.pageController view] setFrame:frame];
    
    EpisodeViewController *initialViewController = (EpisodeViewController *)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    
    [[self pageControlViewArea] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IndexedViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    IndexedViewController *childViewController;
    
    if (index==5){
        childViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    } else{
        childViewController = [[EpisodeViewController alloc] initWithNibName:@"EpisodeViewController" bundle:nil];
    }
    childViewController.view.frame = self.pageController.view.frame;
    childViewController.index=index;
    
    return childViewController;
    
}
/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}*/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IndexedViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IndexedViewController*)viewController index];
    
    
    index++;
    
    if (index == 6) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    // Find index of current page
    IndexedViewController *currentViewController = (IndexedViewController *)[self.pageController.viewControllers lastObject];
    NSUInteger indexOfCurrentPage = currentViewController.index;
    self.pageIndicator.currentPage = indexOfCurrentPage;
}

@end
