//
//  TagTableViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagTableViewController.h"
#import "TagTableViewCell.h"
#import "Recording.h"
#import "UIPopoverController+iPhone.h"
#import "LikeViewController.h"

@interface TagTableViewController ()

@property (nonatomic, strong) UIPopoverController* likePopover;

@end

@implementation TagTableViewController
@synthesize records = _records;


-(void)setRecords:(NSArray *)records{
    _records = records;
    [self.tableView reloadData];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor whiteColor];

}

-(void)viewWillAppear:(BOOL)animated{
    [self setCell:nil playing:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    TagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Recording* recording = [self.records objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell setRecording:recording];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)refresh
{
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
}
- (void)updateTable
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


-(void)setCell:(TagTableViewCell*)playingCell playing:(bool)playing{
    NSArray* cells = [self.tableView visibleCells];
    
    self.tableView.scrollEnabled = !playing;
    
    for (TagTableViewCell* cell in cells){
        if (playing && ![cell isEqual:playingCell]){
            [cell setEnabled:NO];
        }
        else {
            [cell setEnabled:YES];
            if (playing){
                //show popup
                [self.likePopover dismissPopoverAnimated:NO];
                UIView* me = playingCell.playButton;
                UIViewController *likeViewController = [[LikeViewController alloc] initWithNibName:@"LikeViewController" bundle:nil];
                self.likePopover = [[UIPopoverController alloc] initWithContentViewController:likeViewController];
                CGRect bounds = CGRectMake(me.frame.origin.x, me.frame.origin.y, me.frame.size.width, me.frame.size.height);
                [self.likePopover presentPopoverFromRect:bounds inView:playingCell permittedArrowDirections:(UIPopoverArrowDirectionUp) animated:YES];
                self.likePopover.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            }
        }
    }
    
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
