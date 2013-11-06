//
//  THPivotalTaskCellView.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalTaskCellView.h"

@implementation THPivotalTaskCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RACObserve(self, entry) subscribeNext:^(THHarvestEntry *entry) {
          if (entry){
            if([entry asTimer]){
              [self.actionButton setStringValue:@"stop"];
              [self.activeIndicator setHidden:NO];
              
              [self.activeIndicator startAnimation:self];
            }else{
              [self.actionButton setStringValue:@"start"];
              [self.activeIndicator setHidden:YES];
              [self.activeIndicator stopAnimation:self];
            }
          }
        }];
      
      [RACObserve(self, story) subscribeNext:^(THPivotalStory *story) {
        [_actionButton setAction:@selector(timerAction:)];
        [_actionButton setTarget:self];
        [_taskName setStringValue:[story name]];
        [_pointsIndicator setIntegerValue:[[story estimate] integerValue]];

      }];
      
      THStore *store = [THStore instance];
      [RACObserve(store, currentActiveStory) subscribeNext:^(THPivotalStory *story) {
        unless([story isEqual:self.story]){
          [self.actionButton setStringValue:@"start"];
          [self.activeIndicator setHidden:YES];
          [self.activeIndicator stopAnimation:self];
        }
      }];
    }
  
    return self;
}


-(void)timerAction:(id) sender
{
  if(self.entry){
    [[self entry] startTimerWithStory:self.story];
  }else{
    [[[THStore instance] harvestTask] createEntryWithPivotalStory:self.story
                                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                            [self setEntry:[mappingResult firstObject]];
                                                            [[THStore instance] setCurrentActiveStory:self.story];
    }];
  }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
  if([_entry asTimer])
    [self.activeIndicator setHidden:NO];
}
@end
