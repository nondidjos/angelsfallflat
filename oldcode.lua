-- version 0.03


-- setting the world's physics
local world = love.physics.newWorld(0, 0, true)

-- getting resolution to center the ship proprely
--local playerX, playerY = love.window.getPosition()
playerX, playerY = love.window.getDesktopDimensions(desktop)

-- setting the size of the ships's hitbox, its "density" aka. mass etc
local AISN_Firefly = {}
    AISN_Firefly.x = playerX/2
    AISN_Firefly.y = playerY/2
    AISN_Firefly.w = -10
    AISN_Firefly.h = -10
    AISN_Firefly.body = love.physics.newBody(world, AISN_Firefly.x, AISN_Firefly.y, "dynamic")
    AISN_Firefly.shape = love.physics.newRectangleShape(AISN_Firefly.w, AISN_Firefly.h)
    AISN_Firefly.fixture = love.physics.newFixture(AISN_Firefly.body, AISN_Firefly.shape, 20)
--    AISN_Firefly.linearDampning = love.physics.setLinearDampning(1)

local Ixion = {}
    Ixion.x = 20
    Ixion.y = 20
    Ixion.w = 20
    Ixion.h = 20
    Ixion.body = love.physics.newBody(world, Ixion.x, Ixion.y, "dynamic")
    Ixion.shape = love.physics.newRectangleShape(Ixion.w, Ixion.h)
    Ixion.fixture = love.physics.newFixture(Ixion.body, Ixion.shape, 60)

local AISN_Khamun = {}
    AISN_Khamun.x = 200
    AISN_Khamun.y = 20
    AISN_Khamun.w = 100
    AISN_Khamun.h = 30
    AISN_Khamun.body = love.physics.newBody(world, AISN_Khamun.x, AISN_Khamun.y, "dynamic")
    AISN_Khamun.shape = love.physics.newRectangleShape(AISN_Khamun.w, AISN_Khamun.h)
    AISN_Khamun.fixture = love.physics.newFixture(AISN_Khamun.body, AISN_Khamun.shape, 100)

local AISN_Anubis = {}
    AISN_Anubis.x = 300
    AISN_Anubis.y = 20
    AISN_Anubis.w = 200
    AISN_Anubis.h = 70
    AISN_Anubis.body = love.physics.newBody(world, AISN_Anubis.x, AISN_Anubis.y, "dynamic")
    AISN_Anubis.shape = love.physics.newRectangleShape(AISN_Anubis.w, AISN_Anubis.h)
    AISN_Anubis.fixture = love.physics.newFixture(AISN_Anubis.body, AISN_Anubis.shape, 200)

local USN_Rapier = {}
    USN_Rapier.x = 400 
    USN_Rapier.y = 20
    USN_Rapier.w = 20
    USN_Rapier.h = 20
    USN_Rapier.body = love.physics.newBody(world, USN_Rapier.w, USN_Rapier.h, "dynamic")
    USN_Rapier.shape = love.physics.newRectangleShape(USN_Rapier.w, USN_Rapier.h)
    USN_Rapier.fixture = love.physics.newFixture(USN_Rapier.body, USN_Rapier.shape, 20)

local AISN_TI = {}
    AISN_TI.x = 200
    AISN_TI.y = 20
    AISN_TI.w = 100
    AISN_TI.h = 30
    AISN_TI.body = love.physics.newBody(world, AISN_TI.x, AISN_TI.y, "dynamic")
    AISN_TI.shape = love.physics.newRectangleShape(AISN_TI.w, AISN_TI.h)
    AISN_TI.fixture = love.physics.newFixture(AISN_TI.body, AISN_TI.shape, 100)

-- loading all of the graphics, giving them a cute name to refer to later
function love.load() 
    skybox = love.graphics.newImage("IXION.png")
    khamun = love.graphics.newImage("something frigate.png")
    firefly = love.graphics.newImage("fighter.png")
    anubis = love.graphics.newImage("anubis.png")
    rapier = love.graphics.newImage("ULA fighter.png")
    TI = love.graphics.newImage("TI corvette.png")

    love.window.setFullscreen(true , "desktop")
end

-- drawing the ships each frame depending on their position on the screen (getX, getY)
function love.draw()
    love.graphics.scale(1.3, 1.3)
    love.graphics.draw(skybox, Ixion.body:getX(), Ixion.body:getY())
    love.graphics.draw(khamun, AISN_Khamun.body:getX(), AISN_Khamun.body:getY())
    love.graphics.draw(firefly, playerX/2/1.3, playerY/2/1.3, AISN_Firefly.r)
    love.graphics.draw(anubis, AISN_Anubis.body:getX(), AISN_Anubis.body:getY())
    love.graphics.draw(rapier, USN_Rapier.body:getX(), USN_Rapier.body:getY())
    love.graphics.draw(TI, AISN_TI.body:getX(), AISN_TI.body:getY())
end

-- calculating the mouse position with  m a t h (broken)
function calc_rot(x, y)
    curX, curY = love.mouse.getPosition()
    DX = curX - x
    DY = curY - y
    rot = math.atan2(DY, DX) 
    return rot
end

-- updating the world every frame to get new jazz and checking for key presses 
function love.update(dt)

--    AISN_Firefly:getLinearDampning()
    world:update(dt)
    AISN_Firefly.r = calc_rot(AISN_Firefly.body:getX(), AISN_Firefly.body:getY())
    AISN_Firefly.body:setAngle(AISN_Firefly.r)

    if love.keyboard.isDown('w') then
        Ixion.body.applyForce(Ixion.body, 0, 4000)
--        love.graphics.translate(0, 4000)
    end
    if love.keyboard.isDown('a') then
        Ixion.body.applyForce(Ixion.body, 4000, 0)
--        love.graphics.translate(4000, 0)
    end
    if love.keyboard.isDown('s') then
        Ixion.body.applyForce(Ixion.body, 0, -4000)
--        love.graphics.translate(0, -4000)
    end
    if love.keyboard.isDown('d') then
        Ixion.body.applyForce(Ixion.body, -4000, 0)
--        love.graphics.translate(-4000, 0)
    end
end