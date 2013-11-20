//
//  THPivotalTaskCellView.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalTaskCellView.h"

@implementation THPivotalTaskCellView{
  THStore *_store;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      _store = [THStore instance];
        [RACObserve(self, entry) subscribeNext:^(THHarvestEntry *entry) {
          if (entry){
            if([entry asTimer]){                        
              [self toggleStart];
            }else{
              [self toggleStop];
            }
          }
        }];

      NSDateFormatter *dateFormatter = [NSDateFormatter new];
      [dateFormatter setDateStyle:NSDateFormatterShortStyle];

      [RACObserve(self, story) subscribeNext:^(THPivotalStory *story) {
        [_actionButton setAction:@selector(timerAction:)];
        [_actionButton setTarget:self];
        [_taskName setStringValue:[story name]];
        [_storyInformation setStringValue:NSStringWithFormat(@"%@ [pts] %@ %@ hours",
                                                             [story estimate] != nil ? [story estimate] : @0 ,
                                                             [dateFormatter stringFromDate:[story createdAt]],
                                                             [_entry hours] != nil ? [_entry hours] : @0)];
  
      }];
      
      [RACObserve(_store, currentActiveStory) subscribeNext:^(id x) {
        if ([self.story isEqual:x]) {
          [self toggleStart];
        }else{
          [self toggleStop];
        }
      }];
    }
  
    return self;
}

-(void)toggleStart
{

  [[self actionButton] setImage:[NSImage imageNamed:@"stop"]];
  [[self activeIndicator] setHidden:NO];
  [[self activeIndicator] startAnimation:self];


}

-(void) toggleStop
{
  [[self actionButton] setImage:[NSImage imageNamed:@"play"]];
  [[self activeIndicator] setHidden:YES];
  [[self activeIndicator] stopAnimation:self];
}

-(void)timerAction:(id) sender
{
  if(self.entry){
    [[self entry] switchTimer:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      self.entry = [mappingResult firstObject];
    }];
  }else{
    [[_store harvestTask] createEntryWithPivotalStory:self.story
                                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                            [self setEntry:[mappingResult firstObject]];
                                                            [[THStore instance] setCurrentActiveStory:self.story];
    }];
  }
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSDictionary *colors = @{@"feature" : [NSColor colorFromHexadecimalValue:@"DFE9F2"],
                           @"bug" : [NSColor colorFromHexadecimalValue:@"FFF0F0"],
                           @"release" : [NSColor colorFromHexadecimalValue:@"DBDBDB"]};
  [(NSColor*)[colors objectForKey:[self.story storyType]] setFill];
  NSRectFill(dirtyRect);
}
@end
