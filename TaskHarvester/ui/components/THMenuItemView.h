//
//  THMenuItemView.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RMBlurredView.h"

#import "THPivotalTasksViewController.h"

@interface THMenuItemView : NSView
@property(strong) IBOutlet NSImageView *userImage;
@property(strong) IBOutlet NSTextField *userNameLabel;
@property(strong) IBOutlet NSTextField *companyLabel;
@property(strong) IBOutlet NSTextField *currentTaskLabel;
@property(strong) IBOutlet NSTextField *currentTaskInformationLabel;
@property(strong) IBOutlet NSTextField *currentTaskTimerLabel;

@property(strong) IBOutlet NSComboBox *projectList;
@property(strong) IBOutlet NSComboBox *taskList;
@property(strong) IBOutlet NSComboBox *pivotalProjectList;

@property(strong) IBOutlet NSButton *settingsButton;

@property(strong) IBOutlet NSTableView *pivotalTaskListTable;

@end
