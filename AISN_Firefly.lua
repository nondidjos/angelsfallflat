local AISN_Firefly = {}


--this is where we set all the values, we're creating a table for calling back later as "self.(...)"
function AISN_Firefly.new(self, l, r, w, h)
    o = {}
    self.imgl = l
    self.imgr = r
    self.img = self.imgl
    self.w = w
    self.h = h
    self.cx = self.w/2
    self.cy = self.h/2
--coordonates of the center after rotation
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

    AISN_Firefly.flightmode = true

--  AISN_Firefly.health = 50
--creating our body
    AISN_Firefly.body = love.physics.newBody(world, AISN_Firefly.screen_position.x, AISN_Firefly.screen_position.y, "dynamic")
    AISN_Firefly.shape = love.physics.newPolygonShape(AISN_Firefly.w, AISN_Firefly.h, 100, 200, 300, 400)
    AISN_Firefly.fixture = love.physics.newFixture(AISN_Firefly.body, AISN_Firefly.shape, 20)

--??? weird stuff
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


--determining which side we need to apply thrust to (+ or -)
function AISN_Firefly.convangle(ang)
    if ang > math.pi then
        a = ang - math.pi*2 
    elseif ang < -math.pi then
        a = math.pi*2 - ang
    else a = ang
    end
    return a
end


--here we draw the ship and we recenter the ship substracting the translate_rot value
function AISN_Firefly.draw(self)
    love.graphics.draw(myAISN_Firefly.img, AISN_Firefly.screen_position.x - self.tr_x, AISN_Firefly.screen_position.y - self.tr_y, AISN_Firefly.frontangle)
--printing values for debugging
    love.graphics.print(self.cursorangle - self.frontangle)
    love.graphics.print("difference btw c.a and f.a", 150, 0)
    love.graphics.print(self.rotspeed, 0, 20)
    love.graphics.print("rotspeed", 40, 20)
    love.graphics.print(self.frontangle, 0, 40)
    love.graphics.print("frontangle", 150, 40)
    love.graphics.print(self.cursorangle, 0, 60)
    love.graphics.print("cursorangle", 150, 60)
    love.graphics.print(self.velocity.x, 0, 80)
    love.graphics.print(self.velocity.y, 100, 80)
    love.graphics.print("x and y velocity", 150, 80)
    if self.flightmode == true then
        love.graphics.print("flight mode true", 0, 100)
    else love.graphics.print("flight mode false", 0, 100)
    end
end


--this is the whole update loop for everything position and rotation related
function AISN_Firefly.updateposition(self, dt)
--calculating the velocity by adding the thrust to the existing velocity and feeding back the world coordonates of the ship
    self.world_position.x = self.world_position.x + dt * self.velocity.x
    self.world_position.y = self.world_position.y + dt * self.velocity.y

    self.cursorangle = calc_rot(self.screen_position.x, self.screen_position.y) + math.pi

--here we use convangle and apply it, adding 2 fields that determine when we start applying rotation to avoid shaking
    ra = self.convangle(self.cursorangle - self.frontangle)
    if ra > 0.01 then
        self.rotspeed = 1
    elseif ra < -0.01 then
        self.rotspeed = -1
    else self.rotspeed = 0
    end

--here we calculate the actual rotate movement with the front angle of the ship, using the rotspeed we set earlier
    self.frontangle = self.frontangle + self.rotspeed * dt 
    if self.frontangle > 2*math.pi then
        self.frontangle = self.frontangle - 2*math.pi
    end

    if self.frontangle < 0 then
        self.frontangle =  2*math.pi - self.frontangle
    end

--here we calculate where we need to locate the rotation point based on the front angle and the base translate rot values
    self.tr_x, self.tr_y = self.translate_rot(self.cx, self.cy, self.frontangle)
--here we center the body correctly using the translate vlues and the screen pos stuff we did earlier
    self.body:setPosition(self.screen_position.x - self.tr_x, self.screen_position.y - self.tr_y)

--here we check wether the ship's angle is pointing to the left or the right and changing the sprite accordingly so it stays upright
    if self.frontangle >= 0 and self.frontangle < math.pi/2 then
        self.img = self.imgl
    elseif self.frontangle >= math.pi/2 and self.frontangle < 3*math.pi/2 then
        self.img = self.imgr
    elseif self.frontangle >= 3*math.pi/2 and self.frontangle < 2*math.pi then
        self.img = self.imgl
    end
end

return AISN_Firefly