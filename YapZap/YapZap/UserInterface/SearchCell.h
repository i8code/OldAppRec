//
//  SearchCell.h
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDelegate.h"

@interface SearchCell : UITableViewCell
@property(nonatomic, weak)id<SearchDelegate> delegate;

@end
