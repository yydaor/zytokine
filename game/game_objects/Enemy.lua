Enemy = class('Enemy', Entity)
Enemy:include(PhysicsRectangle)
Enemy:include(Behavior)
Enemy:include(Movable)
Enemy:include(Logic)

function Enemy:initialize(chrono, world, x, y, direction)
    Entity.initialize(self, chrono, x, y)
    self:physicsRectangleInit(world, 'dynamic', SMALL_ENEMYW, SMALL_ENEMYH)
    self:behaviorInit(direction)
    self:movableInit(SMALL_ENEMYA, SMALL_ENEMY_MAX_VELOCITY, SMALL_ENEMY_GRAVITY_SCALE)
    self:logicInit(1)
end

function Enemy:update(dt)
    self:behaviorUpdate(dt)
    self:movableUpdate(dt)
    self:logicUpdate(dt)
end

function Enemy:draw()
    self:physicsRectangleDraw()
end
