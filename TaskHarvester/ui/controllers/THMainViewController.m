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
  THSettingsView *_settingsView;
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
      [self setup];
      _totalHours = 0.0;
      _currentTaskHours = 0.0;
      keyChain =  [FXKeychain defaultKeychain];
      _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void) setup
{
  [self setStatusBarItem:[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]];
  [[self statusBarItem] setTitle:@"H"]; //TODO: An a image maybe ??
  [self.statusBarItem setHighlightMode:YES];
  
  NSMenu *menu = [NSMenu new];
  
  [self setMainMenuItem:[[NSMenuItem alloc] init]];
  [self setMainMenuView:[THMenuItemView new]];
  
  [self.mainMenuItem setView:self.mainMenuView];
  
  [menu addItem:self.mainMenuItem];
  [[self statusBarItem] setMenu:menu];
  
  
  [self setTasksView:[[THPivotalTasksViewController alloc]
                      initWithTableView:self.mainMenuView.pivotalTaskListTable]];
  
  [[[self mainMenuView] settingsButton] setTarget:self];
  [[[self mainMenuView] settingsButton] setAction:@selector(openSettingsDialog)];
  
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
      
      [self.mainMenuView.projectList setDelegate:self];
      [self.mainMenuView.taskList setDelegate:self];
      
      [self.mainMenuView.pivotalProjectList setDelegate:self.tasksView];
      
      [RACObserve(self, selectedProject) subscribeNext:^(id project) {
        
        [[THStore instance] setHarvestProject:project];
        
        [self.mainMenuView.taskList removeAllItems];
        [self.mainMenuView.taskList addItemsWithObjectValues:[[project tasks] map:^id(id task) {
          return [task name];
        }]];
      }];
      
    }
  }];
  
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
    
    [self.mainMenuView.currentTaskTimerLabel setStringValue:NSStringWithFormat(@"%f",_totalHours)];
    
    [self.mainMenuView.projectList addItemsWithObjectValues:[self.harvestProjects map:^id(id object) {
      return [object name];
    }]];
  }];
  
  [[THPivotalProject alloc] getAll:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [self.tasksView setPivotalProjects:[[mappingResult array] mutableCopy]];
    
    [self.mainMenuView.pivotalProjectList addItemsWithObjectValues:[[mappingResult array] map:^ id(id object) {
      return [object name];
    }]];
  }];
  
  
}

-(void) loadProfile
{
  
  [[THHarvestProfile alloc] get:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    THHarvestProfile *profile = [mappingResult firstObject];
    [[self.mainMenuView userNameLabel] setStringValue:[profile displayName]];
    [[self.mainMenuView companyLabel] setStringValue:[profile companyName]];
  
    NSImage *avatar = [[NSImage alloc] initByReferencingURL:[[NSURL alloc] initWithString:profile.avatarUrl]];
    [avatar setSize:NSSizeFromCGSize(CGSizeMake(100, 100))];
    [self.mainMenuView.userImage setImage:avatar];
    
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
  NSArray *objects = @[];
  
  if([[NSBundle mainBundle] loadNibNamed:@"THSettingsView" owner:self topLevelObjects:&objects])
  {
    _settingsView = [objects detect:^BOOL(id object) {
      return [object isKindOfClass:NSView.class];
    }];
    
    [_settingsView setFrame:NSMakeRect(50, 0, 300,138 )];
    [[_settingsView backButton] setAction:@selector(storeSettings)];
    [[_settingsView backButton] setTarget:self];
    
    [@[@[[_settingsView harvestPasswordField], kHarvestPassword],
       @[[_settingsView harvestUsernameField], kHarvestUsername],
       @[[_settingsView harvestSubdomainField], kHarvestSubDomain],
       @[[_settingsView pivotalPasswordField], kPivotalPassword],
       @[[_settingsView pivotalUsernameField], kPivotalUsername]] each:^(id object) {
         NSString  *value = nil;
         
         if ((value = [_defaults objectForKey:object[1]])) {
           [object[0] setStringValue:value];
         };
       }];
    
    
    [self.mainMenuItem setView:_settingsView];
  }

}

-(void) storeSettings
{
  
  [@[@[[_settingsView harvestPasswordField], kHarvestPassword],
    @[[_settingsView harvestUsernameField], kHarvestUsername],
    @[[_settingsView harvestSubdomainField], kHarvestSubDomain],
    @[[_settingsView pivotalPasswordField], kPivotalPassword],
    @[[_settingsView pivotalUsernameField], kPivotalUsername]] each:^(id object) {
      [_defaults setObject:[object[0] stringValue] forKey:object[1]];
    }];
  

  [[THStore instance] setAsSettings:YES];

  [self.mainMenuItem setView:self.mainMenuView];
}
@end
