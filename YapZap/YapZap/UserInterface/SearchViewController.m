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
    self.searchTableView.delegate = self;
    
    [self addChildViewController:self.searchTableView];
    [self.autofillArea addSubview:self.searchTableView.view];
    [self.searchTableView.view setFrame:self.autofillArea.bounds];
    
    //Set up text field
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
    if ([self.textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
-(void)searchTermSelected:(NSString *)term{
    YapZapMainViewController* mainController = [YapZapMainViewController getMe];
    [self.textField resignFirstResponder];
    [mainController dismissSearch];
    [mainController gotoTagWithName:term];
}
@end
