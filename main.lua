-- version 0.04
-- by nondidjos


world = love.physics.newWorld(0, 0, true)

playerX, playerY = love.window.getDesktopDimensions(desktop)

AISN_Firefly = require("AISN_Firefly")

function love.load()
    myAISN_Firefly = AISN_Firefly:new(love.graphics.newImage("AISN_Ti_l.png"), love.graphics.newImage("AISN_Ti_r.png"), 186, 78)
--    myAISN_Salamender = AISN_Salamender:new(love.graphics.newImage())
    PIXION = love.graphics.newImage("PIXION.png")
    love.window.setFullscreen(true , "desktop")
end

function love.draw()
    PIXION_x = myAISN_Firefly.screen_position.x - myAISN_Firefly.world_position.x
    PIXION_y = myAISN_Firefly.screen_position.y - myAISN_Firefly.world_position.y

    love.graphics.draw(PIXION, PIXION_x, PIXION_y)

    myAISN_Firefly:draw()
end

function calc_rot(x, y)
    curX, curY = love.mouse.getPosition()
    DX = curX - x
    DY = curY - y
    rot = math.atan2(DY, DX) 
    return rot
end

function love.update(dt)
    world:update(dt)
--    AISN_Firefly:getLinearDampning()

    if love.keyboard.isDown('w') then
        AISN_Firefly:accelerate(0, -5)
    end
    if love.keyboard.isDown('a') then
        AISN_Firefly:accelerate(-5, 0)
    end
    if love.keyboard.isDown('s') then
        AISN_Firefly:accelerate(0, 5)
    end
    if love.keyboard.isDown('d') then
        AISN_Firefly:accelerate(5, 0)
    end

    AISN_Firefly:updateposition(dt)
end
