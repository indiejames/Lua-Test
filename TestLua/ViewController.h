//
//  ViewController.h
//  TestLua
//
//  Created by James Norton on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

@interface ViewController : UIViewController{
    lua_State *L;
    NSTimer *timer;
}

-(IBAction)pressLeftButton:(id)sender;
-(IBAction)pressRightButton:(id)sender;
-(IBAction)pressTopButton:(id)sender;
-(IBAction)pressBottomButton:(id)sender;

@end
