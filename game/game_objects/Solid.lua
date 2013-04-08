Solid = class('Solid', Entity)
Solid:include(PhysicsRectangle)

function Solid:initialize(chrono, world, x, y, w, h)
    Entity.initialize(self, chrono, x, y)
    self:physicsRectangleInit(world, 'static', w or TILEW, h or TILEH)
end

function Solid:draw()
    self:physicsRectangleDraw()
end
