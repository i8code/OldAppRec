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
#import "DataSource.h"
#import "RecordNewTableViewCell.h"
#import "MasterAudioPlayer.h"

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
    
    if (!self.expandedSections)
    {
        self.expandedSections = [[NSMutableIndexSet alloc] init];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor whiteColor];
}

- (void)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [DataSource getRecordingsForTagName:self.tagName completion:^(NSArray *recordings) {
            self.recordings = recordings;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
        }];
    });
}
//- (void)updateTable
//{
//    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
//}

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
        if ([self.expandedSections containsIndex:section])
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
            [((TagTableViewCell*)cell) setParentTagViewController:self.parentTagViewController];
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
                [((RecordNewTableViewCell*)cell) setDelegate:self.delegate];
                [((RecordNewTableViewCell*)cell) setParentRecording:[self.recordings objectAtIndex:indexPath.section]];
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
            [((TagTableViewCell*)cell) setLast:(indexPath.row==recording.childrenLength+1)];
            [((TagTableViewCell*)cell) setParentTagViewController:self.parentTagViewController];
        }
    }
    else
    {
        cell.accessoryView = nil;
        cell.textLabel.text = @"Normal Cell";
        
    }
    cell.selectedBackgroundView.hidden = YES;
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
-(void)commentPressed:(UITableViewCell*)cell{
    
    UITableView* tableView = self.tableView;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [self.tableView beginUpdates];
            
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [self.expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [self.expandedSections removeIndex:section];
                
            }
            else
            {
                [self.expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
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

#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[TagTableViewCell class]]){
        [((TagTableViewCell*)cell) playClicked:self];
    }
    else if ([cell isKindOfClass:[RecordNewTableViewCell class]]){
        [((RecordNewTableViewCell*)cell) recordPressed:self];
    }
}

/*
-(void)playNext:(TagTableViewCell*)sender{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    if (sender.comment){
        //cell is a comment, find next cell;
        indexPath =  [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    }
    else {
        indexPath =  [NSIndexPath indexPathForRow:0 inSection:indexPath.section+1];
    }
    TagTableViewCell* cell = (TagTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell playClicked:cell];
}
*/
-(void)playAll{
    if (!self.recordings || !self.recordings.count){
        return;
    }
    [[MasterAudioPlayer instance] play:(Recording*)self.recordings[0] fromTagSet:self.recordings ];
}
@end
