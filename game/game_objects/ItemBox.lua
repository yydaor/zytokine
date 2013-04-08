ItemBox = class('ItemBox', Entity)
ItemBox:include(PhysicsRectangle)
ItemBox:include(Movable)
ItemBox:include(Logic)

function ItemBox:initialize(chrono, world, x, y, box_type)
    Entity.initialize(self, chrono, x, y)
    self:physicsRectangleInit(world, 'dynamic', ITEMBOXW, ITEMBOXH)
    self:movableInit(ITEMBOXA, ITEMBOX_MAX_VELOCITY, ITEMBOX_GRAVITY_SCALE)
    self:logicInit(1)
    self.box_type = box_type
end

function ItemBox:update(dt)
    self:movableUpdate(dt)
    self:logicUpdate(dt)
end

function ItemBox:draw()
    self:physicsRectangleDraw()
end
