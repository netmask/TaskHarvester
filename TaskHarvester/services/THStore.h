//
//  THStore.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THHarvestProject.h"
#import "THHarvestTask.h"
#import "THPivotalStory.h"

@interface THStore : NSObject
+ (id)instance;

@property (strong) NSMutableArray *vault;

@property (strong, nonatomic) THHarvestTask *harvestTask;
@property (strong, nonatomic) THHarvestProject *harvestProject;
@property (strong) THPivotalStory *currentActiveStory;

@property BOOL asSettings;


@end
