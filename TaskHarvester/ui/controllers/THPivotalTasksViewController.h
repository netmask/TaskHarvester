//
//  THPivotalTasksViewController.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THPivotalStory.h"
#import "THPivotalTaskCellView.h"

@interface THPivotalTasksViewController : NSViewController<NSComboBoxDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property(strong) NSMutableArray *tasks;
@property(strong) NSMutableArray *pivotalProjects;
@property NSMutableArray *harvestEntries;

@property(strong) NSTableView *pivotalTasksView;
@property THPivotalProject *pivotalProject;
- (id)initWithTableView:(NSTableView*) tableView;
@end
