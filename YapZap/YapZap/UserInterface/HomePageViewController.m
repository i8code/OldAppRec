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
#import "SampleData.h"
#import "TagPage.h"
#import "PageSet.h"
#import "DataSource.h"

@interface HomePageViewController ()
@property (nonatomic, strong) NSArray* pages;
@end

@implementation HomePageViewController

@synthesize data = _data;
@synthesize pages = _pages;

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
    
    [self.backgroundImage setImage:[UIImage imageNamed:@"background.png"]];
    self.backgroundImage.filterColor = [UIColor whiteColor];
    [self loadPageSet:NO];
    
//    for (UIView *v in self.pageController.view.subviews) {
//        if ([v isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)v).delegate = self;
//        }
//    }
}

int setIndex=0;

bool hasForwardPage=false;
bool hasBackwardPage=false;
int numRealPages = 0;
bool here=false;
-(void)loadPageSet:(BOOL)goToEnd{
    UIView* loadingView = self.pageController.view;
    loadingView.userInteractionEnabled = NO;
    [self.pageController removeFromParentViewController];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray* pages = [[NSMutableArray alloc] init];
        PageSet* currentSet = [DataSource getSet:setIndex];
        [NSThread sleepForTimeInterval:1.5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
            
            self.pageController.dataSource = self;
            self.pageController.delegate = self;
            CGRect frame = CGRectMake(0, 0, self.pageControlViewArea.frame.size.width, self.pageControlViewArea.frame.size.height);
            [[self.pageController view] setFrame:frame];
            
            [loadingView removeFromSuperview];
            
            //Generate the pages
            numRealPages=0;
            if (currentSet.setNumber!=1){
                //Add the back page
                LoadingViewController* backPage =[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
                backPage.index = pages.count;
                backPage.view.frame = self.pageController.view.frame;
                [pages addObject:backPage];
                hasBackwardPage=true;
            }
            else {
                hasBackwardPage = false;
            }
            
            for (TagPage* tagPage in currentSet.tagPages){
                EpisodeViewController *pageView = [[EpisodeViewController alloc] initWithNibName:@"EpisodeViewController" bundle:nil];
                pageView.index = pages.count;
                pageView.view.frame = self.pageController.view.frame;
                [pageView setTagPage:tagPage];
                [pages addObject:pageView];
                numRealPages++;
            }
            
            if (currentSet.setNumber<currentSet.totalSets){
                LoadingViewController* forward =[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
                forward.index = pages.count;
                forward.view.frame = self.pageController.view.frame;
                [pages addObject:forward];
                hasForwardPage = true;
            }
            else{
                hasForwardPage=false;
            }
            
            self.pages = pages;
            
            //Set up dots
            self.pageIndicator.numberOfPages = numRealPages;
            self.pageIndicator.currentPage = goToEnd?numRealPages-1:0;
            
            int firstIndex = hasBackwardPage?1:0;
            int lastIndex = hasForwardPage?pages.count-2:pages.count-1;
            
            int startIndex = goToEnd? lastIndex:firstIndex;
            
            [self.pageController setViewControllers:[NSArray arrayWithObject:[self.pages objectAtIndex:startIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            
            [self addChildViewController:self.pageController];
            
            [[self pageControlViewArea] addSubview:[self.pageController view]];
            [self.pageController didMoveToParentViewController:self];
            
            
            self.backgroundImage.filterColor = [((EpisodeViewController*)[self.pages objectAtIndex:startIndex]) getBackgroundColor];

        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IndexedViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index>=self.pages.count){
        return nil;
    }
    
    return self.pages[index];
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
    
    if (index==self.pages.count) {
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
    int diff = hasBackwardPage?1:0;
    self.pageIndicator.currentPage = indexOfCurrentPage-diff;
    
    self.backgroundImage.filterColor =[currentViewController getBackgroundColor];
    
    if (indexOfCurrentPage==self.pages.count-1 && hasForwardPage){
        setIndex++;
        [self loadPageSet:NO];
    }
    else if (indexOfCurrentPage==0 && hasBackwardPage){
        setIndex--;
        [self loadPageSet:YES];
    }
}
/*
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
*/
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
