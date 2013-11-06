//
//  THPivotalTasksViewController.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalTasksViewController.h"

@interface THPivotalTasksViewController ()

@end

@implementation THPivotalTasksViewController

- (id)initWithTableView:(NSTableView*) currentTableView
{
  self = [super init];
  if (self) {
    _pivotalTasksView = currentTableView;
    [_pivotalTasksView setDataSource:self];
    [_pivotalTasksView setDelegate:self];
  }
  
  
  return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
  return [[self tasks] count];
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
  THPivotalProject *project = [[[self pivotalProjects] select:^BOOL(THPivotalProject *cProject) {
                                return [[cProject name] isEqual:[(NSComboBox*)[notification object] stringValue]];
                                }] firstObject];
  
  [[[THPivotalStory alloc] initWithProject:project] getAll:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [self setTasks:[[mappingResult array] mutableCopy]];
    [[self tasks] each:^(id task) {
      [task setProject:project];
    }];
    [[self pivotalTasksView] reloadData];
  }];
}



- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  
  NSArray *objects = @[];
  THPivotalTaskCellView *taskView = nil;
  
  if([[NSBundle mainBundle] loadNibNamed:@"THPivotalTaskCellView" owner:taskView topLevelObjects:&objects])
  {
    taskView = (THPivotalTaskCellView*)[objects detect:^BOOL(id object) {
      return [object isKindOfClass:NSView.class];
    }];

    [taskView setStory:[[self tasks] objectAtIndex:row]];
    
    [taskView setEntry:[[[self harvestEntries] select:^BOOL(THHarvestEntry *eEntry) {
      return [[eEntry notes] rangeOfString:[[taskView story] id]].location != NSNotFound;
    }] firstObject]];
  }
    
  return taskView;
}


@end
