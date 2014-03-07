//
//  SearchViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewController.h"

@interface SearchViewController ()

@property(nonatomic, strong) SearchTableViewController* searchTableView;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.searchTableView){
        [self.searchTableView.view removeFromSuperview];
        [self.searchTableView removeFromParentViewController];
    }
    
    self.searchTableView = [[SearchTableViewController alloc] initWithNibName:@"SearchTableViewController" bundle:nil];
    
    [self addChildViewController:self.searchTableView];
    [self.autofillArea addSubview:self.searchTableView.view];
    [self.searchTableView.view setFrame:self.autofillArea.bounds];
    
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    self.searchTableView.searchTerms = substring;
    
    return YES;
}
@end
