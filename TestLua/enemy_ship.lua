function update_enemy_ship()
    -- create an enemy ship if it does not already exist
    if enemy_ship == nil then
        print("Creating enemy ship")
        -- create a ship at (x,y) = (110,110) with speed = 1
        enemy_ship = space_ship.new(110,110,1,"enemy_ship")
        
        my_ship = space_ship.new(10,10,1,"my_ship");
        my_ship = nil
        collectgarbage()
    end

    -- get the location of the player's ship
    player_x, player_y = space_ship.player_ship_position()
    
    -- get the location of this (enemy) ship
    x, y = enemy_ship:get_ship_position()
    
    -- print positions to console
    print(string.format("player ship is at (%f, %f)", player_x,player_y))
    print(string.format("enemy ship is at (%f, %f)", x, y))
    
    -- move this ship toward the player
    if player_x < x then
        enemy_ship:press_left_button()
    elseif player_x > x then
        enemy_ship:press_right_button()
    end
    
    if player_y < y then
        enemy_ship:press_bottom_button()
    elseif player_y > y then
        enemy_ship:press_top_button()
    end

    
end


