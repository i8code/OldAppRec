//
//  TagPageTableViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagPageTableViewController.h"
#import "DTCustomColoredAccessory.h"
#import "Recording.h"
#import "TagTableViewCell.h"
#import "RecordNewTableViewCell.h"

@interface TagPageTableViewController ()

@end

@implementation TagPageTableViewController

@synthesize recordings = _recordings;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor whiteColor];
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

-(void)setRecordings:(NSArray *)recordings{
    _recordings = recordings;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Expanding

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section>=0) return YES;
    
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recordings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            Recording* recording = (Recording*)[self.recordings objectAtIndex:section];
            return recording.childrenLength+2; // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *tagCellIdentifier = @"TagTableViewCell";
//    static NSString *commentCellIdentifier = @"CommentTableViewCell";
    static NSString *recordNewCellIdentifier = @"RecordNewTableViewCell";
    
    UITableViewCell *cell;
   
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            Recording* recording = [self.recordings objectAtIndex:indexPath.section];
            [((TagTableViewCell*)cell) setRecording:recording];
            [((TagTableViewCell*)cell) setComment:NO];
//            [((TagTableViewCell*)cell) setSelected:[expandedSections containsIndex:indexPath.section]];
            
           /* if ([expandedSections containsIndex:indexPath.section])
            {
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:DTCustomColoredAccessoryTypeUp];
            }
            else
            {
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:DTCustomColoredAccessoryTypeDown];
            }*/
        }
        else if (indexPath.row==1){
            cell = [tableView dequeueReusableCellWithIdentifier:recordNewCellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordNewTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            Recording* recording = [self.recordings objectAtIndex:indexPath.section];
            Recording* comment = [recording.children objectAtIndex:indexPath.row-2];
            [((TagTableViewCell*)cell) setRecording:comment];
            [((TagTableViewCell*)cell) setComment:YES];
        }
    }
    else
    {
        cell.accessoryView = nil;
        cell.textLabel.text = @"Normal Cell";
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [self.tableView beginUpdates];
            
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
//                [((TagTableViewCell*)cell) setSelected:NO];
//                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
//                [((TagTableViewCell*)cell) setSelected:YES];
//                cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
            
            [self.tableView endUpdates];
        }
    }
}

@end
