//
//  ViewController.m
//  TestLua
//
//  Created by James Norton on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ShipController.h"

ShipController *playerShipController;

static int l_sin (lua_State *L){
    double d = lua_tonumber(L, 1); // get the argument
    lua_pushnumber(L, 1.0 + sin(d));
    
    return 1;
}


typedef struct SpaceShip {
    ShipController *shipController;
} SpaceShip;

static int newSpaceShip(lua_State *L) {
    
    SpaceShip *ship;
    
    // pull our arguments (x,y) off the stack, checking that they are valid numbers
    float x = luaL_checknumber(L, 1);
    float y = luaL_checknumber(L, 2);
    float speed = luaL_checknumber(L, 3);
    const char *name = luaL_checkstring(L, 4);
    NSString *shipName = [NSString stringWithCString:name encoding:[NSString defaultCStringEncoding]];
    NSLog(@"Created ship named %@", shipName);
    
    // this allocates memory for our struct and leaves it on the stack
    ship = (SpaceShip *)lua_newuserdata(L, sizeof(SpaceShip));
    ship->shipController = [[ShipController alloc] initWithX:x Y:y Speed:speed Name:shipName];
    
    luaL_getmetatable(L, "TestLua.space_ship");
    lua_setmetatable(L, -2);
    
    // we are returning one value (on the stack) from this function
    return 1;
    
}

static int ship_gc (lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    NSString *name = [NSString stringWithFormat:@"%@", ship->shipController.name];
    [ship->shipController release];
    NSLog(@"Ship controller for %@ released", name);
    
    return 0;
}

static int player_ship_position(lua_State *L){
    lua_pushnumber(L, playerShipController.x);
    lua_pushnumber(L, playerShipController.y);
    
    return 2; 
}

static int press_right_button(lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    [ship->shipController pressRightButton];
    
    return 0;
}

static int press_left_button(lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    [ship->shipController pressLeftButton];
    
    return 0;
}

static int press_top_button(lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    [ship->shipController pressTopButton];
    
    return 0;
}

static int press_bottom_button(lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    [ship->shipController pressBottomButton];
    
    return 0;
}

static int get_ship_position(lua_State *L){
    SpaceShip *ship = (SpaceShip *)luaL_checkudata(L, 1, "TestLua.space_ship");
    // push x and y position on the stack
    lua_pushnumber(L, ship->shipController.x);
    lua_pushnumber(L, ship->shipController.y);
    
    // let the caller know how many results are available on the stack
    return 2;
}

static const struct luaL_Reg shiplib_f [] = {
    {"new", newSpaceShip},
    {"player_ship_position", player_ship_position},
    {NULL, NULL}
};

static const struct luaL_Reg shiplib_m [] = {
    {"press_right_button", press_right_button},
    {"press_left_button", press_left_button},
    {"press_top_button", press_top_button},
    {"press_bottom_button", press_bottom_button},
    {"get_ship_position", get_ship_position},
    {NULL, NULL}
};

int luaopen_mylib (lua_State *L){
    luaL_newmetatable(L, "TestLua.space_ship");
    
    // metatable.__index = metatable
    lua_pushvalue(L, -1); // duplicates the metatable
    
    lua_setfield(L, -2, "__index");
    
    luaL_register(L, NULL, shiplib_m);
    
    lua_pushstring(L,"__gc");
    lua_pushcfunction(L, ship_gc);
    lua_settable(L, -3);
    
    luaL_register(L, "space_ship", shiplib_f);
    
    return 1;
}

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)runLoop:(id)sender {
    
   // NSLog(@"Player ship at (%f,%f)", playerShipController.x, playerShipController.y);
    
    // put the pointer to the function we want on top of the stack
    lua_getglobal(L,"update_enemy_ship");
    
    // call the function on top of the stack
    int err = lua_pcall(L, 0, 0, 0);
	if (0 != err) {
		luaL_error(L, "cannot run lua file: %s",
                   lua_tostring(L, -1));
		return;
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    // create the ship for the player
    playerShipController = [[ShipController alloc] initWithX:100 Y:100 Speed:2.0 Name:@"player_ship"];
    
    L = luaL_newstate();
	luaL_openlibs(L);
   
    
    // initialize Lua and our load our lua file
    int err;
    
	lua_settop(L, 0);
    
    NSString *luaFilePath = [[NSBundle mainBundle] pathForResource:@"enemy_ship" ofType:@"lua"];
    
    err = luaL_loadfile(L, [luaFilePath cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	//err = luaL_loadstring(L, "x=mylib.sine(1.55);print(\"Hello, world. - \" .. tostring(x)); return \"ABC\"");
	if (0 != err) {
        luaL_error(L, "cannot compile lua file: %s",
              lua_tostring(L, -1));
		return;
	}
    
	
    err = lua_pcall(L, 0, 0, 0);
	if (0 != err) {
		luaL_error(L, "cannot run lua file: %s",
                   lua_tostring(L, -1));
		return;
	}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

# pragma mark - Button actions
-(void) pressLeftButton:(id) sender {
    [playerShipController pressLeftButton];
}


-(void) pressRightButton:(id) sender {
    [playerShipController pressRightButton];
}

-(void) pressTopButton:(id) sender {
    [playerShipController pressTopButton];
}

-(void) pressBottomButton:(id) sender {
    [playerShipController pressBottomButton];
}


@end
