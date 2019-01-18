local AISN_Firefly = {}


--setting up a new 'table', the switch between left and the right sprite and giving the thing a width and height (see main.lua for the values) and centering on the screen dividing the resolution by 2
--also setting up the body for our firefly 'object'
function AISN_Firefly.new(self, l, r, w, h)
    o = {}
    self.imgl = l
    self.imgr = r
    self.img = self.imgl
    self.w = w
    self.h = h
    self.cx = self.w/2
    self.cy = self.h/2
-- coordonates of the center after rotation
    self.tr_x = self.cx
    self.tr_y = self.cy
    AISN_Firefly.screen_position = {}
    AISN_Firefly.screen_position.x = playerX/2 - self.cx
    AISN_Firefly.screen_position.y = playerY/2 - self.cy
    
    AISN_Firefly.world_position = {}
    AISN_Firefly.world_position.x = 100
    AISN_Firefly.world_position.y = 100

    AISN_Firefly.velocity = {}
    AISN_Firefly.velocity.x = 0
    AISN_Firefly.velocity.y = 0
    AISN_Firefly.cursorangle = 0

    AISN_Firefly.frontangle = 0
    AISN_Firefly.rotspeed = 0

--AISN_Firefly.health = 50

    AISN_Firefly.body = love.physics.newBody(world, AISN_Firefly.screen_position.x, AISN_Firefly.screen_position.y, "dynamic")
    AISN_Firefly.shape = love.physics.newPolygonShape(AISN_Firefly.w, AISN_Firefly.h, 100, 200, 300, 400)
    AISN_Firefly.fixture = love.physics.newFixture(AISN_Firefly.body, AISN_Firefly.shape, 20)

    setmetatable(o, self)
    self.__index = self
    return o
end


--doing the math to rotate the ship returning the rot value
function calc_rot(x, y)
    curX, curY = love.mouse.getPosition()
    DX = curX - x
    DY = curY - y
    rot = math.atan2(DY, DX) 
    return rot
end


--accelerating our object via the existing velocity values
function AISN_Firefly.accelerate(self, accelx, accely)
    if accelx ~= nil then
        self.velocity.x = self.velocity.x + accelx
    end
    if accely ~= nil then 
        self.velocity.y = self.velocity.y + accely
    end
end


--trying to center the rotation on the center of our ship
function AISN_Firefly.translate_rot(cx, cy, rot)
    orig_rot = math.atan2(cy, cx)
    cursorangle = math.sqrt(cx^2 + cy^2)
    x = cursorangle*math.cos(rot + orig_rot)
    y = cursorangle*math.sin(rot + orig_rot)
    return x, y
end


function AISN_Firefly.convangle(ang)
    if ang > math.pi then
        a = ang - math.pi*2 
    elseif ang < -math.pi then
        a = math.pi*2 - ang
    else a = ang
    end
    return a
end


--here we draw the ship and we try to recenter the ship substracting the translate_rot value
function AISN_Firefly.draw(self)
    love.graphics.draw(myAISN_Firefly.img, AISN_Firefly.screen_position.x - self.tr_x, AISN_Firefly.screen_position.y - self.tr_y, AISN_Firefly.frontangle)
    love.graphics.print(self.cursorangle - self.frontangle)
    love.graphics.print(self.rotspeed, 0, 20)
    love.graphics.print(self.frontangle, 0, 40)
    love.graphics.print(self.cursorangle, 0, 60)
end


--here we make our own update callback, we calculate how fast our ship is going and the rotation with some wisardry
--the we set the position of our body with the screenpositions and adding in the offset
--and finally we determine when to flip the sprites so it always looks upright and we return all of this for main.lua to require
function AISN_Firefly.updateposition(self, dt)
    self.world_position.x = self.world_position.x + dt * self.velocity.x
    self.world_position.y = self.world_position.y + dt * self.velocity.y

    self.cursorangle = calc_rot(self.screen_position.x, self.screen_position.y) + math.pi
--    self.body:setAngle(self.cursorangle)

    ra = self.convangle(self.cursorangle - self.frontangle)
    if ra > 0.01 then
        self.rotspeed = 1
    elseif ra < -0.01 then
        self.rotspeed = -1
    else self.rotspeed = 0
    end

    self.frontangle = self.frontangle + self.rotspeed * dt 
    if self.frontangle > 2*math.pi then
        self.frontangle = self.frontangle - 2*math.pi
    end

    if self.frontangle < 0 then
        self.frontangle =  2*math.pi - self.frontangle
    end
    
    self.tr_x, self.tr_y = self.translate_rot(self.cx, self.cy, self.frontangle)
    

    self.body:setPosition(self.screen_position.x - self.tr_x, self.screen_position.y - self.tr_y)

    if self.frontangle >= 0 and self.frontangle < math.pi/2 then
        self.img = self.imgl
    elseif self.frontangle >= math.pi/2 and self.frontangle < 3*math.pi/2 then
        self.img = self.imgr
    elseif self.frontangle >= 3*math.pi/2 and self.frontangle < 2*math.pi then
        self.img = self.imgl
    end
end

return AISN_Firefly