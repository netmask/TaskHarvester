//
//  THMainViewController.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ReactiveCocoa.h>

#import "THMenuItemView.h"
#import "THPivotalTasksViewController.h"

#import "THHarvestProfile.h"
#import "THHarvestProject.h"
#import "THPivotalProject.h"
#import "THHarvestEntry.h"

#import "THHarvestService.h"
#import "THPivotalService.h"
#import "THSettingsView.h"
#import "THStatusBarView.h"

@interface THMainViewController : NSViewController<NSComboBoxDelegate>
@property(strong) NSStatusItem *statusBarItem;
@property(strong) THPivotalTasksViewController *tasksView;

@property (strong, nonatomic) IBOutlet THMenuItemView *view;

@property NSMutableArray *harvestProjects;
@property NSMutableArray *pivotalProjects;
@property NSMutableArray *harvestEntries;

@property THHarvestProject *selectedProject;
@property THPivotalProject *selectedPivotalProject;
@end
