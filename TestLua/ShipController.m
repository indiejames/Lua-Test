//
//  ShipController.m
//  TestLua
//
//  Created by James Norton on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShipController.h"

@implementation ShipController
@synthesize x, y, speed, name;

-(void) pressLeftButton {
    NSLog(@"Left button pressed for ship %@", self.name);
    self.x = self.x - speed;
}


-(void) pressRightButton {
    NSLog(@"Right button pressed for ship %@", self.name);
    self.x = self.x + speed;
}

-(void) pressTopButton {
    NSLog(@"Top button pressed for ship %@", self.name);
    self.y = self.y + speed;
}

-(void) pressBottomButton {
    NSLog(@"Bottom button pressed for ship %@", self.name);
    self.y = self.y - speed;
}

-(id) initWithX:(float)_x Y:(float)_y Speed:(float)_s Name:(NSString *)_name{
    self = [super init];
    if (self) {
        self.x = _x;
        self.y = _y;
        self.speed = _s;
        self.name = _name;
    }
    
    return self;
}

@end
