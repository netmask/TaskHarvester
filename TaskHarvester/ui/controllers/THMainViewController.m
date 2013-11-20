//
//  THMainViewController.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THMainViewController.h"

@interface THMainViewController ()

@end

@implementation THMainViewController{
  float _totalHours;
  float _currentTaskHours;
  FXKeychain *keyChain;

  NSUserDefaults *_defaults;
  NSPopover *_contentPopover;
  
}

NSString const *kHarvestPassword = @"harvest.password";
NSString const *kHarvestUsername = @"harvest.username";
NSString const *kHarvestSubDomain = @"harvest.sub_domain";

NSString const *kPivotalUsername = @"pivotal.username";
NSString const *kPivotalPassword = @"pivotal.password";


- (id)init
{
    self = [super init];
    if (self) {
      _totalHours = 0.0;
      _currentTaskHours = 0.0;
      keyChain =  [FXKeychain defaultKeychain];
      _defaults = [NSUserDefaults standardUserDefaults];

      [self setup];
    }
    return self;
}

-(void) setup
{
  [self setStatusBarItem:[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]];

  [self setView:[THMenuItemView new]];
  
  //Bar item view
  THStatusBarView *barView = [THStatusBarView new];
  [[self statusBarItem] setView:barView];
  _contentPopover = [NSPopover new];
  [_contentPopover setContentViewController:self];
  [_contentPopover setBehavior:NSPopoverBehaviorSemitransient];
  
  [barView setPopover:_contentPopover];
  
  [self setTasksView:[[THPivotalTasksViewController alloc]
                      initWithTableView:self.view.pivotalTaskListTable]];
  
  [[[self view] settingsButton] setTarget:self];
  [[[self view] settingsButton] setAction:@selector(openSettingsDialog)];
  
  THStore *store = [THStore instance];
  [RACObserve(store, asSettings) subscribeNext:^(id x) {
      
    if([x isEqualToNumber:@1]){
      [[THHarvestService sharedinstance] setupUsername:[_defaults objectForKey:kHarvestUsername]
                                              password:[_defaults objectForKey:kHarvestPassword]
                                               company:[_defaults objectForKey:kHarvestSubDomain]];
      
      [[THPivotalService sharedinstance] setupWithUserName:[_defaults objectForKey:kPivotalUsername]
                                                  password:[_defaults objectForKey:kPivotalPassword]];
      
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      
      
      dispatch_async(queue, ^{ [self loadProfile];  });
      dispatch_async(queue, ^{ [self laoadProjects];});
      
      [self.view.projectList setDelegate:self];
      [self.view.taskList setDelegate:self];
      
      [self.view.pivotalProjectList setDelegate:self.tasksView];
      
      [RACObserve(self, selectedProject) subscribeNext:^(id project) {
        
        [[THStore instance] setHarvestProject:project];
        
        [self.view.taskList removeAllItems];
        [self.view.taskList addItemsWithObjectValues:[[project tasks] map:^id(id task) {
          return [task name];
        }]];
      }];
      
    }
    
  }];
  
//  [[THStore instance] setAsSettings:[_defaults boolForKey:@"asSettings"]];
}

-(void) laoadProjects
{
  [[THHarvestProject alloc] getAll:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
    [self setHarvestProjects:[[[mappingResult array] select:^BOOL(id object) {
      return [object isKindOfClass:THHarvestProject.class];
    }] mutableCopy]];
    
    
     [[self tasksView] setHarvestEntries:[[mappingResult array] select:^BOOL(id object) {
        return [object isKindOfClass:THHarvestEntry.class];
      }].mutableCopy];
    
    [[self.tasksView harvestEntries] each:^(id object) {
      _totalHours += [[object hours] floatValue];
    }];
    
    [self.view.currentTaskTimerLabel setStringValue:NSStringWithFormat(@"%.2f", _totalHours)];
    
    [self.view.projectList addItemsWithObjectValues:[self.harvestProjects map:^id(id object) {
      return [object name];
    }]];
  }];
  
  [[THPivotalProject alloc] getAll:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [self.tasksView setPivotalProjects:[[mappingResult array] mutableCopy]];
    
    [self.view.pivotalProjectList addItemsWithObjectValues:[[mappingResult array] map:^ id(id object) {
      return [object name];
    }]];
  }];
  
  
}

-(void) loadProfile
{
  
  [[THHarvestProfile alloc] get:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    THHarvestProfile *profile = [mappingResult firstObject];
    [[self.view userNameLabel] setStringValue:[profile displayName]];
    [[self.view companyLabel] setStringValue:[profile companyName]];
  
    NSImage *avatar = [[NSImage alloc] initByReferencingURL:[[NSURL alloc] initWithString:profile.avatarUrl]];
    [avatar setSize:NSSizeFromCGSize(CGSizeMake(100, 100))];
    [self.view.userImage setImage:avatar];
    
  }];
}



- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
  NSComboBox *box = (NSComboBox*)[notification object];
  NSInteger index = [box indexOfItemWithObjectValue:[box objectValueOfSelectedItem]];
  
  if([[box identifier] isEqualToString:@"harvest_project_box"]){
    [self setSelectedProject:(THHarvestProject*)[[self harvestProjects] objectAtIndex:index]];
  }
  
  if([[box identifier] isEqualToString:@"harvest_task_box"]){
    [[THStore instance] setHarvestTask:[[[self selectedProject] tasks] objectAtIndex:index]];  
  }

}

-(void)openSettingsDialog
{
  
  
  [self.view.settingsView debugDescription];
  

  [[self.view.settingsView backButton] setAction:@selector(storeSettings)];
  [[self.view.settingsView backButton] setTarget:self];
  
  [@[@[[self.view.settingsView harvestPasswordField], kHarvestPassword],
     @[[self.view.settingsView harvestUsernameField], kHarvestUsername],
     @[[self.view.settingsView harvestSubdomainField], kHarvestSubDomain],
     @[[self.view.settingsView pivotalPasswordField], kPivotalPassword],
     @[[self.view.settingsView pivotalUsernameField], kPivotalUsername]] each:^(id object) {
       NSString  *value = nil;
       
       if ((value = [_defaults objectForKey:object[1]])) {
         [object[0] setStringValue:value];
       };
     }];

  [self.view.settingsView setHidden:NO];
}

-(void) storeSettings
{
  
  [@[@[[self.view.settingsView harvestPasswordField], kHarvestPassword],
    @[[self.view.settingsView harvestUsernameField], kHarvestUsername],
    @[[self.view.settingsView harvestSubdomainField], kHarvestSubDomain],
    @[[self.view.settingsView pivotalPasswordField], kPivotalPassword],
    @[[self.view.settingsView pivotalUsernameField], kPivotalUsername]] each:^(id object) {
      [_defaults setObject:[object[0] stringValue] forKey:object[1]];
    }];
  

  [[THStore instance] setAsSettings:YES];
  
  [_defaults setBool:YES forKey:@"asSettings"];
  [_defaults synchronize];
  [self.view.settingsView setHidden:YES];

}
@end
