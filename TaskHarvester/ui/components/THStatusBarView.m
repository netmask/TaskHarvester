//
//  THStatusBarView.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/19/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THStatusBarView.h"

@implementation THStatusBarView

- (id)init
{
    self = [super init];
    if (self) {
      CGFloat height = [NSStatusBar systemStatusBar].thickness;
      
      self = [super initWithFrame:NSMakeRect(0, 0, 22, height)];
      

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSColor redColor] setFill];
  NSRectFill(dirtyRect);
}


- (void)mouseDown:(NSEvent *)theEvent
{

  if (_popover.isShown) {
    [_popover close];
  }else{
    _popover.animates = YES;
    [_popover showRelativeToRect:self.frame ofView:self preferredEdge:NSMinYEdge];
    [self setNeedsDisplay:YES];
  }
}



@end
