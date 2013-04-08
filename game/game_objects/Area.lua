Area = class('Area', Entity)
Area:include(PhysicsRectangle)
Area:include(PhysicsCircle)
Area:include(MovableAreaProjectile)
Area:include(LogicArea)

function Area:initialize(chrono, world, x, y, angle, area_type, area_subtype, 
                         area_movement_type, area_movement_subtype, area_modifier)
    Entity.initialize(self, x, y)    
    if area_type == 'circle' then self:physicsCircleInit(world, 'dynamic', PROJECTILEW)
    elseif area_type == 'rectangle' then self:physicsRectangleInit(world, 'dynamic', PROJECTILEW, PROJECTILEH) end
    self:movableAreaProjectile(angle, area_movement_type, area_movement_subtype)
    self:logicAreaInit(area_modifier)
end

function Area:update(dt)
    
end

function Area:draw()
    
end
