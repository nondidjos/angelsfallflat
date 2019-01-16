local AISN_Firefly = {}

--AISN_Firefly.health = 50

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
    self.tr_y = self.cx
    AISN_Firefly.screen_position = {}
    AISN_Firefly.screen_position.x = playerX/2 - self.cx
    AISN_Firefly.screen_position.y = playerY/2 - self.cy

    AISN_Firefly.world_position = {}
    AISN_Firefly.world_position.x = 100
    AISN_Firefly.world_position.y = 100


    AISN_Firefly.velocity = {}
    AISN_Firefly.velocity.x = 0
    AISN_Firefly.velocity.y = 0
    AISN_Firefly.r = 0

    AISN_Firefly.body = love.physics.newBody(world, AISN_Firefly.screen_position.x, AISN_Firefly.screen_position.y, "dynamic")
    AISN_Firefly.shape = love.physics.newRectangleShape(AISN_Firefly.w, AISN_Firefly.h)
    AISN_Firefly.fixture = love.physics.newFixture(AISN_Firefly.body, AISN_Firefly.shape, 20)

    setmetatable(o, self)
    self.__index = self
    return o
end

function AISN_Firefly.accelerate(self, accelx, accely)
    if accelx ~= nil then
        self.velocity.x = self.velocity.x + accelx
    end
    if accely ~= nil then 
        self.velocity.y = self.velocity.y + accely
    end
end

function AISN_Firefly.translate_rot(cx, cy, rot)
    r = math.sqrt(cx^2 + cy^2)
    x = r*math.cos(rot)
    y = r*math.sin(rot)
    return x, y
end

function AISN_Firefly.draw(self)
    
    love.graphics.draw(myAISN_Firefly.img, AISN_Firefly.screen_position.x - self.tr_x, AISN_Firefly.screen_position.y - self.tr_y, AISN_Firefly.r)
end

function AISN_Firefly.updateposition(self, dt)
    self.world_position.x = self.world_position.x + dt * self.velocity.x
    self.world_position.y = self.world_position.y + dt * self.velocity.y

    self.r = calc_rot(self.body:getX(), self.body:getY()) + math.pi
    self.body:setAngle(self.r)

    self.tr_x, self.tr_y = self.translate_rot(self.cx, self.cy, self.r)
    
    self.body:setPosition(self.screen_position.x - self.tr_x, self.screen_position.y - self.tr_y)

    if self.r >= 0 and self.r < math.pi/2 then
        self.img = self.imgl
    elseif self.r >= math.pi/2 and self.r < 3*math.pi/2 then
        self.img = self.imgr
    elseif self.r >= 3*math.pi/2 and self.r < 2*math.pi then
        self.img = self.imgl
    end
end

return AISN_Firefly