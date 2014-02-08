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
#import "FilteredImageView.h"

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
    
//    for (UIView *v in self.pageController.view.subviews) {
//        if ([v isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)v).delegate = self;
//        }
//    }
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
    
    self.backgroundImage.filterColor =[currentViewController getBackgroundColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = self.pageIndicator.currentPage;
    UIColor* myColor = [[self viewControllerAtIndex:index] getBackgroundColor];
    UIColor* nextColor = [[self viewControllerAtIndex:(index+1)] getBackgroundColor];
    CGFloat percent = (scrollView.contentOffset.x-293)/293.0f;
    //NSLog(@"%f", percent);
    UIColor* backgroundColor = blend(myColor, nextColor, percent);
    self.backgroundImage.filterColor = backgroundColor;
    //UIColor leftColor =
    //NSLog(@"%f", scrollView.contentOffset.x);
}

UIColor* blend( UIColor* c1, UIColor* c2, float alpha )
{
    alpha = MIN( 1.f, MAX( 0.f, alpha ) );
    float beta = 1.f - alpha;
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [c1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat r = r1 * beta + r2 * alpha;
    CGFloat g = g1 * beta + g2 * alpha;
    CGFloat b = b1 * beta + b2 * alpha;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

@end
