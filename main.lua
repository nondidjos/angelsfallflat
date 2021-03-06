-- version 0.08
-- by nondidjos


--we setup the world, get the monitor size and then require all the code we did in AISN_Firefly
world = love.physics.newWorld(0, 0, true)

playerX, playerY = love.window.getDesktopDimensions(desktop)

AISN_Firefly = require("AISN_Firefly")


--here we load the images we need and set the width and height of our object and the things we only need to execute once
function love.load()
    myAISN_Firefly = AISN_Firefly:new(love.graphics.newImage("AISN_Ti_l.png"), love.graphics.newImage("AISN_Ti_r.png"), 186, 78)
--    myAISN_Salamender = AISN_Salamender:new(love.graphics.newImage())
    PIXION = love.graphics.newImage("PIXION.png")
    love.window.setFullscreen(true , "desktop")
end


--we move the world here depending on the screen postions 
function love.draw()
    PIXION_x = myAISN_Firefly.screen_position.x - myAISN_Firefly.world_position.x
    PIXION_y = myAISN_Firefly.screen_position.y - myAISN_Firefly.world_position.y

    love.graphics.draw(PIXION, PIXION_x, PIXION_y)

    myAISN_Firefly:draw()
--    love.graphics.rectangle("fill", myAISN_Firefly.screen_position.x, myAISN_Firefly.screen_position.y, 186, 76)
end


--here we update the world so that the body's position gets movin' and we check for keypresses, applying acceleration to our ship
--then we run the update callback on AISN_Firely
function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown('w') then
        myAISN_Firefly:moveup()
    end
    if love.keyboard.isDown('a') then
        myAISN_Firefly:moveleft()
    end
    if love.keyboard.isDown('s') then
        myAISN_Firefly:movedown()
    end
    if love.keyboard.isDown('d') then
        myAISN_Firefly:moveright()
    end

    if love.keyboard.isDown('escape') then
        love.window.close()
    end
    AISN_Firefly:updateposition(dt)
end

function love.keypressed(k)
    if k == "c" then
        myAISN_Firefly.flightmode = not myAISN_Firefly.flightmode
    end
end