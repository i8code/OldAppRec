//
//  YapZapModalViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/24/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapModalViewController.h"

@interface YapZapModalViewController ()

@end


@implementation YapZapModalViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    int y = 20;
    
    /* Back Button  o-- */
    if (!self.backButton){
        self.backButton = [[UIButton alloc] init];
        [self.backButton setTitle:@"" forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
        
        [self.backButton setFrame:CGRectMake(5, y, 25, 25)];
        [self.view addSubview:self.backButton];
        [self.backButton addTarget:self
                            action:@selector(backPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.backButton.showsTouchWhenHighlighted = YES;
    }
    
    
    
    /* Home Button  -o- */
    if (!self.homeButton){
        self.homeButton = [[UIButton alloc] init];
        [self.homeButton setTitle:@"" forState:UIControlStateNormal];
        [self.homeButton setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        
        [self.homeButton setFrame:CGRectMake((self.view.frame.size.width-25)/2.0,
                                             y+3, 25, 20)];
        [self.view addSubview:self.homeButton];
        [self.homeButton addTarget:self
                            action:@selector(homePressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.homeButton.showsTouchWhenHighlighted = YES;
    }
    
    
    
}


-(void)homePressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
