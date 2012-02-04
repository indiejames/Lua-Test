//
//  ShipController.h
//  TestLua
//
//  Created by James Norton on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipController : NSObject {
    float x;
    float y;
    float speed;
    NSString *name;
}

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float speed;
@property (nonatomic, retain) NSString *name;

-(IBAction)pressLeftButton;
-(IBAction)pressRightButton;
-(IBAction)pressTopButton;
-(IBAction)pressBottomButton;
-(id) initWithX:(float)x Y:(float)y Speed:(float)speed Name:(NSString *)name;

@end
