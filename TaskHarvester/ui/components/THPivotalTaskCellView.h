//
//  THPivotalTaskCellView.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THPivotalStory.h"
#import "THHarvestEntry.h"
#import "THHarvestTask.h"

@interface THPivotalTaskCellView : NSTableCellView
@property IBOutlet NSLevelIndicator *pointsIndicator;
@property IBOutlet NSTextField *taskName;
@property IBOutlet NSButton *actionButton;
@property IBOutlet NSProgressIndicator *activeIndicator;

@property THHarvestEntry *entry;
@property THPivotalStory *story;
@end
